import gleam/bytes_builder.{type BytesBuilder}
import gleam/result.{try}
import mug
import nectar/error.{type Error}
import nectar/internal/decoder as decode
import nectar/internal/ssl

pub opaque type Connection {
  Connection(socket: Socket, timeout: Int)
}

pub opaque type Socket {
  Tcp(socket: mug.Socket)
  Tls(socket: ssl.SslSocket)
}

pub fn new(
  host: String,
  port: Int,
  timeout: Int,
  tls: Bool,
) -> Result(Connection, Error) {
  use tcp_socket <- result.try({
    mug.new(host, port)
    |> mug.timeout(timeout)
    |> mug.connect()
    |> wrap_mug_result
  })
  case tls {
    True -> {
      let _ = ssl.start()
      use tls_socket <- try({
        ssl.upgrade_socket(tcp_socket)
        |> wrap_ssl_result
      })
      Ok(Connection(Tls(tls_socket), timeout))
    }
    False -> Ok(Connection(Tcp(tcp_socket), timeout))
  }
}

pub fn send(connection: Connection, builder: BytesBuilder) -> Result(Nil, Error) {
  let builder_size = bytes_builder.byte_size(builder)
  let builder = bytes_builder.prepend(builder, <<builder_size:size(32)>>)
  send_raw(connection, builder)
}

pub fn send_raw(
  connection: Connection,
  builder: BytesBuilder,
) -> Result(Nil, Error) {
  case connection.socket {
    Tls(socket) -> {
      ssl.send_builder(socket, builder)
      |> wrap_ssl_result
    }
    Tcp(socket) -> {
      mug.send_builder(socket, builder)
      |> wrap_mug_result
    }
  }
}

pub fn receive(connection: Connection) -> Result(BitArray, Error) {
  let builder = bytes_builder.new()
  use packet <- result.try(receive_packet(connection))
  use #(response_size, _) <- result.try(decode.int32(packet))
  let payload_size = response_size + 4
  let builder = bytes_builder.append(builder, packet)
  use builder <- result.try({
    case bytes_builder.byte_size(builder) {
      i if i >= payload_size -> Ok(builder)
      _ -> receive_loop(connection, builder, payload_size)
    }
  })
  Ok(bytes_builder.to_bit_array(builder))
}

fn receive_loop(
  connection: Connection,
  builder: BytesBuilder,
  payload_size: Int,
) -> Result(BytesBuilder, Error) {
  use packet <- result.try(receive_packet(connection))
  let builder = bytes_builder.append(builder, packet)
  case bytes_builder.byte_size(builder) {
    i if i == payload_size -> Ok(builder)
    i if i > payload_size -> Error(error.PayloadTooBig)
    _ -> receive_loop(connection, builder, payload_size)
  }
}

fn receive_packet(connection: Connection) -> Result(BitArray, Error) {
  case connection.socket {
    Tls(socket) -> {
      ssl.receive(socket, connection.timeout)
      |> wrap_ssl_result
    }
    Tcp(socket) -> {
      mug.receive(socket, connection.timeout)
      |> wrap_mug_result
    }
  }
}

fn wrap_mug_result(result: Result(value, mug.Error)) -> Result(value, Error) {
  result.map_error(result, fn(error) { error.TCPError(error) })
}

fn wrap_ssl_result(result: Result(value, ssl.Error)) -> Result(value, Error) {
  result.map_error(result, fn(error) { error.SSLError(error) })
}
