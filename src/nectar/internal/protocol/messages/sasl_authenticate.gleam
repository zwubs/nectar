import gleam/bytes_builder.{type BytesBuilder}
import gleam/option.{type Option}
import gleam/result.{map, try}
import nectar/internal/decoder as decode
import nectar/internal/deserializer as deserialize
import nectar/internal/encoder as encode
import nectar/protocol/error_code.{type ErrorCode}

pub type Request {
  Request(auth_bytes: BitArray)
}

pub const default_request = Request(<<>>)

pub fn serialize(builder: BytesBuilder, request: Request) {
  encode.bytes(builder, request.auth_bytes)
}

pub type Response {
  Response(
    error_code: ErrorCode,
    error_message: Option(String),
    auth_bytes: BitArray,
  )
}

pub fn deserialize(bit_array: BitArray) {
  use #(error_code, bit_array) <- try(deserialize.error_code(bit_array))
  use #(error_message, bit_array) <- try(decode.nullable_string(bit_array))
  use #(auth_bytes, _) <- map(decode.bytes(bit_array))
  Response(error_code, error_message, auth_bytes)
}
