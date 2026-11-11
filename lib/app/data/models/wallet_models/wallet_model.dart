class WalletModel {
  final String userId;
  final String balance;
  final String escrowLocked;
  final String totalDeposited;
  final String totalWithdrawn;
  final String currency;

  WalletModel({
    required this.userId,
    required this.balance,
    required this.escrowLocked,
    required this.totalDeposited,
    required this.totalWithdrawn,
    this.currency = 'USD',
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return WalletModel(
      userId: data['user_id']?.toString() ?? '',
      balance: data['balance']?.toString() ?? '0.00',
      escrowLocked: data['escrow_locked']?.toString() ?? '0.00',
      totalDeposited: data['total_deposited']?.toString() ?? '0.00',
      totalWithdrawn: data['total_withdrawn']?.toString() ?? '0.00',
      currency: data['currency']?.toString() ?? 'USD',
    );
  }

  double get balanceDouble => double.tryParse(balance) ?? 0.0;
  double get escrowLockedDouble => double.tryParse(escrowLocked) ?? 0.0;
  double get totalDepositedDouble => double.tryParse(totalDeposited) ?? 0.0;
  double get totalWithdrawnDouble => double.tryParse(totalWithdrawn) ?? 0.0;
}

class WalletTransactionModel {
  final String id;
  final String? userId;
  final String type;
  final String amount;
  final String currency;
  final String status;
  final String description;
  final String? referenceId;
  final String? destinationDetails;
  final DateTime? createdAt;

  WalletTransactionModel({
    required this.id,
    this.userId,
    required this.type,
    required this.amount,
    this.currency = 'USD',
    required this.status,
    required this.description,
    this.referenceId,
    this.destinationDetails,
    this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      return DateTime.tryParse(value.toString());
    }

    return WalletTransactionModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString(),
      type: json['type']?.toString().toUpperCase() ?? 'DEPOSIT',
      amount: json['amount']?.toString() ?? '0.00',
      currency: json['currency']?.toString() ?? 'USD',
      status: json['status']?.toString().toUpperCase() ?? 'COMPLETED',
      description: json['description']?.toString() ?? 'Transaction',
      referenceId: json['reference_id']?.toString(),
      destinationDetails: json['destination_details']?.toString(),
      createdAt: parseDate(json['created_at']),
    );
  }

  static List<WalletTransactionModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final list = json is List
        ? json
        : (json['data'] is List ? json['data'] as List : []);
    return list
        .map((e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

