import mug
import nectar/internal/ssl
import nectar/protocol/error_code

pub type Error {
  BytesOutOfRange(bytes_left: Int, byte_requested: Int)
  InvalidString
  InvalidByteLength(length: Int)
  InvalidVarInt
  PayloadTooBig
  InvalidErrorCode(error_code: Int)
  InvalidApiKey(api_key: Int)
  InvalidResponse(error: Error)
  TCPError(mug_error: mug.Error)
  SSLError(ssl_error: ssl.Error)
  KafkaError(error_code: error_code.ErrorCode)
  TopicNotFound(name: String)
  Unknown
}
