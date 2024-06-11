import gleam/bit_array
import gleam/bytes_builder.{type BytesBuilder}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

fn int_of_size(builder: BytesBuilder, int: Int, size: Int) -> BytesBuilder {
  bytes_builder.append(builder, <<int:size({ size })>>)
}

pub fn int8(builder: BytesBuilder, int: Int) -> BytesBuilder {
  int_of_size(builder, int, 8)
}

pub fn int16(builder: BytesBuilder, int: Int) -> BytesBuilder {
  int_of_size(builder, int, 16)
}

pub fn int32(builder: BytesBuilder, int: Int) -> BytesBuilder {
  int_of_size(builder, int, 32)
}

pub fn int64(builder: BytesBuilder, int: Int) -> BytesBuilder {
  int_of_size(builder, int, 64)
}

pub fn string(builder: BytesBuilder, string: String) -> BytesBuilder {
  let builder = int16(builder, string.length(string))
  bytes_builder.append(builder, <<string:utf8>>)
}

pub fn nullable_string(
  builder: BytesBuilder,
  string: Option(String),
) -> BytesBuilder {
  case string {
    None -> int16(builder, -1)
    Some(string) -> {
      let builder = int16(builder, string.length(string))
      bytes_builder.append(builder, <<string:utf8>>)
    }
  }
}

pub fn bytes(builder: BytesBuilder, bytes: BitArray) -> BytesBuilder {
  let builder = int32(builder, bit_array.byte_size(bytes))
  bytes_builder.append(builder, bytes)
}

pub fn list(
  builder: BytesBuilder,
  values: List(value),
  serializer: fn(BytesBuilder, value) -> BytesBuilder,
) -> BytesBuilder {
  let builder = int32(builder, list.length(values))
  list_elements(builder, values, serializer)
}

fn list_elements(
  builder: BytesBuilder,
  values: List(value),
  serializer: fn(BytesBuilder, value) -> BytesBuilder,
) {
  case values {
    [first, ..rest] -> {
      let builder = serializer(builder, first)
      list_elements(builder, rest, serializer)
    }
    [] -> builder
  }
}
