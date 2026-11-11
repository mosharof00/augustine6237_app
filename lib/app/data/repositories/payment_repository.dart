import 'package:augustine6237/app/core/network/api_client.dart';
import 'package:augustine6237/app/core/network/api_endpoints.dart';
import 'package:augustine6237/app/data/models/payment_models/payment_model.dart';

abstract class IPaymentRepository {
  Future<List<PaymentMethodModel>> getPaymentMethods();

  Future<StripeIntentModel> createStripePaymentIntent({
    required double amount,
    String? currency,
  });

  Future<PaymentConfirmResultModel> confirmStripePayment({
    required String paymentIntentId,
  });

  Future<BankInstructionsModel> getBankInstructions();

  Future<Map<String, dynamic>> submitWireProof({
    required double amount,
    required String senderBank,
    required String referenceNumber,
    String? proofUrl,
    String? notes,
    String? currency,
  });

  Future<CryptoAddressModel> createCryptoDepositAddress({
    required String cryptocurrency,
    required String network,
  });

  Future<PaymentConfirmResultModel> verifyCryptoDeposit({
    required String txHash,
    required String cryptocurrency,
    required String network,
    required double amount,
  });
}

class PaymentRepository implements IPaymentRepository {
  final ApiClient _client = ApiClient();

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.paymentMethods),
      (dynamic data) => PaymentMethodModel.fromJsonList(data),
      'Get Payment Methods',
    );
  }

  @override
  Future<StripeIntentModel> createStripePaymentIntent({
    required double amount,
    String? currency,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.stripeCreateIntent,
        data: {
          'amount': amount,
          if (currency != null) 'currency': currency,
        },
      ),
      (dynamic data) => StripeIntentModel.fromJson(data as Map<String, dynamic>),
      'Create Stripe Payment Intent',
    );
  }

  @override
  Future<PaymentConfirmResultModel> confirmStripePayment({
    required String paymentIntentId,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.stripeConfirm,
        data: {
          'payment_intent_id': paymentIntentId,
        },
      ),
      (dynamic data) =>
          PaymentConfirmResultModel.fromJson(data as Map<String, dynamic>),
      'Confirm Stripe Payment',
    );
  }

  @override
  Future<BankInstructionsModel> getBankInstructions() {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.bankInstructions),
      (dynamic data) =>
          BankInstructionsModel.fromJson(data as Map<String, dynamic>),
      'Get Bank Instructions',
    );
  }

  @override
  Future<Map<String, dynamic>> submitWireProof({
    required double amount,
    required String senderBank,
    required String referenceNumber,
    String? proofUrl,
    String? notes,
    String? currency,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.bankSubmitProof,
        data: {
          'amount': amount,
          'sender_bank': senderBank,
          'reference_number': referenceNumber,
          if (proofUrl != null) 'proof_url': proofUrl,
          if (notes != null) 'notes': notes,
          if (currency != null) 'currency': currency,
        },
      ),
      (dynamic data) => data as Map<String, dynamic>,
      'Submit Wire Proof',
    );
  }

  @override
  Future<CryptoAddressModel> createCryptoDepositAddress({
    required String cryptocurrency,
    required String network,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.cryptoCreateAddress,
        data: {
          'cryptocurrency': cryptocurrency,
          'network': network,
        },
      ),
      (dynamic data) =>
          CryptoAddressModel.fromJson(data as Map<String, dynamic>),
      'Create Crypto Deposit Address',
    );
  }

  @override
  Future<PaymentConfirmResultModel> verifyCryptoDeposit({
    required String txHash,
    required String cryptocurrency,
    required String network,
    required double amount,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.cryptoVerifyDeposit,
        data: {
          'tx_hash': txHash,
          'cryptocurrency': cryptocurrency,
          'network': network,
          'amount': amount,
        },
      ),
      (dynamic data) =>
          PaymentConfirmResultModel.fromJson(data as Map<String, dynamic>),
      'Verify Crypto Deposit',
    );
  }
}

