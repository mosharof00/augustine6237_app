import 'package:augustine6237/app/core/network/api_client.dart';
import 'package:augustine6237/app/core/network/api_endpoints.dart';
import 'package:augustine6237/app/data/models/admin_models/admin_control_model.dart';

abstract class IAdminRepository {
  Future<AdminOverviewModel> getOverview();

  Future<List<AdminUserModel>> getUsers({
    String? search,
    String? status,
    int? page,
    int? limit,
  });

  Future<bool> updateUserStatus({
    required String userId,
    required String status,
    String? reason,
  });

  Future<bool> featureBet({
    required String betId,
    required bool isFeatured,
  });

  Future<List<AdminWithdrawalModel>> getWithdrawals();

  Future<bool> reviewWithdrawal({
    required String transactionId,
    required String action,
    String? notes,
  });
}

class AdminRepository implements IAdminRepository {
  final ApiClient _client = ApiClient();

  @override
  Future<AdminOverviewModel> getOverview() {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.adminOverview),
      (dynamic data) =>
          AdminOverviewModel.fromJson(data as Map<String, dynamic>),
      'Get Admin Overview',
    );
  }

  @override
  Future<List<AdminUserModel>> getUsers({
    String? search,
    String? status,
    int? page,
    int? limit,
  }) {
    return _client.handleRequest(
      () => _client.dio.get(
        ApiEndpoint.adminUsers,
        queryParameters: {
          if (search != null) 'search': search,
          if (status != null) 'status': status,
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit,
        },
      ),
      (dynamic data) => AdminUserModel.fromJsonList(data),
      'Get Admin Users',
    );
  }

  @override
  Future<bool> updateUserStatus({
    required String userId,
    required String status,
    String? reason,
  }) {
    return _client.handleRequest(
      () => _client.dio.patch(
        ApiEndpoint.adminUserStatus(userId),
        data: {
          'status': status,
          if (reason != null) 'reason': reason,
        },
      ),
      (dynamic _) => true,
      'Update User Status',
    );
  }

  @override
  Future<bool> featureBet({
    required String betId,
    required bool isFeatured,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.adminBetFeature(betId),
        data: {
          'is_featured': isFeatured,
        },
      ),
      (dynamic _) => true,
      'Feature Bet',
    );
  }

  @override
  Future<List<AdminWithdrawalModel>> getWithdrawals() {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.adminWithdrawals),
      (dynamic data) => AdminWithdrawalModel.fromJsonList(data),
      'Get Admin Withdrawals',
    );
  }

  @override
  Future<bool> reviewWithdrawal({
    required String transactionId,
    required String action,
    String? notes,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.adminWithdrawalReview(transactionId),
        data: {
          'action': action,
          if (notes != null) 'notes': notes,
        },
      ),
      (dynamic _) => true,
      'Review Withdrawal',
    );
  }
}

