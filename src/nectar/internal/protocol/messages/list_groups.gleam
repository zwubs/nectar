import gleam/result.{map, try}
import nectar/internal/decoder as decode
import nectar/internal/deserializer as deserialize
import nectar/protocol/error_code.{type ErrorCode}

pub type Response {
  Response(error_code: ErrorCode, groups: List(ResponseGroup))
}

pub type ResponseGroup {
  ResponseGroup(id: String, protocol_type: String)
}

pub fn deserialize(bit_array: BitArray) {
  use #(error_code, bit_array) <- try(deserialize.error_code(bit_array))
  use #(groups, _) <- map(decode.array(bit_array, deserialize_group))
  Response(error_code, groups)
}

pub fn deserialize_group(bit_array: BitArray) {
  use #(id, bit_array) <- try(decode.string(bit_array))
  use #(protocol_type, bit_array) <- map(decode.string(bit_array))
  #(ResponseGroup(id, protocol_type), bit_array)
}
