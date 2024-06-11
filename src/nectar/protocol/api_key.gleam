pub type ApiKey {
  Produce
  Fetch
  ListOffsets
  Metadata
  LeaderAndIsr
  StopReplica
  UpdateMetadata
  ControlledShutdown
  OffsetCommit
  OffsetFetch
  FindCoordinator
  JoinGroup
  Heartbeat
  LeaveGroup
  SyncGroup
  DescribeGroups
  ListGroups
  SaslHandshake
  ApiVersions
  CreateTopics
  DeleteTopics
  DeleteRecords
  InitProducerId
  OffsetForLeaderEpoch
  AddPartitionsToTxn
  AddOffsetsToTxn
  EndTxn
  WriteTxnMarkers
  TxnOffsetCommit
  DescribeAcls
  CreateAcls
  DeleteAcls
  DescribeConfigs
  AlterConfigs
  AlterReplicaLogDirs
  DescribeLogDirs
  SaslAuthenticate
  CreatePartitions
  CreateDelegationToken
  RenewDelegationToken
  ExpireDelegationToken
  DescribeDelegationToken
  DeleteGroups
  ElectLeaders
  IncrementalAlterConfigs
  AlterPartitionReassignments
  ListPartitionReassignments
  OffsetDelete
  DescribeClientQuotas
  AlterClientQuotas
  DescribeUserScramCredentials
  AlterUserScramCredentials
  DescribeQuorum
  AlterPartition
  UpdateFeatures
  Envelope
  DescribeCluster
  DescribeProducers
  UnregisterBroker
  DescribeTransactions
  ListTransactions
  AllocateProducerIds
  ConsumerGroupHeartbeat
  ConsumerGroupDescribe
  GetTelemetrySubscriptions
  PushTelemetry
  ListClientMetricsResources
  Unknown(api_key: Int)
}

pub fn to_int(api_key: ApiKey) -> Int {
  case api_key {
    Produce -> 0
    Fetch -> 1
    ListOffsets -> 2
    Metadata -> 3
    LeaderAndIsr -> 4
    StopReplica -> 5
    UpdateMetadata -> 6
    ControlledShutdown -> 7
    OffsetCommit -> 8
    OffsetFetch -> 9
    FindCoordinator -> 10
    JoinGroup -> 11
    Heartbeat -> 12
    LeaveGroup -> 13
    SyncGroup -> 14
    DescribeGroups -> 15
    ListGroups -> 16
    SaslHandshake -> 17
    ApiVersions -> 18
    CreateTopics -> 19
    DeleteTopics -> 20
    DeleteRecords -> 21
    InitProducerId -> 22
    OffsetForLeaderEpoch -> 23
    AddPartitionsToTxn -> 24
    AddOffsetsToTxn -> 25
    EndTxn -> 26
    WriteTxnMarkers -> 27
    TxnOffsetCommit -> 28
    DescribeAcls -> 29
    CreateAcls -> 30
    DeleteAcls -> 31
    DescribeConfigs -> 32
    AlterConfigs -> 33
    AlterReplicaLogDirs -> 34
    DescribeLogDirs -> 35
    SaslAuthenticate -> 36
    CreatePartitions -> 37
    CreateDelegationToken -> 38
    RenewDelegationToken -> 39
    ExpireDelegationToken -> 40
    DescribeDelegationToken -> 41
    DeleteGroups -> 42
    ElectLeaders -> 43
    IncrementalAlterConfigs -> 44
    AlterPartitionReassignments -> 45
    ListPartitionReassignments -> 46
    OffsetDelete -> 47
    DescribeClientQuotas -> 48
    AlterClientQuotas -> 49
    DescribeUserScramCredentials -> 50
    AlterUserScramCredentials -> 51
    DescribeQuorum -> 55
    AlterPartition -> 56
    UpdateFeatures -> 57
    Envelope -> 58
    DescribeCluster -> 60
    DescribeProducers -> 61
    UnregisterBroker -> 64
    DescribeTransactions -> 65
    ListTransactions -> 66
    AllocateProducerIds -> 67
    ConsumerGroupHeartbeat -> 68
    ConsumerGroupDescribe -> 69
    GetTelemetrySubscriptions -> 71
    PushTelemetry -> 72
    ListClientMetricsResources -> 74
    Unknown(api_key) -> api_key
  }
}

pub fn from_int(int: Int) -> ApiKey {
  case int {
    0 -> Produce
    1 -> Fetch
    2 -> ListOffsets
    3 -> Metadata
    4 -> LeaderAndIsr
    5 -> StopReplica
    6 -> UpdateMetadata
    7 -> ControlledShutdown
    8 -> OffsetCommit
    9 -> OffsetFetch
    10 -> FindCoordinator
    11 -> JoinGroup
    12 -> Heartbeat
    13 -> LeaveGroup
    14 -> SyncGroup
    15 -> DescribeGroups
    16 -> ListGroups
    17 -> SaslHandshake
    18 -> ApiVersions
    19 -> CreateTopics
    20 -> DeleteTopics
    21 -> DeleteRecords
    22 -> InitProducerId
    23 -> OffsetForLeaderEpoch
    24 -> AddPartitionsToTxn
    25 -> AddOffsetsToTxn
    26 -> EndTxn
    27 -> WriteTxnMarkers
    28 -> TxnOffsetCommit
    29 -> DescribeAcls
    30 -> CreateAcls
    31 -> DeleteAcls
    32 -> DescribeConfigs
    33 -> AlterConfigs
    34 -> AlterReplicaLogDirs
    35 -> DescribeLogDirs
    36 -> SaslAuthenticate
    37 -> CreatePartitions
    38 -> CreateDelegationToken
    39 -> RenewDelegationToken
    40 -> ExpireDelegationToken
    41 -> DescribeDelegationToken
    42 -> DeleteGroups
    43 -> ElectLeaders
    44 -> IncrementalAlterConfigs
    45 -> AlterPartitionReassignments
    46 -> ListPartitionReassignments
    47 -> OffsetDelete
    48 -> DescribeClientQuotas
    49 -> AlterClientQuotas
    50 -> DescribeUserScramCredentials
    51 -> AlterUserScramCredentials
    55 -> DescribeQuorum
    56 -> AlterPartition
    57 -> UpdateFeatures
    58 -> Envelope
    60 -> DescribeCluster
    61 -> DescribeProducers
    64 -> UnregisterBroker
    65 -> DescribeTransactions
    66 -> ListTransactions
    67 -> AllocateProducerIds
    68 -> ConsumerGroupHeartbeat
    69 -> ConsumerGroupDescribe
    71 -> GetTelemetrySubscriptions
    72 -> PushTelemetry
    74 -> ListClientMetricsResources
    _ -> Unknown(int)
  }
}
