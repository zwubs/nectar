pub type ErrorCode {
  UnknownServerError
  None
  OffsetOutOfRange
  CorruptMessage
  UnknownTopicOrPartition
  InvalidFetchSize
  LeaderNotAvailable
  NotLeaderOrFollower
  RequestTimedOut
  BrokerNotAvailable
  ReplicaNotAvailable
  MessageTooLarge
  StaleControllerEpoch
  OffsetMetadataTooLarge
  NetworkException
  CoordinatorLoadInProgress
  CoordinatorNotAvailable
  NotCoordinator
  InvalidTopicException
  RecordListTooLarge
  NotEnoughReplicas
  NotEnoughReplicasAfterAppend
  InvalidRequiredAcks
  IllegalGeneration
  InconsistentGroupProtocol
  InvalidGroupId
  UnknownMemberId
  InvalidSessionTimeout
  RebalanceInProgress
  InvalidCommitOffsetSize
  TopicAuthorizationFailed
  GroupAuthorizationFailed
  ClusterAuthorizationFailed
  InvalidTimestamp
  UnsupportedSaslMechanism
  IllegalSaslState
  UnsupportedVersion
  TopicAlreadyExists
  InvalidPartitions
  InvalidReplicationFactor
  InvalidReplicaAssignment
  InvalidConfig
  NotController
  InvalidRequest
  UnsupportedForMessageFormat
  PolicyViolation
  OutOfOrderSequenceNumber
  DuplicateSequenceNumber
  InvalidProducerEpoch
  InvalidTxnState
  InvalidProducerIdMapping
  InvalidTransactionTimeout
  ConcurrentTransactions
  TransactionCoordinatorFenced
  TransactionalIdAuthorizationFailed
  SecurityDisabled
  OperationNotAttempted
  KafkaStorageError
  LogDirNotFound
  SaslAuthenticationFailed
  UnknownProducerId
  ReassignmentInProgress
  DelegationTokenAuthDisabled
  DelegationTokenNotFound
  DelegationTokenOwnerMismatch
  DelegationTokenRequestNotAllowed
  DelegationTokenAuthorizationFailed
  DelegationTokenExpired
  InvalidPrincipalType
  NonEmptyGroup
  GroupIdNotFound
  FetchSessionIdNotFound
  InvalidFetchSessionEpoch
  ListenerNotFound
  TopicDeletionDisabled
  FencedLeaderEpoch
  UnknownLeaderEpoch
  UnsupportedCompressionType
  StaleBrokerEpoch
  OffsetNotAvailable
  MemberIdRequired
  PreferredLeaderNotAvailable
  GroupMaxSizeReached
  FencedInstanceId
  EligibleLeadersNotAvailable
  ElectionNotNeeded
  NoReassignmentInProgress
  GroupSubscribedToTopic
  InvalidRecord
  UnstableOffsetCommit
  ThrottlingQuotaExceeded
  ProducerFenced
  ResourceNotFound
  DuplicateResource
  UnacceptableCredential
  InconsistentVoterSet
  InvalidUpdateVersion
  FeatureUpdateFailed
  PrincipalDeserializationFailure
  SnapshotNotFound
  PositionOutOfRange
  UnknownTopicId
  DuplicateBrokerRegistration
  BrokerIdNotRegistered
  InconsistentTopicId
  InconsistentClusterId
  TransactionalIdNotFound
  FetchSessionTopicIdError
  IneligibleReplica
  NewLeaderElected
  OffsetMovedToTieredStorage
  FencedMemberEpoch
  UnreleasedInstanceId
  UnsupportedAssignor
  StaleMemberEpoch
  MismatchedEndpointType
  UnsupportedEndpointType
  UnknownControllerId
  UnknownSubscriptionId
  TelemetryTooLarge
  InvalidRegistration
  Unknown(error_code: Int)
}

pub fn to_int(error_code: ErrorCode) -> Int {
  case error_code {
    UnknownServerError -> -1
    None -> 0
    OffsetOutOfRange -> 1
    CorruptMessage -> 2
    UnknownTopicOrPartition -> 3
    InvalidFetchSize -> 4
    LeaderNotAvailable -> 5
    NotLeaderOrFollower -> 6
    RequestTimedOut -> 7
    BrokerNotAvailable -> 8
    ReplicaNotAvailable -> 9
    MessageTooLarge -> 10
    StaleControllerEpoch -> 11
    OffsetMetadataTooLarge -> 12
    NetworkException -> 13
    CoordinatorLoadInProgress -> 14
    CoordinatorNotAvailable -> 15
    NotCoordinator -> 16
    InvalidTopicException -> 17
    RecordListTooLarge -> 18
    NotEnoughReplicas -> 19
    NotEnoughReplicasAfterAppend -> 20
    InvalidRequiredAcks -> 21
    IllegalGeneration -> 22
    InconsistentGroupProtocol -> 23
    InvalidGroupId -> 24
    UnknownMemberId -> 25
    InvalidSessionTimeout -> 26
    RebalanceInProgress -> 27
    InvalidCommitOffsetSize -> 28
    TopicAuthorizationFailed -> 29
    GroupAuthorizationFailed -> 30
    ClusterAuthorizationFailed -> 31
    InvalidTimestamp -> 32
    UnsupportedSaslMechanism -> 33
    IllegalSaslState -> 34
    UnsupportedVersion -> 35
    TopicAlreadyExists -> 36
    InvalidPartitions -> 37
    InvalidReplicationFactor -> 38
    InvalidReplicaAssignment -> 39
    InvalidConfig -> 40
    NotController -> 41
    InvalidRequest -> 42
    UnsupportedForMessageFormat -> 43
    PolicyViolation -> 44
    OutOfOrderSequenceNumber -> 45
    DuplicateSequenceNumber -> 46
    InvalidProducerEpoch -> 47
    InvalidTxnState -> 48
    InvalidProducerIdMapping -> 49
    InvalidTransactionTimeout -> 50
    ConcurrentTransactions -> 51
    TransactionCoordinatorFenced -> 52
    TransactionalIdAuthorizationFailed -> 53
    SecurityDisabled -> 54
    OperationNotAttempted -> 55
    KafkaStorageError -> 56
    LogDirNotFound -> 57
    SaslAuthenticationFailed -> 58
    UnknownProducerId -> 59
    ReassignmentInProgress -> 60
    DelegationTokenAuthDisabled -> 61
    DelegationTokenNotFound -> 62
    DelegationTokenOwnerMismatch -> 63
    DelegationTokenRequestNotAllowed -> 64
    DelegationTokenAuthorizationFailed -> 65
    DelegationTokenExpired -> 66
    InvalidPrincipalType -> 67
    NonEmptyGroup -> 68
    GroupIdNotFound -> 69
    FetchSessionIdNotFound -> 70
    InvalidFetchSessionEpoch -> 71
    ListenerNotFound -> 72
    TopicDeletionDisabled -> 73
    FencedLeaderEpoch -> 74
    UnknownLeaderEpoch -> 75
    UnsupportedCompressionType -> 76
    StaleBrokerEpoch -> 77
    OffsetNotAvailable -> 78
    MemberIdRequired -> 79
    PreferredLeaderNotAvailable -> 80
    GroupMaxSizeReached -> 81
    FencedInstanceId -> 82
    EligibleLeadersNotAvailable -> 83
    ElectionNotNeeded -> 84
    NoReassignmentInProgress -> 85
    GroupSubscribedToTopic -> 86
    InvalidRecord -> 87
    UnstableOffsetCommit -> 88
    ThrottlingQuotaExceeded -> 89
    ProducerFenced -> 90
    ResourceNotFound -> 91
    DuplicateResource -> 92
    UnacceptableCredential -> 93
    InconsistentVoterSet -> 94
    InvalidUpdateVersion -> 95
    FeatureUpdateFailed -> 96
    PrincipalDeserializationFailure -> 97
    SnapshotNotFound -> 98
    PositionOutOfRange -> 99
    UnknownTopicId -> 100
    DuplicateBrokerRegistration -> 101
    BrokerIdNotRegistered -> 102
    InconsistentTopicId -> 103
    InconsistentClusterId -> 104
    TransactionalIdNotFound -> 105
    FetchSessionTopicIdError -> 106
    IneligibleReplica -> 107
    NewLeaderElected -> 108
    OffsetMovedToTieredStorage -> 109
    FencedMemberEpoch -> 110
    UnreleasedInstanceId -> 111
    UnsupportedAssignor -> 112
    StaleMemberEpoch -> 113
    MismatchedEndpointType -> 114
    UnsupportedEndpointType -> 115
    UnknownControllerId -> 116
    UnknownSubscriptionId -> 117
    TelemetryTooLarge -> 118
    InvalidRegistration -> 119
    Unknown(error_code) -> error_code
  }
}

pub fn from_int(int: Int) -> ErrorCode {
  case int {
    -1 -> UnknownServerError
    0 -> None
    1 -> OffsetOutOfRange
    2 -> CorruptMessage
    3 -> UnknownTopicOrPartition
    4 -> InvalidFetchSize
    5 -> LeaderNotAvailable
    6 -> NotLeaderOrFollower
    7 -> RequestTimedOut
    8 -> BrokerNotAvailable
    9 -> ReplicaNotAvailable
    10 -> MessageTooLarge
    11 -> StaleControllerEpoch
    12 -> OffsetMetadataTooLarge
    13 -> NetworkException
    14 -> CoordinatorLoadInProgress
    15 -> CoordinatorNotAvailable
    16 -> NotCoordinator
    17 -> InvalidTopicException
    18 -> RecordListTooLarge
    19 -> NotEnoughReplicas
    20 -> NotEnoughReplicasAfterAppend
    21 -> InvalidRequiredAcks
    22 -> IllegalGeneration
    23 -> InconsistentGroupProtocol
    24 -> InvalidGroupId
    25 -> UnknownMemberId
    26 -> InvalidSessionTimeout
    27 -> RebalanceInProgress
    28 -> InvalidCommitOffsetSize
    29 -> TopicAuthorizationFailed
    30 -> GroupAuthorizationFailed
    31 -> ClusterAuthorizationFailed
    32 -> InvalidTimestamp
    33 -> UnsupportedSaslMechanism
    34 -> IllegalSaslState
    35 -> UnsupportedVersion
    36 -> TopicAlreadyExists
    37 -> InvalidPartitions
    38 -> InvalidReplicationFactor
    39 -> InvalidReplicaAssignment
    40 -> InvalidConfig
    41 -> NotController
    42 -> InvalidRequest
    43 -> UnsupportedForMessageFormat
    44 -> PolicyViolation
    45 -> OutOfOrderSequenceNumber
    46 -> DuplicateSequenceNumber
    47 -> InvalidProducerEpoch
    48 -> InvalidTxnState
    49 -> InvalidProducerIdMapping
    50 -> InvalidTransactionTimeout
    51 -> ConcurrentTransactions
    52 -> TransactionCoordinatorFenced
    53 -> TransactionalIdAuthorizationFailed
    54 -> SecurityDisabled
    55 -> OperationNotAttempted
    56 -> KafkaStorageError
    57 -> LogDirNotFound
    58 -> SaslAuthenticationFailed
    59 -> UnknownProducerId
    60 -> ReassignmentInProgress
    61 -> DelegationTokenAuthDisabled
    62 -> DelegationTokenNotFound
    63 -> DelegationTokenOwnerMismatch
    64 -> DelegationTokenRequestNotAllowed
    65 -> DelegationTokenAuthorizationFailed
    66 -> DelegationTokenExpired
    67 -> InvalidPrincipalType
    68 -> NonEmptyGroup
    69 -> GroupIdNotFound
    70 -> FetchSessionIdNotFound
    71 -> InvalidFetchSessionEpoch
    72 -> ListenerNotFound
    73 -> TopicDeletionDisabled
    74 -> FencedLeaderEpoch
    75 -> UnknownLeaderEpoch
    76 -> UnsupportedCompressionType
    77 -> StaleBrokerEpoch
    78 -> OffsetNotAvailable
    79 -> MemberIdRequired
    80 -> PreferredLeaderNotAvailable
    81 -> GroupMaxSizeReached
    82 -> FencedInstanceId
    83 -> EligibleLeadersNotAvailable
    84 -> ElectionNotNeeded
    85 -> NoReassignmentInProgress
    86 -> GroupSubscribedToTopic
    87 -> InvalidRecord
    88 -> UnstableOffsetCommit
    89 -> ThrottlingQuotaExceeded
    90 -> ProducerFenced
    91 -> ResourceNotFound
    92 -> DuplicateResource
    93 -> UnacceptableCredential
    94 -> InconsistentVoterSet
    95 -> InvalidUpdateVersion
    96 -> FeatureUpdateFailed
    97 -> PrincipalDeserializationFailure
    98 -> SnapshotNotFound
    99 -> PositionOutOfRange
    100 -> UnknownTopicId
    101 -> DuplicateBrokerRegistration
    102 -> BrokerIdNotRegistered
    103 -> InconsistentTopicId
    104 -> InconsistentClusterId
    105 -> TransactionalIdNotFound
    106 -> FetchSessionTopicIdError
    107 -> IneligibleReplica
    108 -> NewLeaderElected
    109 -> OffsetMovedToTieredStorage
    110 -> FencedMemberEpoch
    111 -> UnreleasedInstanceId
    112 -> UnsupportedAssignor
    113 -> StaleMemberEpoch
    114 -> MismatchedEndpointType
    115 -> UnsupportedEndpointType
    116 -> UnknownControllerId
    117 -> UnknownSubscriptionId
    118 -> TelemetryTooLarge
    119 -> InvalidRegistration
    error_code -> Unknown(error_code)
  }
}
