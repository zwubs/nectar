import gleam/bit_array
import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/result.{map, try}
import nectar/error.{type Error}

fn out_of_range(bit_array: BitArray, byte_count: Int) -> error.Error {
  error.BytesOutOfRange(bit_array.byte_size(bit_array), byte_count)
}

type DecodeResult(value) =
  Result(#(value, BitArray), error.Error)

fn int(bit_array: BitArray, bit_count: Int) -> DecodeResult(Int) {
  case bit_array {
    <<int:signed-size(bit_count), bit_array:bytes>> -> {
      Ok(#(int, bit_array))
    }
    _ -> Error(out_of_range(bit_array, bit_count / 8))
  }
}

pub fn int8(bit_array: BitArray) {
  int(bit_array, 8)
}

pub fn int16(bit_array: BitArray) {
  int(bit_array, 16)
}

pub fn int32(bit_array: BitArray) {
  int(bit_array, 32)
}

pub fn int64(bit_array: BitArray) {
  int(bit_array, 64)
}

pub fn unsigned_var_int(bit_array: BitArray) -> DecodeResult(Int) {
  unsigned_var_int_accumulator(bit_array, 0, 0)
}

fn unsigned_var_int_accumulator(
  bit_array: BitArray,
  count: Int,
  acc: Int,
) -> DecodeResult(Int) {
  case bit_array {
    <<1:size(1), int:size(7), bit_array:bits>> -> {
      let new_acc = acc + int.bitwise_shift_left(int, count * 7)
      unsigned_var_int_accumulator(bit_array, count + 1, new_acc)
    }

    <<0:size(1), int:size(7), bit_array:bits>> -> {
      let num = acc + int.bitwise_shift_left(int, count * 7)
      Ok(#(num, bit_array))
    }
    _ -> Error(error.InvalidVarInt)
  }
}

pub fn bits(bit_array: BitArray, bit_count: Int) {
  case bit_array {
    <<bits:bits-size(bit_count), bit_array:bits>> -> {
      Ok(#(bits, bit_array))
    }
    _ -> Error(out_of_range(bit_array, 1))
  }
}

pub fn bytes(bit_array: BitArray) -> DecodeResult(BitArray) {
  use #(length, bit_array) <- try(int32(bit_array))
  bytes_of_length(bit_array, length)
}

pub fn nullable_bytes(bit_array: BitArray) -> DecodeResult(Option(BitArray)) {
  use #(length, bit_array) <- try(int32(bit_array))
  case length {
    -1 -> Ok(#(None, bit_array))
    l if l >= 0 -> {
      use #(bytes, bit_array) <- map(bytes_of_length(bit_array, length))
      #(Some(bytes), bit_array)
    }
    _ -> Error(error.InvalidByteLength(length))
  }
}

fn bytes_of_length(bit_array: BitArray, length: Int) -> DecodeResult(BitArray) {
  case bit_array {
    <<bytes:bytes-size(length), bit_array:bytes>> -> Ok(#(bytes, bit_array))
    _ -> Error(out_of_range(bit_array, length))
  }
}

pub fn string(bit_array: BitArray) -> DecodeResult(String) {
  use #(length, bit_array) <- try(int16(bit_array))
  use #(bytes, bit_array) <- try(bytes_of_length(bit_array, length))
  use string <- map(string_from_bytes(bytes))
  #(string, bit_array)
}

pub fn nullable_string(bit_array: BitArray) -> DecodeResult(Option(String)) {
  use #(length, bit_array) <- try(int16(bit_array))
  case length {
    -1 -> Ok(#(None, bit_array))
    l if l >= 0 -> {
      use #(bytes, bit_array) <- try(bytes_of_length(bit_array, length))
      use string <- map(string_from_bytes(bytes))
      #(Some(string), bit_array)
    }
    _ -> Error(error.InvalidByteLength(length))
  }
}

pub fn compact_string(bit_array: BitArray) -> DecodeResult(String) {
  use #(length, bit_array) <- try(unsigned_var_int(bit_array))
  use #(bytes, bit_array) <- try(bytes_of_length(bit_array, length))
  use string <- map(string_from_bytes(bytes))
  #(string, bit_array)
}

fn string_from_bytes(bytes: BitArray) {
  bit_array.to_string(bytes)
  |> result.replace_error(error.InvalidString)
}

type DecodeArrayResult(value, error) =
  Result(#(List(value), BitArray), error)

type ArrayParser(value, error) =
  fn(BitArray) -> Result(#(value, BitArray), error)

pub fn array(
  bit_array: BitArray,
  parser: ArrayParser(value, error.Error),
) -> DecodeArrayResult(value, error.Error) {
  use #(length, bit_array) <- try(int32(bit_array))
  use #(list, bit_array) <- map(array_of_length(bit_array, parser, length))
  #(list, bit_array)
}

fn array_of_length(
  bit_array: BitArray,
  parser: ArrayParser(value, error),
  length: Int,
) -> DecodeArrayResult(value, error) {
  array_elements(bit_array, parser, [], length)
}

fn array_elements(
  bit_array: BitArray,
  parser: ArrayParser(value, error),
  values: List(value),
  length: Int,
) -> DecodeArrayResult(value, error) {
  case length {
    l if l < 1 -> Ok(#(values, bit_array))
    _ -> {
      use #(value, bit_array) <- try(parser(bit_array))
      array_elements(bit_array, parser, [value, ..values], length - 1)
    }
  }
}
