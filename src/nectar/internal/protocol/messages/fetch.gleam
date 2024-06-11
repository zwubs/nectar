import gleam/bit_array
import gleam/bytes_builder.{type BytesBuilder}
import gleam/option.{type Option, None, Some}
import gleam/result.{map, try}
import nectar/error
import nectar/internal/decoder as decode
import nectar/internal/deserializer as deserialize
import nectar/internal/encoder as encode
import nectar/protocol/error_code.{type ErrorCode}

pub type Request {
  Request(
    replica_id: Int,
    max_wait_ms: Int,
    min_bytes: Int,
    topics: List(RequestTopic),
  )
}

pub const default_request = Request(-1, 0, 0, [])

pub type RequestTopic {
  RequestTopic(name: String, partitions: List(RequestPartition))
}

pub const default_request_topic = RequestTopic("", [])

pub type RequestPartition {
  RequestPartition(partition: Int, fetch_offset: Int, partition_max_bytes: Int)
}

pub const default_request_partition = RequestPartition(0, 0, 0)

pub fn serialize(builder: BytesBuilder, request: Request) {
  encode.int32(builder, request.replica_id)
  |> encode.int32(request.max_wait_ms)
  |> encode.int32(request.min_bytes)
  |> encode.list(request.topics, serialize_topic)
}

pub fn serialize_topic(builder: BytesBuilder, topic: RequestTopic) {
  encode.string(builder, topic.name)
  |> encode.list(topic.partitions, serialize_partition)
}

pub fn serialize_partition(builder: BytesBuilder, partition: RequestPartition) {
  encode.int32(builder, partition.partition)
  |> encode.int64(partition.fetch_offset)
  |> encode.int32(partition.partition_max_bytes)
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
    high_watermark: Int,
    messages: List(ResponseMessage),
  )
}

pub type ResponseMessage {
  ResponseMessage(
    offset: Int,
    version: Int,
    timestamp: Option(Int),
    key: Option(BitArray),
    value: Option(BitArray),
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
  #(ResponseTopic(name, partitions), bit_array)
}

fn deserialize_partition(bit_array: BitArray) {
  use #(index, bit_array) <- try(decode.int32(bit_array))
  use #(error_code, bit_array) <- try(deserialize.error_code(bit_array))
  use #(high_watermark, bit_array) <- try(decode.int64(bit_array))
  use #(messages, bit_array) <- map(deserialize_message_set(bit_array))
  #(ResponsePartition(index, error_code, high_watermark, messages), bit_array)
}

fn deserialize_message_set(bit_array: BitArray) {
  use #(message_size, bit_array) <- try(decode.int32(bit_array))
  deserialize_message_set_of_size(bit_array, message_size)
}

fn deserialize_message_set_of_size(bit_array: BitArray, byte_size: Int) {
  deserialize_message_set_messages(bit_array, [], byte_size)
}

fn deserialize_message_set_messages(
  bit_array: BitArray,
  messages: List(ResponseMessage),
  byte_size: Int,
) {
  case byte_size {
    s if s < 1 -> Ok(#(messages, bit_array))
    _ -> {
      let initial_byte_size = bit_array.byte_size(bit_array)
      use #(message, bit_array) <- try(deserialize_message(bit_array))
      case message.offset < 0 {
        True -> Ok(#(messages, bit_array))
        False -> {
          let new_byte_size = bit_array.byte_size(bit_array)
          let message_byte_size = initial_byte_size - new_byte_size
          deserialize_message_set_messages(
            bit_array,
            [message, ..messages],
            byte_size - message_byte_size,
          )
        }
      }
    }
  }
}

fn deserialize_message(bit_array: BitArray) {
  use #(offset, bit_array) <- try(decode.int64(bit_array))
  use #(_message_length, bit_array) <- try(decode.int32(bit_array))
  use #(_crc, bit_array) <- try(decode.int32(bit_array))
  use #(magic_byte, bit_array) <- try(decode.int8(bit_array))
  use #(_compression, bit_array) <- try(decode.bits(bit_array, 3))
  use #(_timestamp_format, bit_array) <- try(decode.bits(bit_array, 1))
  use #(_, bit_array) <- try(decode.bits(bit_array, 4))
  use #(timestamp, bit_array) <- try(case magic_byte {
    0 -> Ok(#(None, bit_array))
    1 -> {
      use #(timestamp, bit_array) <- try(decode.int64(bit_array))
      Ok(#(Some(timestamp), bit_array))
    }
    _ -> Error(error.Unknown)
  })
  use #(key, bit_array) <- try(decode.nullable_bytes(bit_array))
  use #(value, bit_array) <- map(decode.nullable_bytes(bit_array))
  #(ResponseMessage(offset, magic_byte, timestamp, key, value), bit_array)
}
