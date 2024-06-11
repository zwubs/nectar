import gleam/bytes_builder.{type BytesBuilder}
import gleam/result.{map, try}
import nectar/internal/decoder as decode
import nectar/internal/deserializer as deserialize
import nectar/internal/encoder as encode
import nectar/protocol/error_code.{type ErrorCode}

pub type Request {
  Request(topics: List(RequestTopic))
}

pub const default_request = Request([])

pub type RequestTopic {
  RequestTopic(name: String)
}

pub const default_request_topic = RequestTopic("")

pub fn serialize(builder: BytesBuilder, request: Request) {
  encode.list(builder, request.topics, serialize_topic)
}

pub fn serialize_topic(builder: BytesBuilder, request: RequestTopic) {
  encode.string(builder, request.name)
}

pub type Response {
  Response(brokers: List(ResponseBroker), topics: List(ResponseTopic))
}

pub type ResponseBroker {
  ResponseBroker(node_id: Int, host: String, port: Int)
}

pub type ResponseTopic {
  ResponseTopic(
    error: ErrorCode,
    name: String,
    partitions: List(ResponsePartition),
  )
}

pub type ResponsePartition {
  ResponsePartition(
    error_code: ErrorCode,
    partition_index: Int,
    leader_id: Int,
    replica_nodes: List(Int),
    isr_nodes: List(Int),
  )
}

pub fn deserialize(bit_array: BitArray) {
  use #(brokers, bit_array) <- try(decode.array(bit_array, deserialize_broker))
  use #(topics, _) <- map(decode.array(bit_array, deserialize_topic))
  Response(brokers, topics)
}

fn deserialize_broker(bit_array: BitArray) {
  use #(broker_node_id, bit_array) <- try(decode.int32(bit_array))
  use #(broker_host, bit_array) <- try(decode.string(bit_array))
  use #(broker_port, bit_array) <- map(decode.int32(bit_array))
  let broker = ResponseBroker(broker_node_id, broker_host, broker_port)
  #(broker, bit_array)
}

fn deserialize_topic(bit_array: BitArray) {
  use #(error_code, bit_array) <- try(deserialize.error_code(bit_array))
  use #(topic_name, bit_array) <- try(decode.string(bit_array))
  use #(partitions, bit_array) <- map(decode.array(
    bit_array,
    deserialize_partition,
  ))
  let topic = ResponseTopic(error_code, topic_name, partitions)
  #(topic, bit_array)
}

fn deserialize_partition(bit_array: BitArray) {
  use #(error_code, bit_array) <- try(deserialize.error_code(bit_array))
  use #(partition_id, bit_array) <- try(decode.int32(bit_array))
  use #(leader, bit_array) <- try(decode.int32(bit_array))
  use #(replicas, bit_array) <- try(decode.array(bit_array, decode.int32))
  use #(isr, bit_array) <- map(decode.array(bit_array, decode.int32))
  let partition =
    ResponsePartition(error_code, partition_id, leader, replicas, isr)
  #(partition, bit_array)
}
