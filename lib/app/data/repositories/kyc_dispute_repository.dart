import 'package:augustine6237/app/core/network/api_client.dart';
import 'package:augustine6237/app/core/network/api_endpoints.dart';
import 'package:augustine6237/app/data/models/kyc_dispute_models/kyc_model.dart';

abstract class IKycDisputeRepository {
  Future<KycStatusModel> getKycStatus();

  Future<Map<String, dynamic>> submitKyc({
    required String documentType,
    required String documentNumber,
    required String documentUrl,
    String? fullName,
    String? country,
    String? dateOfBirth,
  });

  Future<BetDisputeModel> createDispute({
    required String betId,
    required String reason,
    required String description,
    String? evidenceUrl,
  });

  Future<List<BetDisputeModel>> getDisputes({
    String? betId,
    String? status,
    bool? myDisputes,
  });

  Future<Map<String, dynamic>> resolveDispute({
    required String disputeId,
    required String resolution,
    required String resolutionNotes,
    String? newWinningSide,
    String? newWinningOutcomeId,
  });
}

class KycDisputeRepository implements IKycDisputeRepository {
  final ApiClient _client = ApiClient();

  @override
  Future<KycStatusModel> getKycStatus() {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.kycStatus),
      (dynamic data) => KycStatusModel.fromJson(data as Map<String, dynamic>),
      'Get KYC Status',
    );
  }

  @override
  Future<Map<String, dynamic>> submitKyc({
    required String documentType,
    required String documentNumber,
    required String documentUrl,
    String? fullName,
    String? country,
    String? dateOfBirth,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.kycSubmit,
        data: {
          'document_type': documentType,
          'document_number': documentNumber,
          'document_url': documentUrl,
          if (fullName != null) 'full_name': fullName,
          if (country != null) 'country': country,
          if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
        },
      ),
      (dynamic data) => data as Map<String, dynamic>,
      'Submit KYC',
    );
  }

  @override
  Future<BetDisputeModel> createDispute({
    required String betId,
    required String reason,
    required String description,
    String? evidenceUrl,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.disputes,
        data: {
          'bet_id': betId,
          'reason': reason,
          'description': description,
          if (evidenceUrl != null) 'evidence_url': evidenceUrl,
        },
      ),
      (dynamic data) => BetDisputeModel.fromJson(data as Map<String, dynamic>),
      'Create Dispute',
    );
  }

  @override
  Future<List<BetDisputeModel>> getDisputes({
    String? betId,
    String? status,
    bool? myDisputes,
  }) {
    return _client.handleRequest(
      () => _client.dio.get(
        ApiEndpoint.disputes,
        queryParameters: {
          if (betId != null) 'bet_id': betId,
          if (status != null) 'status': status,
          if (myDisputes != null) 'my_disputes': myDisputes ? 'true' : 'false',
        },
      ),
      (dynamic data) => BetDisputeModel.fromJsonList(data),
      'Get Disputes',
    );
  }

  @override
  Future<Map<String, dynamic>> resolveDispute({
    required String disputeId,
    required String resolution,
    required String resolutionNotes,
    String? newWinningSide,
    String? newWinningOutcomeId,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.disputeResolve(disputeId),
        data: {
          'resolution': resolution,
          'resolution_notes': resolutionNotes,
          if (newWinningSide != null) 'new_winning_side': newWinningSide,
          if (newWinningOutcomeId != null)
            'new_winning_outcome_id': newWinningOutcomeId,
        },
      ),
      (dynamic data) => data as Map<String, dynamic>,
      'Resolve Dispute',
    );
  }
}

