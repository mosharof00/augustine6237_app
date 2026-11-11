class AdminOverviewModel {
  final int totalUsers;
  final int activeBets;
  final double totalEscrowLocked;
  final double totalVolumeTraded;
  final double totalCommissionsEarned;
  final int pendingWithdrawalsCount;
  final int openDisputesCount;
  final int unverifiedKycCount;

  AdminOverviewModel({
    required this.totalUsers,
    required this.activeBets,
    required this.totalEscrowLocked,
    required this.totalVolumeTraded,
    required this.totalCommissionsEarned,
    required this.pendingWithdrawalsCount,
    required this.openDisputesCount,
    required this.unverifiedKycCount,
  });

  factory AdminOverviewModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return AdminOverviewModel(
      totalUsers: (data['total_users'] as num?)?.toInt() ?? 0,
      activeBets: (data['active_bets'] as num?)?.toInt() ?? 0,
      totalEscrowLocked:
          (data['total_escrow_locked'] as num?)?.toDouble() ?? 0.0,
      totalVolumeTraded:
          (data['total_volume_traded'] as num?)?.toDouble() ?? 0.0,
      totalCommissionsEarned:
          (data['total_commissions_earned'] as num?)?.toDouble() ?? 0.0,
      pendingWithdrawalsCount:
          (data['pending_withdrawals_count'] as num?)?.toInt() ?? 0,
      openDisputesCount: (data['open_disputes_count'] as num?)?.toInt() ?? 0,
      unverifiedKycCount: (data['unverified_kyc_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class AdminUserModel {
  final String id;
  final String name;
  final String? email;
  final String? username;
  final String role;
  final String status; // ACTIVE, SUSPENDED
  final String kycStatus;
  final double walletBalance;
  final DateTime? createdAt;

  AdminUserModel({
    required this.id,
    required this.name,
    this.email,
    this.username,
    required this.role,
    required this.status,
    required this.kycStatus,
    required this.walletBalance,
    this.createdAt,
  });

  bool get isActive => status == 'ACTIVE';
  bool get isSuspended => status == 'SUSPENDED';

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    return AdminUserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'User',
      email: json['email']?.toString(),
      username: json['username']?.toString(),
      role: json['role']?.toString() ?? 'CLIENT',
      status: json['status']?.toString().toUpperCase() ?? 'ACTIVE',
      kycStatus: json['kyc_status']?.toString().toUpperCase() ?? 'UNVERIFIED',
      walletBalance: (json['wallet_balance'] as num?)?.toDouble() ?? 0.0,
      createdAt: parseDate(json['created_at']),
    );
  }

  static List<AdminUserModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final list = json is List
        ? json
        : (json['data'] is List ? json['data'] as List : []);
    return list
        .map((e) => AdminUserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class AdminWithdrawalModel {
  final String id;
  final String? userId;
  final String userName;
  final double amount;
  final String currency;
  final String status;
  final String paymentMethod;
  final String destination;
  final DateTime? createdAt;

  AdminWithdrawalModel({
    required this.id,
    this.userId,
    required this.userName,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.destination,
    this.createdAt,
  });

  bool get isPending => status == 'PENDING';

  factory AdminWithdrawalModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    return AdminWithdrawalModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString(),
      userName: json['user_name']?.toString() ?? 'User',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'USD',
      status: json['status']?.toString().toUpperCase() ?? 'PENDING',
      paymentMethod: json['payment_method']?.toString() ?? 'BANK_TRANSFER',
      destination: json['destination']?.toString() ?? 'N/A',
      createdAt: parseDate(json['created_at']),
    );
  }

  static List<AdminWithdrawalModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final list = json is List
        ? json
        : (json['data'] is List ? json['data'] as List : []);
    return list
        .map((e) => AdminWithdrawalModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

