import gleam/result.{map, try}
import nectar/internal/decoder as decode
import nectar/internal/deserializer as deserialize
import nectar/protocol/api_key.{type ApiKey}
import nectar/protocol/error_code.{type ErrorCode}

pub type Response {
  Response(error_code: ErrorCode, api_keys: List(ResponseApiVersion))
}

pub type ResponseApiVersion {
  ResponseApiVersion(api_key: ApiKey, min_version: Int, max_version: Int)
}

pub fn deserialize(bit_array: BitArray) {
  use #(error_code, bit_array) <- try(deserialize.error_code(bit_array))
  use #(api_keys, _) <- map(decode.array(bit_array, deserialize_api_version))
  Response(error_code, api_keys)
}

fn deserialize_api_version(bit_array: BitArray) {
  use #(api_key, bit_array) <- try(deserialize.api_key(bit_array))
  use #(min_version, bit_array) <- try(decode.int16(bit_array))
  use #(max_version, bit_array) <- map(decode.int16(bit_array))
  let api_version = ResponseApiVersion(api_key, min_version, max_version)
  #(api_version, bit_array)
}
