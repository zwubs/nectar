import nectar

pub type Config {
  Config(cluster: nectar.Cluster, group_id: String, topic: String)
}

pub fn new(cluster: nectar.Cluster, group_id: String) {
  Config(cluster, group_id, "")
}

type Handler =
  fn(nectar.Payload) -> Nil

pub type Consumer {
  Consumer(config: Config, topic: String, handler: Handler)
}

pub fn subscribe(config: Config, topic: String, handler: Handler) {
  Consumer(config, topic, handler)
}
