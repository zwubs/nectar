import gleam/bytes_builder.{type BytesBuilder}
import nectar/internal/encoder as encode
import nectar/protocol/api_key.{type ApiKey}

pub fn request(
  api_key: ApiKey,
  api_version: Int,
  correlation_id: Int,
  client_id: String,
) {
  bytes_builder.new()
  |> serialize_api_key(api_key)
  |> encode.int16(api_version)
  |> encode.int32(correlation_id)
  |> encode.string(client_id)
}

fn serialize_api_key(builder: BytesBuilder, api_key: ApiKey) {
  encode.int16(builder, api_key.to_int(api_key))
}

@external(erlang, "os", "timestamp")
fn erlang_now() -> #(Int, Int, Int)

pub fn now() -> Int {
  let #(megaseconds, seconds, microseconds) = erlang_now()
  let seconds = megaseconds * 1_000_000 + seconds
  let milliseconds = microseconds / 1000
  seconds * 1000 + milliseconds
}
