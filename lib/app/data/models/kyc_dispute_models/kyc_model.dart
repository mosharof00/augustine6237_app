class KycStatusModel {
  final String userId;
  final String kycStatus; // UNVERIFIED, PENDING, VERIFIED, REJECTED
  final String? documentType;
  final String? documentUrl;
  final DateTime? submittedAt;
  final DateTime? verifiedAt;
  final String? rejectionReason;
  final bool canDepositLarge;
  final bool canCreateHighStakes;

  KycStatusModel({
    required this.userId,
    required this.kycStatus,
    this.documentType,
    this.documentUrl,
    this.submittedAt,
    this.verifiedAt,
    this.rejectionReason,
    this.canDepositLarge = false,
    this.canCreateHighStakes = false,
  });

  bool get isVerified => kycStatus == 'VERIFIED';
  bool get isPending => kycStatus == 'PENDING';
  bool get isRejected => kycStatus == 'REJECTED';
  bool get isUnverified => kycStatus == 'UNVERIFIED';

  factory KycStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    final status = data['kyc_status']?.toString().toUpperCase() ?? 'UNVERIFIED';

    return KycStatusModel(
      userId: data['user_id']?.toString() ?? '',
      kycStatus: status,
      documentType: data['document_type']?.toString(),
      documentUrl: data['document_url']?.toString(),
      submittedAt: parseDate(data['submitted_at']),
      verifiedAt: parseDate(data['verified_at']),
      rejectionReason: data['rejection_reason']?.toString(),
      canDepositLarge: data['can_deposit_large'] == true || status == 'VERIFIED',
      canCreateHighStakes:
          data['can_create_high_stakes'] == true || status == 'VERIFIED',
    );
  }
}

class BetDisputeModel {
  final String id;
  final String betId;
  final String? creatorId;
  final String reason;
  final String description;
  final String? evidenceUrl;
  final String status; // OPEN, UNDER_REVIEW, RESOLVED, REJECTED
  final String? resolution;
  final String? resolutionNotes;
  final DateTime? createdAt;
  final String? betTitle;
  final String? creatorName;

  BetDisputeModel({
    required this.id,
    required this.betId,
    this.creatorId,
    required this.reason,
    required this.description,
    this.evidenceUrl,
    required this.status,
    this.resolution,
    this.resolutionNotes,
    this.createdAt,
    this.betTitle,
    this.creatorName,
  });

  bool get isOpen => status == 'OPEN';
  bool get isResolved => status == 'RESOLVED';

  factory BetDisputeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    final betObj = data['bet'] is Map<String, dynamic>
        ? data['bet'] as Map<String, dynamic>
        : null;
    final creatorObj = data['creator'] is Map<String, dynamic>
        ? data['creator'] as Map<String, dynamic>
        : null;

    return BetDisputeModel(
      id: data['id']?.toString() ?? data['dispute_id']?.toString() ?? '',
      betId: data['bet_id']?.toString() ?? '',
      creatorId: data['creator_id']?.toString(),
      reason: data['reason']?.toString() ?? 'INCORRECT_RESULT',
      description: data['description']?.toString() ?? '',
      evidenceUrl: data['evidence_url']?.toString(),
      status: data['status']?.toString().toUpperCase() ?? 'OPEN',
      resolution: data['resolution']?.toString(),
      resolutionNotes: data['resolution_notes']?.toString(),
      createdAt: parseDate(data['created_at']),
      betTitle: betObj?['title']?.toString(),
      creatorName: creatorObj?['name']?.toString() ??
          creatorObj?['username']?.toString(),
    );
  }

  static List<BetDisputeModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final list = json is List
        ? json
        : (json['data'] is List ? json['data'] as List : []);
    return list
        .map((e) => BetDisputeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

