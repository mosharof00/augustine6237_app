class PaymentMethodModel {
  final String id;
  final String name;
  final String provider;
  final String type;
  final List<String> currencies;
  final double minDeposit;
  final double maxDeposit;
  final String feePercent;
  final String processingTime;
  final bool isEnabled;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.provider,
    required this.type,
    required this.currencies,
    required this.minDeposit,
    required this.maxDeposit,
    required this.feePercent,
    required this.processingTime,
    required this.isEnabled,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    final list = json['currencies'] as List? ?? [];
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      currencies: list.map((e) => e.toString()).toList(),
      minDeposit: (json['min_deposit'] as num?)?.toDouble() ?? 5.0,
      maxDeposit: (json['max_deposit'] as num?)?.toDouble() ?? 10000.0,
      feePercent: json['fee_percent']?.toString() ?? '0.00',
      processingTime: json['processing_time']?.toString() ?? 'Instant',
      isEnabled: json['is_enabled'] as bool? ?? true,
    );
  }

  static List<PaymentMethodModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final dynamic source = json is Map<String, dynamic> && json.containsKey('methods')
        ? json['methods']
        : (json is Map<String, dynamic> && json.containsKey('data') && json['data'] is Map<String, dynamic> && json['data'].containsKey('methods')
            ? json['data']['methods']
            : json);

    if (source is! List) return [];
    return source
        .map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class StripeIntentModel {
  final String paymentIntentId;
  final String clientSecret;
  final String amount;
  final String currency;
  final String transactionId;

  StripeIntentModel({
    required this.paymentIntentId,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.transactionId,
  });

  factory StripeIntentModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return StripeIntentModel(
      paymentIntentId: data['payment_intent_id']?.toString() ?? '',
      clientSecret: data['client_secret']?.toString() ?? '',
      amount: data['amount']?.toString() ?? '0.00',
      currency: data['currency']?.toString() ?? 'USD',
      transactionId: data['transaction_id']?.toString() ?? '',
    );
  }
}

class BankInstructionsModel {
  final String beneficiaryName;
  final String bankName;
  final String swiftBic;
  final String iban;
  final String accountNumber;
  final String routingNumber;
  final String referencePrefix;
  final String notes;

  BankInstructionsModel({
    required this.beneficiaryName,
    required this.bankName,
    required this.swiftBic,
    required this.iban,
    required this.accountNumber,
    required this.routingNumber,
    required this.referencePrefix,
    required this.notes,
  });

  factory BankInstructionsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return BankInstructionsModel(
      beneficiaryName: data['beneficiary_name']?.toString() ?? '',
      bankName: data['bank_name']?.toString() ?? '',
      swiftBic: data['swift_bic']?.toString() ?? '',
      iban: data['iban']?.toString() ?? '',
      accountNumber: data['account_number']?.toString() ?? '',
      routingNumber: data['routing_number']?.toString() ?? '',
      referencePrefix: data['reference_prefix']?.toString() ?? 'BS-DEPOSIT-',
      notes: data['notes']?.toString() ?? '',
    );
  }
}

class CryptoAddressModel {
  final String cryptocurrency;
  final String network;
  final String depositAddress;
  final String? memoOrTag;
  final String minDeposit;
  final int estimatedConfirmations;

  CryptoAddressModel({
    required this.cryptocurrency,
    required this.network,
    required this.depositAddress,
    this.memoOrTag,
    required this.minDeposit,
    required this.estimatedConfirmations,
  });

  factory CryptoAddressModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return CryptoAddressModel(
      cryptocurrency: data['cryptocurrency']?.toString() ?? 'USDT',
      network: data['network']?.toString() ?? 'POLYGON',
      depositAddress: data['deposit_address']?.toString() ?? '',
      memoOrTag: data['memo_or_tag']?.toString(),
      minDeposit: data['min_deposit']?.toString() ?? '10.00',
      estimatedConfirmations: (data['estimated_confirmations'] as num?)?.toInt() ?? 64,
    );
  }
}

class PaymentConfirmResultModel {
  final String transactionId;
  final String amount;
  final String newBalance;
  final String currency;
  final String status;
  final String referenceNumber;

  PaymentConfirmResultModel({
    required this.transactionId,
    required this.amount,
    required this.newBalance,
    required this.currency,
    required this.status,
    required this.referenceNumber,
  });

  factory PaymentConfirmResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return PaymentConfirmResultModel(
      transactionId: data['transaction_id']?.toString() ?? '',
      amount: data['amount']?.toString() ?? '0.00',
      newBalance: data['new_balance']?.toString() ?? '0.00',
      currency: data['currency']?.toString() ?? 'USD',
      status: data['status']?.toString() ?? 'COMPLETED',
      referenceNumber: data['reference_number']?.toString() ?? '',
    );
  }
}

