import gleam/bytes_builder.{type BytesBuilder}
import gleam/result.{map, try}
import nectar/internal/decoder as decode
import nectar/internal/deserializer as deserialize
import nectar/internal/encoder as encode
import nectar/protocol/error_code.{type ErrorCode}

pub type Request {
  Request(replica_id: Int, topics: List(RequestTopic))
}

pub const default_request = Request(0, [])

pub type RequestTopic {
  RequestTopic(name: String, partitions: List(RequestPartition))
}

pub const default_request_topic = RequestTopic("", [])

pub type RequestPartition {
  RequestPartition(partition_index: Int, timestamp: Int, max_num_offsets: Int)
}

pub const default_request_partition = RequestPartition(0, 0, 1)

pub fn serialize(builder: BytesBuilder, request: Request) {
  encode.int32(builder, request.replica_id)
  |> encode.list(request.topics, serialize_topic)
}

fn serialize_topic(builder: BytesBuilder, topic: RequestTopic) {
  encode.string(builder, topic.name)
  |> encode.list(topic.partitions, serialize_partition)
}

fn serialize_partition(builder: BytesBuilder, partition: RequestPartition) {
  encode.int32(builder, partition.partition_index)
  |> encode.int64(partition.timestamp)
  |> encode.int32(partition.max_num_offsets)
}

pub type Response {
  Response(topics: List(ResponseTopic))
}

pub type ResponseTopic {
  ResponseTopic(name: String, partitions: List(ResponsePartition))
}

pub type ResponsePartition {
  ResponsePartition(
    index: Int,
    error_code: ErrorCode,
    old_style_offsets: List(Int),
  )
}

pub fn deserialize(bit_array: BitArray) {
  use #(topics, _) <- map(decode.array(bit_array, deserialize_topic))
  Response(topics)
}

fn deserialize_topic(bit_array: BitArray) {
  use #(name, bit_array) <- try(decode.string(bit_array))
  use #(partitions, bit_array) <- map(decode.array(
    bit_array,
    deserialize_partition,
  ))
  let topic = ResponseTopic(name, partitions)
  #(topic, bit_array)
}

fn deserialize_partition(bit_array: BitArray) {
  use #(index, bit_array) <- try(decode.int32(bit_array))
  use #(error_code, bit_array) <- try(deserialize.error_code(bit_array))
  use #(offsets, bit_array) <- map(decode.array(bit_array, decode.int64))
  let partition = ResponsePartition(index, error_code, offsets)
  #(partition, bit_array)
}
