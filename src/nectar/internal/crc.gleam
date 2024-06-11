import gleam/bit_array
import gleam/int
import gleam/iterator
import gleam/result

const polynomial = 0xEDB88320

pub fn generate(index: Int) -> Int {
  iterator.range(0, 7)
  |> iterator.fold(index, fn(value: Int, _: Int) {
    let shifted_value = int.bitwise_shift_right(value, 1)
    case int.bitwise_and(value, 1) == 1 {
      True -> int.bitwise_exclusive_or(shifted_value, polynomial)
      False -> shifted_value
    }
  })
  |> int.bitwise_and(0xFFFFFFFF)
}

fn decode_byte(bits: BitArray, at: Int) -> Int {
  let segment =
    bit_array.slice(bits, at, 1)
    |> result.unwrap(<<0:size(8)>>)
  let assert <<int:signed-size(8)>> = segment
  int
}

pub fn calculate(bits: BitArray) {
  let crc =
    iterator.range(0, bit_array.byte_size(bits) - 1)
    |> iterator.fold(0xFFFFFFFF, fn(crc: Int, at: Int) {
      let value = decode_byte(bits, at)
      let table_index =
        int.bitwise_and(int.bitwise_exclusive_or(crc, value), 0xFF)
      let table_value = generate(table_index)
      int.bitwise_exclusive_or(int.bitwise_shift_right(crc, 8), table_value)
    })

  int.bitwise_exclusive_or(crc, 0xFFFFFFFF)
}

pub fn verify(bits: BitArray, crc: Int) {
  calculate(bits) == crc
}
