import gleam/bytes_builder.{type BytesBuilder}
import gleam/result.{map, try}
import nectar/internal/decoder as decode
import nectar/internal/deserializer as deserialize
import nectar/internal/encoder as encode
import nectar/protocol/error_code.{type ErrorCode}

pub type Request {
  Request(mechanism: String)
}

pub const default_request = Request("")

pub fn serialize(builder: BytesBuilder, request: Request) {
  encode.string(builder, request.mechanism)
}

pub type Response {
  Response(error_code: ErrorCode, mechanisms: List(String))
}

pub fn deserialize(bit_array: BitArray) {
  use #(error_code, bit_array) <- try(deserialize.error_code(bit_array))
  use #(mechanisms, _) <- map(decode.array(bit_array, decode.string))
  Response(error_code, mechanisms)
}
