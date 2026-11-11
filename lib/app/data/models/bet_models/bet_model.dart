class BetCreator {
  final String id;
  final String name;
  final String? username;
  final String? avatarUrl;

  BetCreator({
    required this.id,
    required this.name,
    this.username,
    this.avatarUrl,
  });

  factory BetCreator.fromJson(Map<String, dynamic> json) {
    return BetCreator(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString(),
      avatarUrl: json['avatar_url']?.toString() ?? json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar_url': avatarUrl,
    };
  }
}

class BetOutcomeModel {
  final String id;
  final String? betId;
  final String title;
  final String pool;
  final double percent;
  final bool? isWinner;

  BetOutcomeModel({
    required this.id,
    this.betId,
    required this.title,
    required this.pool,
    required this.percent,
    this.isWinner,
  });

  factory BetOutcomeModel.fromJson(Map<String, dynamic> json) {
    return BetOutcomeModel(
      id: json['id']?.toString() ?? '',
      betId: json['bet_id']?.toString(),
      title: json['title']?.toString() ?? '',
      pool: json['pool']?.toString() ?? '0.00',
      percent: (json['percent'] as num?)?.toDouble() ?? 0.0,
      isWinner: json['is_winner'] == true
          ? true
          : (json['is_winner'] == false ? false : null),
    );
  }

  static List<BetOutcomeModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final list = json is List ? json : [];
    return list
        .map((e) => BetOutcomeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class BetParticipantModel {
  final String id;
  final String? betId;
  final String userId;
  final String? outcomeId;
  final String side;
  final String stake;
  final String matchedStake;
  final String unmatchedStake;
  final String matchStatus;
  final String refundedAmount;
  final bool? isWinner;
  final String payoutAmount;
  final String payoutStatus;
  final String grossPayout;
  final String commissionDeducted;
  final String netPayout;
  final DateTime? createdAt;
  final BetCreator? user;

  BetParticipantModel({
    required this.id,
    this.betId,
    required this.userId,
    this.outcomeId,
    required this.side,
    required this.stake,
    this.matchedStake = '0.00',
    this.unmatchedStake = '0.00',
    this.matchStatus = 'UNMATCHED',
    this.refundedAmount = '0.00',
    this.isWinner,
    this.payoutAmount = '0.00',
    this.payoutStatus = 'PENDING',
    this.grossPayout = '0.00',
    this.commissionDeducted = '0.00',
    this.netPayout = '0.00',
    this.createdAt,
    this.user,
  });

  factory BetParticipantModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      return DateTime.tryParse(value.toString());
    }

    return BetParticipantModel(
      id: json['id']?.toString() ?? '',
      betId: json['bet_id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      outcomeId: json['outcome_id']?.toString(),
      side: json['side']?.toString() ?? 'BACK',
      stake: json['stake']?.toString() ?? '0.00',
      matchedStake: json['matched_stake']?.toString() ?? '0.00',
      unmatchedStake: json['unmatched_stake']?.toString() ?? '0.00',
      matchStatus: json['match_status']?.toString() ?? 'UNMATCHED',
      refundedAmount: json['refunded_amount']?.toString() ?? '0.00',
      isWinner: json['is_winner'] == true
          ? true
          : (json['is_winner'] == false ? false : null),
      payoutAmount: json['payout_amount']?.toString() ?? '0.00',
      payoutStatus: json['payout_status']?.toString() ?? 'PENDING',
      grossPayout: json['gross_payout']?.toString() ?? '0.00',
      commissionDeducted: json['commission_deducted']?.toString() ?? '0.00',
      netPayout: json['net_payout']?.toString() ?? '0.00',
      createdAt: parseDate(json['created_at']),
      user: json['user'] is Map<String, dynamic>
          ? BetCreator.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  static List<BetParticipantModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final list = json is List ? json : [];
    return list
        .map((e) => BetParticipantModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class BetModel {
  final String id;
  final String title;
  final String? description;
  final String category;
  final String betType;
  final String creatorId;
  final String status;
  final bool isPrivate;
  final String? inviteCode;
  final DateTime? deadline;
  final String totalPool;
  final String backPool;
  final String opposePool;
  final String matchedPool;
  final String unmatchedPool;
  final String? winningSide;
  final String? winningOutcomeId;
  final DateTime? resolvedAt;
  final String payoutPool;
  final String escrowStatus;
  final String commissionRate;
  final String commissionAmount;
  final bool isFeatured;
  final String country;
  final int commentsCount;
  final DateTime? createdAt;
  final BetCreator? creator;
  final List<BetParticipantModel> participants;
  final List<BetOutcomeModel> outcomes;

  BetModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    this.betType = 'BINARY',
    required this.creatorId,
    required this.status,
    required this.isPrivate,
    this.inviteCode,
    this.deadline,
    required this.totalPool,
    required this.backPool,
    required this.opposePool,
    this.matchedPool = '0.00',
    this.unmatchedPool = '0.00',
    this.winningSide,
    this.winningOutcomeId,
    this.resolvedAt,
    this.payoutPool = '0.00',
    this.escrowStatus = 'LOCKED',
    this.commissionRate = '10.0',
    this.commissionAmount = '0.00',
    this.isFeatured = false,
    this.country = 'GLOBAL',
    required this.commentsCount,
    this.createdAt,
    this.creator,
    this.participants = const [],
    this.outcomes = const [],
  });

  factory BetModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      return DateTime.tryParse(value.toString());
    }

    return BetModel(
      id: data['id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString(),
      category: data['category']?.toString() ?? 'SPORTS',
      betType: data['bet_type']?.toString() ?? 'BINARY',
      creatorId: data['creator_id']?.toString() ?? '',
      status: data['status']?.toString() ?? 'ACTIVE',
      isPrivate: data['is_private'] == true,
      inviteCode: data['invite_code']?.toString(),
      deadline: parseDate(data['deadline']),
      totalPool: data['total_pool']?.toString() ?? '0.00',
      backPool: data['back_pool']?.toString() ?? '0.00',
      opposePool: data['oppose_pool']?.toString() ?? '0.00',
      matchedPool: data['matched_pool']?.toString() ?? '0.00',
      unmatchedPool: data['unmatched_pool']?.toString() ?? '0.00',
      winningSide: data['winning_side']?.toString(),
      winningOutcomeId: data['winning_outcome_id']?.toString(),
      resolvedAt: parseDate(data['resolved_at']),
      payoutPool: data['payout_pool']?.toString() ?? '0.00',
      escrowStatus: data['escrow_status']?.toString() ?? 'LOCKED',
      commissionRate: data['commission_rate']?.toString() ?? '10.0',
      commissionAmount: data['commission_amount']?.toString() ?? '0.00',
      isFeatured: data['is_featured'] == true,
      country: data['country']?.toString() ?? 'GLOBAL',
      commentsCount: (data['comments_count'] as num?)?.toInt() ?? 0,
      createdAt: parseDate(data['created_at']),
      creator: data['creator'] is Map<String, dynamic>
          ? BetCreator.fromJson(data['creator'] as Map<String, dynamic>)
          : null,
      participants: BetParticipantModel.fromJsonList(data['participants']),
      outcomes: BetOutcomeModel.fromJsonList(data['outcomes']),
    );
  }

  static List<BetModel> fromJsonList(dynamic json) {
    final list = json is Map<String, dynamic> && json['data'] is List
        ? json['data'] as List
        : (json is List ? json : []);

    return list
        .map((item) => BetModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  double get totalPoolDouble => double.tryParse(totalPool) ?? 0.0;
  double get backPoolDouble => double.tryParse(backPool) ?? 0.0;
  double get opposePoolDouble => double.tryParse(opposePool) ?? 0.0;
  double get matchedPoolDouble => double.tryParse(matchedPool) ?? 0.0;
  double get unmatchedPoolDouble => double.tryParse(unmatchedPool) ?? 0.0;

  double get backOdds =>
      backPoolDouble > 0 ? (totalPoolDouble / backPoolDouble) : 2.0;
  double get opposeOdds =>
      opposePoolDouble > 0 ? (totalPoolDouble / opposePoolDouble) : 2.0;

  double get backPercent {
    final total = totalPoolDouble;
    if (total <= 0) return 50.0;
    return ((backPoolDouble / total) * 100).clamp(0.0, 100.0);
  }

  /// Keep Back + Oppose display percents totaling 100 (avoids 63+38 rounding).
  double get opposePercent {
    final total = totalPoolDouble;
    if (total <= 0) return 50.0;
    return (100.0 - backPercent).clamp(0.0, 100.0);
  }

  String get timeRemainingText {
    if (deadline == null) return 'No deadline';
    final now = DateTime.now();
    final diff = deadline!.difference(now);

    if (diff.isNegative) return 'Closed';
    if (diff.inDays > 0) return '${diff.inDays}d ${diff.inHours % 24}h left';
    if (diff.inHours > 0) return '${diff.inHours}h ${diff.inMinutes % 60}m left';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m left';
    return '${diff.inSeconds}s left';
  }
}

class BetMatchedStatusModel {
  final String betId;
  final String? betType;
  final String totalPool;
  final String matchedPool;
  final String unmatchedPool;
  final String backPool;
  final String opposePool;
  final String backMatched;
  final String opposeMatched;
  final String backUnmatched;
  final String opposeUnmatched;
  final String backOdds;
  final String opposeOdds;
  final List<BetParticipantModel> participants;

  BetMatchedStatusModel({
    required this.betId,
    this.betType,
    required this.totalPool,
    required this.matchedPool,
    required this.unmatchedPool,
    required this.backPool,
    required this.opposePool,
    required this.backMatched,
    required this.opposeMatched,
    required this.backUnmatched,
    required this.opposeUnmatched,
    required this.backOdds,
    required this.opposeOdds,
    this.participants = const [],
  });

  factory BetMatchedStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return BetMatchedStatusModel(
      betId: data['bet_id']?.toString() ?? '',
      betType: data['bet_type']?.toString(),
      totalPool: data['total_pool']?.toString() ?? '0.00',
      matchedPool: data['matched_pool']?.toString() ?? '0.00',
      unmatchedPool: data['unmatched_pool']?.toString() ?? '0.00',
      backPool: data['back_pool']?.toString() ?? '0.00',
      opposePool: data['oppose_pool']?.toString() ?? '0.00',
      backMatched: data['back_matched']?.toString() ?? '0.00',
      opposeMatched: data['oppose_matched']?.toString() ?? '0.00',
      backUnmatched: data['back_unmatched']?.toString() ?? '0.00',
      opposeUnmatched: data['oppose_unmatched']?.toString() ?? '0.00',
      backOdds: data['back_odds']?.toString() ?? '2.00',
      opposeOdds: data['oppose_odds']?.toString() ?? '2.00',
      participants: BetParticipantModel.fromJsonList(data['participants']),
    );
  }
}

class EscrowPayoutItemModel {
  final String participantId;
  final String userId;
  final String userName;
  final String side;
  final String? outcomeId;
  final String? outcomeTitle;
  final String stake;
  final String matchedStake;
  final String payoutAmount;
  final String profit;
  final double roiPercent;
  final bool? isWinner;
  final String payoutStatus;
  final String grossPayout;
  final String commissionDeducted;
  final String netPayout;

  EscrowPayoutItemModel({
    required this.participantId,
    required this.userId,
    required this.userName,
    required this.side,
    this.outcomeId,
    this.outcomeTitle,
    required this.stake,
    required this.matchedStake,
    required this.payoutAmount,
    required this.profit,
    required this.roiPercent,
    this.isWinner,
    required this.payoutStatus,
    this.grossPayout = '0.00',
    this.commissionDeducted = '0.00',
    this.netPayout = '0.00',
  });

  factory EscrowPayoutItemModel.fromJson(Map<String, dynamic> json) {
    return EscrowPayoutItemModel(
      participantId: json['participant_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? 'Bettor',
      side: json['side']?.toString() ?? 'BACK',
      outcomeId: json['outcome_id']?.toString(),
      outcomeTitle: json['outcome_title']?.toString(),
      stake: json['stake']?.toString() ?? '0.00',
      matchedStake: json['matched_stake']?.toString() ?? '0.00',
      payoutAmount: json['payout_amount']?.toString() ?? '0.00',
      profit: json['profit']?.toString() ?? '0.00',
      roiPercent: (json['roi_percent'] as num?)?.toDouble() ?? 0.0,
      isWinner: json['is_winner'] == true
          ? true
          : (json['is_winner'] == false ? false : null),
      payoutStatus: json['payout_status']?.toString() ?? 'PENDING',
      grossPayout: json['gross_payout']?.toString() ?? '0.00',
      commissionDeducted: json['commission_deducted']?.toString() ?? '0.00',
      netPayout: json['net_payout']?.toString() ?? '0.00',
    );
  }

  static List<EscrowPayoutItemModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final list = json is List ? json : [];
    return list
        .map((e) => EscrowPayoutItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class BetEscrowModel {
  final String betId;
  final String title;
  final String status;
  final String escrowStatus;
  final String totalEscrow;
  final String matchedPool;
  final String unmatchedPool;
  final String payoutPool;
  final String commissionRate;
  final String commissionAmount;
  final String? winningSide;
  final String? winningOutcomeId;
  final DateTime? resolvedAt;
  final int winnersCount;
  final int losersCount;
  final List<EscrowPayoutItemModel> payouts;

  BetEscrowModel({
    required this.betId,
    required this.title,
    required this.status,
    this.escrowStatus = 'LOCKED',
    required this.totalEscrow,
    required this.matchedPool,
    required this.unmatchedPool,
    required this.payoutPool,
    this.commissionRate = '10.0',
    this.commissionAmount = '0.00',
    this.winningSide,
    this.winningOutcomeId,
    this.resolvedAt,
    this.winnersCount = 0,
    this.losersCount = 0,
    this.payouts = const [],
  });

  factory BetEscrowModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      return DateTime.tryParse(value.toString());
    }

    return BetEscrowModel(
      betId: data['bet_id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      status: data['status']?.toString() ?? 'ACTIVE',
      escrowStatus: data['escrow_status']?.toString() ?? 'LOCKED',
      totalEscrow: data['total_escrow']?.toString() ?? '0.00',
      matchedPool: data['matched_pool']?.toString() ?? '0.00',
      unmatchedPool: data['unmatched_pool']?.toString() ?? '0.00',
      payoutPool: data['payout_pool']?.toString() ?? '0.00',
      commissionRate: data['commission_rate']?.toString() ?? '10.0',
      commissionAmount: data['commission_amount']?.toString() ?? '0.00',
      winningSide: data['winning_side']?.toString(),
      winningOutcomeId: data['winning_outcome_id']?.toString(),
      resolvedAt: parseDate(data['resolved_at']),
      winnersCount: (data['winners_count'] as num?)?.toInt() ?? 0,
      losersCount: (data['losers_count'] as num?)?.toInt() ?? 0,
      payouts: EscrowPayoutItemModel.fromJsonList(data['payouts']),
    );
  }
}

class FeeConfigModel {
  final String commissionRate;
  final bool appliesToProfit;
  final String? description;
  final DateTime? updatedAt;

  FeeConfigModel({
    required this.commissionRate,
    required this.appliesToProfit,
    this.description,
    this.updatedAt,
  });

  factory FeeConfigModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      return DateTime.tryParse(value.toString());
    }

    return FeeConfigModel(
      commissionRate: data['commission_rate']?.toString() ?? '10.0',
      appliesToProfit: data['applies_to_profit'] != false,
      description: data['description']?.toString(),
      updatedAt: parseDate(data['updated_at']),
    );
  }
}

class BetParticipantFeeItemModel {
  final String participantId;
  final String userId;
  final String userName;
  final String side;
  final String matchedStake;
  final String grossPayout;
  final String netProfit;
  final String commissionDeducted;
  final String netPayout;

  BetParticipantFeeItemModel({
    required this.participantId,
    required this.userId,
    required this.userName,
    required this.side,
    required this.matchedStake,
    required this.grossPayout,
    required this.netProfit,
    required this.commissionDeducted,
    required this.netPayout,
  });

  factory BetParticipantFeeItemModel.fromJson(Map<String, dynamic> json) {
    return BetParticipantFeeItemModel(
      participantId: json['participant_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? 'Bettor',
      side: json['side']?.toString() ?? 'BACK',
      matchedStake: json['matched_stake']?.toString() ?? '0.00',
      grossPayout: json['gross_payout']?.toString() ?? '0.00',
      netProfit: json['net_profit']?.toString() ?? '0.00',
      commissionDeducted: json['commission_deducted']?.toString() ?? '0.00',
      netPayout: json['net_payout']?.toString() ?? '0.00',
    );
  }

  static List<BetParticipantFeeItemModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final list = json is List ? json : [];
    return list
        .map((e) =>
            BetParticipantFeeItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class BetCommissionModel {
  final String betId;
  final String title;
  final String status;
  final String commissionRate;
  final String grossPayoutPool;
  final String totalCommissionCollected;
  final String netPayoutPool;
  final List<BetParticipantFeeItemModel> participantFees;

  BetCommissionModel({
    required this.betId,
    required this.title,
    required this.status,
    required this.commissionRate,
    required this.grossPayoutPool,
    required this.totalCommissionCollected,
    required this.netPayoutPool,
    this.participantFees = const [],
  });

  factory BetCommissionModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return BetCommissionModel(
      betId: data['bet_id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      status: data['status']?.toString() ?? 'ACTIVE',
      commissionRate: data['commission_rate']?.toString() ?? '10.0',
      grossPayoutPool: data['gross_payout_pool']?.toString() ?? '0.00',
      totalCommissionCollected:
          data['total_commission_collected']?.toString() ?? '0.00',
      netPayoutPool: data['net_payout_pool']?.toString() ?? '0.00',
      participantFees:
          BetParticipantFeeItemModel.fromJsonList(data['participant_fees']),
    );
  }
}
