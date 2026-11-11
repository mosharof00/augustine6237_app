import 'package:augustine6237/app/core/network/api_client.dart';
import 'package:augustine6237/app/core/network/api_endpoints.dart';
import 'package:augustine6237/app/data/models/wallet_models/wallet_model.dart';

abstract class IWalletRepository {
  Future<WalletModel> getWallet();
  Future<List<WalletTransactionModel>> getTransactions({
    String? type,
    String? status,
  });
  Future<Map<String, dynamic>> deposit({
    required double amount,
    String? paymentMethod,
    String? description,
  });
  Future<Map<String, dynamic>> withdraw({
    required double amount,
    String? payoutMethod,
    String? destinationDetails,
  });
}

class WalletRepository implements IWalletRepository {
  final ApiClient _client = ApiClient();

  @override
  Future<WalletModel> getWallet() {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.wallet),
      (dynamic data) => WalletModel.fromJson(data as Map<String, dynamic>),
      'Get Wallet',
    );
  }

  @override
  Future<List<WalletTransactionModel>> getTransactions({
    String? type,
    String? status,
  }) {
    return _client.handleRequest(
      () => _client.dio.get(
        ApiEndpoint.walletTransactions,
        queryParameters: {
          if (type != null) 'type': type,
          if (status != null) 'status': status,
        },
      ),
      (dynamic data) => WalletTransactionModel.fromJsonList(data),
      'Get Wallet Transactions',
    );
  }

  @override
  Future<Map<String, dynamic>> deposit({
    required double amount,
    String? paymentMethod,
    String? description,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.walletDeposit,
        data: {
          'amount': amount,
          if (paymentMethod != null) 'payment_method': paymentMethod,
          if (description != null) 'description': description,
        },
      ),
      (dynamic data) => data as Map<String, dynamic>,
      'Deposit to Wallet',
    );
  }

  @override
  Future<Map<String, dynamic>> withdraw({
    required double amount,
    String? payoutMethod,
    String? destinationDetails,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.walletWithdraw,
        data: {
          'amount': amount,
          if (payoutMethod != null) 'payout_method': payoutMethod,
          if (destinationDetails != null)
            'destination_details': destinationDetails,
        },
      ),
      (dynamic data) => data as Map<String, dynamic>,
      'Withdraw from Wallet',
    );
  }
}

