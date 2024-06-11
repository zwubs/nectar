import gleam/bytes_builder.{type BytesBuilder}
import gleam/option.{type Option}
import gleam/result.{map, try}
import nectar/internal/decoder as decode
import nectar/internal/deserializer as deserialize
import nectar/internal/encoder as encode
import nectar/protocol/error_code.{type ErrorCode}

pub type Request {
  Request(groups: List(String))
}

pub const default_request = Request([])

pub fn serialize(builder: BytesBuilder, request: Request) {
  encode.list(builder, request.groups, encode.string)
}

pub type Response {
  Response(groups: List(ResponseGroup))
}

pub type ResponseGroup {
  ResponseGroup(
    error_code: ErrorCode,
    id: String,
    state: String,
    protocol_type: String,
    protocol_data: String,
    memebers: List(ResponseMember),
  )
}

pub type ResponseMember {
  ResponseMember(
    id: String,
    client_id: String,
    client_host: String,
    member_metadata: Option(BitArray),
    member_assignment: Option(BitArray),
  )
}

pub fn deserialize(bit_array: BitArray) {
  use #(groups, _) <- map(decode.array(bit_array, deserialize_group))
  Response(groups)
}

pub fn deserialize_group(bit_array: BitArray) {
  use #(error_code, bit_array) <- try(deserialize.error_code(bit_array))
  use #(id, bit_array) <- try(decode.string(bit_array))
  use #(state, bit_array) <- try(decode.string(bit_array))
  use #(protocol_type, bit_array) <- try(decode.string(bit_array))
  use #(protocol_data, bit_array) <- try(decode.string(bit_array))
  use #(members, bit_array) <- map(decode.array(bit_array, deserialize_memeber))
  let group =
    ResponseGroup(error_code, id, state, protocol_type, protocol_data, members)
  #(group, bit_array)
}

pub fn deserialize_memeber(bit_array: BitArray) {
  use #(id, bit_array) <- try(decode.string(bit_array))
  use #(client_id, bit_array) <- try(decode.string(bit_array))
  use #(client_host, bit_array) <- try(decode.string(bit_array))
  use #(member_metadata, bit_array) <- try(decode.nullable_bytes(bit_array))
  use #(member_assignment, bit_array) <- map(decode.nullable_bytes(bit_array))
  let member =
    ResponseMember(
      id,
      client_id,
      client_host,
      member_metadata,
      member_assignment,
    )
  #(member, bit_array)
}
