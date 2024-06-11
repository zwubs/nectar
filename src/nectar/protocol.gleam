import gleam/bit_array
import gleam/bytes_builder
import gleam/io
import gleam/result.{try}
import nectar/connection.{type Connection}
import nectar/internal/deserializer as deserialize
import nectar/internal/protocol/messages/api_versions
import nectar/internal/protocol/messages/describe_groups
import nectar/internal/protocol/messages/fetch
import nectar/internal/protocol/messages/list_groups
import nectar/internal/protocol/messages/list_offsets
import nectar/internal/protocol/messages/metadata
import nectar/internal/protocol/messages/sasl_authenticate
import nectar/internal/protocol/messages/sasl_handshake
import nectar/internal/serializer as serialize
import nectar/protocol/api_key

const client_id = "local-client"

pub fn api_versions(connection: Connection) {
  let request_builder = serialize.request(api_key.ApiVersions, 0, 0, client_id)
  use _ <- try(connection.send(connection, request_builder))
  use response <- try(connection.receive(connection))
  deserialize.response(response, api_versions.deserialize)
}

pub fn sasl_handshake(connection: Connection, request: sasl_handshake.Request) {
  let request_builder =
    serialize.request(api_key.SaslHandshake, 0, 0, client_id)
    |> sasl_handshake.serialize(request)
  use _ <- try(connection.send(connection, request_builder))
  use response <- try(connection.receive(connection))
  deserialize.response(response, sasl_handshake.deserialize)
}

pub fn sasl_authenticate(
  connection: Connection,
  request: sasl_authenticate.Request,
) {
  let request_builder =
    sasl_authenticate.serialize(bytes_builder.new(), request)
  use _ <- try(connection.send_raw(connection, request_builder))
  connection.receive(connection)
  |> result.replace(Nil)
}

pub fn metadata(connection: Connection, request: metadata.Request) {
  let request_builder =
    serialize.request(api_key.Metadata, 0, 0, client_id)
    |> metadata.serialize(request)
  use _ <- try(connection.send(connection, request_builder))
  use response <- try(connection.receive(connection))
  deserialize.response(response, metadata.deserialize)
}

pub fn list_offsets(connection: Connection, request: list_offsets.Request) {
  let request_builder =
    serialize.request(api_key.ListOffsets, 0, 0, client_id)
    |> list_offsets.serialize(request)
  use _ <- try(connection.send(connection, request_builder))
  use response <- try(connection.receive(connection))
  io.debug(bit_array.inspect(response))
  deserialize.response(response, list_offsets.deserialize)
}

pub fn list_groups(connection: Connection) {
  let request_builder = serialize.request(api_key.ListGroups, 0, 0, client_id)
  use _ <- try(connection.send(connection, request_builder))
  use response <- try(connection.receive(connection))
  deserialize.response(response, list_groups.deserialize)
}

pub fn describe_groups(connection: Connection, request: describe_groups.Request) {
  let request_builder =
    serialize.request(api_key.DescribeGroups, 0, 0, client_id)
    |> describe_groups.serialize(request)
  use _ <- try(connection.send(connection, request_builder))
  use response <- try(connection.receive(connection))
  deserialize.response(response, describe_groups.deserialize)
}

pub fn fetch(connection: Connection, request: fetch.Request) {
  let request_builder =
    serialize.request(api_key.Fetch, 0, 0, client_id)
    |> fetch.serialize(request)
  use _ <- try(connection.send(connection, request_builder))
  use response <- try(connection.receive(connection))
  deserialize.response(response, fetch.deserialize)
}
