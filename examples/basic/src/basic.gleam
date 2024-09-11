import gleam/erlang/os
import gleam/io
import gleam/result
import nectar
import nectar/consumer
import nectar/sasl

pub fn main() {
  let assert Ok(host) = os.get_env("KAFKA_HOST")
  let assert Ok(username) = os.get_env("KAFKA_USERNAME")
  let assert Ok(password) = os.get_env("KAFKA_PASSWORD")
  let assert Ok(topic) = os.get_env("KAFKA_TOPIC")

  use cluster <- result.try(
    nectar.new(host, 9092, "local-client-id")
    |> nectar.tls(True)
    |> nectar.sasl(sasl.Plain(username, password))
    |> nectar.connect,
  )

  consumer.new(cluster, "local-group-id")
  |> consumer.subscribe(topic, fn(payload) { todo })

  io.debug(cluster)
  Ok(Nil)
}
