import gleam/bit_array
import gleam/bytes_builder.{type BytesBuilder}
import gleam/int
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

pub fn unsigned_var_int(builder: BytesBuilder, int: Int) -> BytesBuilder {
  unsigned_var_int_accumulator(builder, int)
}

pub fn unsigned_var_int_accumulator(
  builder: BytesBuilder,
  int: Int,
) -> BytesBuilder {
  let segment = int.bitwise_and(int, 0b01111111)
  let int = int.bitwise_shift_right(int, 7)
  let segment = case int {
    0 -> segment
    _ -> int.bitwise_or(segment, 0b10000000)
  }
  let builder = bytes_builder.append(builder, <<segment:int-size(8)>>)
  case int {
    0 -> builder
    _ -> unsigned_var_int_accumulator(builder, int)
  }
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
