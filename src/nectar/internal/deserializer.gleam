import gleam/result.{try}
import nectar/error.{type Error}
import nectar/internal/decoder as decode
import nectar/protocol/api_key
import nectar/protocol/error_code

pub fn response(
  bit_array: BitArray,
  parser: fn(BitArray) -> Result(value, Error),
) {
  use #(_response_size, bit_array) <- try(decode.int32(bit_array))
  use #(_correlation_id, bit_array) <- try(decode.int32(bit_array))
  parser(bit_array)
}

pub fn api_key(bit_array: BitArray) {
  use #(api_key, bit_array) <- try(decode.int16(bit_array))
  Ok(#(api_key.from_int(api_key), bit_array))
}

pub fn error_code(bit_array: BitArray) {
  use #(error_code, bit_array) <- try(decode.int16(bit_array))
  Ok(#(error_code.from_int(error_code), bit_array))
}
