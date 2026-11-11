class GamingSubmissionModel {
  final String playerId;
  final String? gamertag;
  final String platform;
  final int myScore;
  final int opponentScore;
  final String? proofUrl;
  final DateTime? submittedAt;
  final String? playerName;

  GamingSubmissionModel({
    required this.playerId,
    this.gamertag,
    this.platform = 'PLAYSTATION',
    required this.myScore,
    required this.opponentScore,
    this.proofUrl,
    this.submittedAt,
    this.playerName,
  });

  factory GamingSubmissionModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    return GamingSubmissionModel(
      playerId: json['player_id']?.toString() ?? '',
      gamertag: json['gamertag']?.toString(),
      platform: json['platform']?.toString() ?? 'PLAYSTATION',
      myScore: (json['my_score'] as num?)?.toInt() ?? 0,
      opponentScore: (json['opponent_score'] as num?)?.toInt() ?? 0,
      proofUrl: json['proof_url']?.toString(),
      submittedAt: parseDate(json['submitted_at']),
      playerName: json['player_name']?.toString(),
    );
  }

  static List<GamingSubmissionModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final list = json is List
        ? json
        : (json['data'] is List ? json['data'] as List : []);
    return list
        .map((e) => GamingSubmissionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class GamingMatchCheckModel {
  final String betId;
  final String matchStatus; // AWAITING_SUBMISSIONS, AWAITING_OPPONENT, MATCHED, MISMATCH
  final List<GamingSubmissionModel> submissions;
  final String? disputeId;
  final String? winnerId;
  final bool isAutoResolved;
  final bool isAutoDisputed;

  GamingMatchCheckModel({
    required this.betId,
    required this.matchStatus,
    required this.submissions,
    this.disputeId,
    this.winnerId,
    this.isAutoResolved = false,
    this.isAutoDisputed = false,
  });

  bool get isMatched => matchStatus == 'MATCHED';
  bool get isMismatch => matchStatus == 'MISMATCH';
  bool get isAwaitingOpponent => matchStatus == 'AWAITING_OPPONENT';

  factory GamingMatchCheckModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final subList = data['submissions'] is List
        ? (data['submissions'] as List)
            .map((e) =>
                GamingSubmissionModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <GamingSubmissionModel>[];

    final status = data['status']?.toString().toUpperCase() ??
        data['match_status']?.toString().toUpperCase() ??
        'AWAITING_SUBMISSIONS';

    return GamingMatchCheckModel(
      betId: data['bet_id']?.toString() ?? '',
      matchStatus: status,
      submissions: subList,
      disputeId: data['dispute_id']?.toString(),
      winnerId: data['winner_id']?.toString(),
      isAutoResolved: data['is_auto_resolved'] == true || status == 'MATCHED',
      isAutoDisputed: data['is_auto_disputed'] == true || status == 'MISMATCH',
    );
  }
}

