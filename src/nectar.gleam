import gleam/erlang/os
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import nectar/connection
import nectar/error.{type Error}
import nectar/internal/protocol/messages/fetch
import nectar/internal/protocol/messages/list_offsets
import nectar/internal/protocol/messages/metadata
import nectar/internal/protocol/messages/sasl_authenticate
import nectar/internal/protocol/messages/sasl_handshake
import nectar/internal/serializer
import nectar/protocol
import nectar/sasl

pub fn main() {
  io.debug(run())
}

pub opaque type BrokerConfig {
  BrokerConfig(host: String, port: Int)
}

const default_broker_config = BrokerConfig("localhost", 9092)

pub type Sasl {
  Plain
}

pub opaque type ClusterConfig {
  ClusterConfig(
    broker: BrokerConfig,
    client_id: String,
    tls: Bool,
    sasl: Option(sasl.Sasl),
  )
}

const default_cluster_config = ClusterConfig(
  default_broker_config,
  "",
  False,
  None,
)

pub fn new(host: String, port: Int, client_id: String) {
  ClusterConfig(
    ..default_cluster_config,
    broker: BrokerConfig(host, port),
    client_id:,
  )
}

pub fn tls(cluster: ClusterConfig, tls: Bool) {
  ClusterConfig(..cluster, tls:)
}

pub fn sasl(cluster: ClusterConfig, sasl: sasl.Sasl) {
  ClusterConfig(..cluster, sasl: Some(sasl))
}

pub type Cluster {
  Cluster(config: ClusterConfig, connection: connection.Connection)
}

pub fn connect(config: ClusterConfig) {
  use connection <- result.try(connection.new(
    config.broker.host,
    config.broker.port,
    10_000,
    config.tls,
  ))

  let _ = io.debug(protocol.api_versions(connection))

  let sasl_result = case config.sasl {
    None -> Ok(Nil)
    Some(sasl) -> {
      use sasl_handshake_response <- result.try(protocol.sasl_handshake(
        connection,
        sasl_handshake.Request(sasl.get_mechanism(sasl)),
      ))
      use sasl_authenticate_response <- result.try(protocol.sasl_authenticate(
        connection,
        sasl_authenticate.Request(sasl.encode(sasl)),
      ))
      io.debug(sasl_handshake_response)
      io.debug(sasl_authenticate_response)
      Ok(Nil)
    }
  }
  use _ <- result.try(sasl_result)
  Ok(Cluster(config, connection))
}

pub type Message {
  Message(
    offset: Int,
    timestamp: Int,
    key: Option(BitArray),
    value: Option(BitArray),
  )
}

pub type Payload {
  Payload(topic: String, partition: Int, message: Message)
}

fn run() {
  let assert Ok(host) = os.get_env("KAFKA_HOST")
  let assert Ok(username) = os.get_env("KAFKA_USERNAME")
  let assert Ok(password) = os.get_env("KAFKA_PASSWORD")
  let assert Ok(topic) = os.get_env("KAFKA_TOPIC")

  let sasl_handshake_request = sasl_handshake.Request("PLAIN")
  let sasl_authenticate_request =
    sasl_authenticate.Request(<<0, username:utf8, 0, password:utf8>>)

  use connection <- result.try(connection.new(host, 9092, 10_000, True))
  let _ = io.debug(protocol.api_versions(connection))
  let _ = io.debug(protocol.sasl_handshake(connection, sasl_handshake_request))
  let _ =
    io.debug(protocol.sasl_authenticate(connection, sasl_authenticate_request))

  use groups <- result.try(protocol.list_groups(connection))
  io.debug(groups)
  let request = metadata.Request([metadata.RequestTopic(topic)])
  use metadata <- result.try(protocol.metadata(connection, request))
  io.debug(metadata)
  use topic <- try(list.first(metadata.topics))
  use partition <- try(list.first(topic.partitions))
  use broker <- try(
    list.find(metadata.brokers, fn(broker) {
      broker.node_id == partition.leader_id
    }),
  )

  io.debug(broker)
  use broker_connection <- result.try(connection.new(
    broker.host,
    broker.port,
    10_000,
    True,
  ))

  let _ =
    io.debug(protocol.sasl_handshake(broker_connection, sasl_handshake_request))
  let _ =
    io.debug(protocol.sasl_authenticate(
      broker_connection,
      sasl_authenticate_request,
    ))

  let list_offsets_request =
    list_offsets.Request(-1, [
      list_offsets.RequestTopic(topic.name, [
        list_offsets.RequestPartition(
          ..list_offsets.default_request_partition,
          partition_index: partition.partition_index,
          timestamp: serializer.now(),
        ),
      ]),
    ])

  use list_offsets_response <- result.try(
    io.debug(protocol.list_offsets(broker_connection, list_offsets_request)),
  )

  use topic <- try(list.first(list_offsets_response.topics))
  use partitions <- try(
    result.all(
      list.map(topic.partitions, fn(partition) {
        use offset <- try(list.first(partition.old_style_offsets))
        Ok(fetch.RequestPartition(partition.index, offset - 1, 1_048_576))
      }),
    )
    |> result.replace_error(Nil),
  )

  io.debug(partitions)

  let fetch_request =
    fetch.Request(
      ..fetch.default_request,
      max_wait_ms: 10_000,
      topics: [fetch.RequestTopic(topic.name, partitions)],
    )

  use fetch_response <- result.try(
    io.debug(protocol.fetch(broker_connection, fetch_request)),
  )
  io.debug(fetch_response)
  // use group <- try(first_element(groups.groups))
  // use group_descriptions <- result.try(
  //   protocol.describe_groups(connection, [group.id]),
  // )
  // io.debug(group_descriptions)
  Ok(Nil)
}

fn try(
  result: Result(a, Nil),
  apply fun: fn(a) -> Result(b, Error),
) -> Result(b, error.Error) {
  case result {
    Ok(x) -> fun(x)
    _ -> Error(error.Unknown)
  }
}
