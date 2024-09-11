pub type Sasl {
  Plain(username: String, password: String)
}

pub fn get_mechanism(sasl: Sasl) {
  case sasl {
    Plain(..) -> "PLAIN"
  }
}

pub fn encode(sasl: Sasl) {
  case sasl {
    Plain(username, password) -> <<0, username:utf8, 0, password:utf8>>
  }
}
