import gleam/bytes_builder.{type BytesBuilder}
import gleam/dynamic.{type Dynamic}
import mug

pub type SslSocket

pub type Error

pub type TLSOptionName {
  Verify
  Cacerts
}

pub type VerifyValue {
  VerifyPeer
  VerifyNone
}

pub type Cacert

pub type TLSOption =
  #(TLSOptionName, Dynamic)

@external(erlang, "ssl", "start")
pub fn start() -> Result(Nil, Nil)

pub fn upgrade_socket(socket: mug.Socket) {
  let certs = get_cacerts()
  ssl_connect_from_socket(
    socket,
    [#(Verify, dynamic.from(VerifyNone)), #(Cacerts, dynamic.from(certs))],
    10_000,
  )
}

@external(erlang, "public_key", "cacerts_get")
fn get_cacerts() -> Cacert

@external(erlang, "ssl", "connect")
fn ssl_connect_from_socket(
  socket: mug.Socket,
  options: List(TLSOption),
  timeout: Int,
) -> Result(SslSocket, Error)

pub fn send(socket: SslSocket, packet: BitArray) -> Result(Nil, Error) {
  send_builder(socket, bytes_builder.from_bit_array(packet))
}

@external(erlang, "ssl_ffi", "send")
pub fn send_builder(
  socket: SslSocket,
  packet: BytesBuilder,
) -> Result(Nil, Error)

pub fn receive(
  socket: SslSocket,
  timeout_milliseconds timeout: Int,
) -> Result(BitArray, Error) {
  ssl_receive(socket, 0, timeout_milliseconds: timeout)
}

@external(erlang, "ssl", "recv")
fn ssl_receive(
  socket: SslSocket,
  read_bytes_num: Int,
  timeout_milliseconds timeout: Int,
) -> Result(BitArray, Error)
