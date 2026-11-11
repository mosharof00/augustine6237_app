import 'package:augustine6237/app/core/network/api_client.dart';
import 'package:augustine6237/app/core/network/api_endpoints.dart';
import 'package:augustine6237/app/data/models/bet_models/bet_comment_model.dart';
import 'package:augustine6237/app/data/models/bet_models/bet_model.dart';
import 'package:augustine6237/app/data/models/discovery_models/discovery_model.dart';

abstract class IBetRepository {
  Future<List<BetModel>> getPublicBets({
    String? category,
    String? status,
    String? sort,
    String? search,
  });
  Future<List<BetModel>> exploreBets({
    String? category,
    String? status,
    String? sort,
    String? search,
    String? country,
    bool? isFeatured,
  });
  Future<List<TrendingTopicModel>> getTrendingTopics();
  Future<List<DiscoveryCountryModel>> getSupportedCountries();
  Future<BetModel> getBetById(String id);
  Future<BetModel> createBet({
    required String title,
    String? description,
    required String category,
    String betType = 'BINARY',
    List<String>? outcomes,
    required DateTime deadline,
    bool isPrivate = false,
    double? initialStake,
    String? initialSide,
    String? initialOutcome,
  });

  Future<BetModel> getBetByInviteCode(String code);
  Future<Map<String, dynamic>> joinBetByInviteCode(
    String code, {
    String? side,
    String? outcomeId,
    required double stake,
  });
  Future<List<BetParticipantModel>> getBetParticipants(String betId);
  Future<Map<String, dynamic>> placeStake(
    String betId, {
    String? outcomeId,
    String? side,
    required double stake,
  });
  Future<List<BetOutcomeModel>> getBetOutcomes(String betId);
  Future<BetMatchedStatusModel> getBetMatchedStatus(String betId);
  Future<Map<String, dynamic>> refundUnmatchedStakes(String betId);
  Future<BetEscrowModel> getBetEscrowStatus(String betId);
  Future<Map<String, dynamic>> resolveBet(
    String betId, {
    String? winningSide,
    String? winningOutcomeId,
  });
  Future<FeeConfigModel> getFeeConfig();
  Future<FeeConfigModel> updateFeeConfig({
    required double commissionRate,
    String? description,
  });
  Future<BetCommissionModel> getBetCommission(String betId);

  Future<List<BetCommentModel>> getBetComments(String betId);
  Future<BetCommentModel> postBetComment({
    required String betId,
    required String content,
    String? stance,
  });
  Future<void> deleteBetComment({
    required String betId,
    required String commentId,
  });
}

class BetRepository implements IBetRepository {
  final ApiClient _client;

  BetRepository(this._client);

  @override
  Future<List<BetModel>> getPublicBets({
    String? category,
    String? status,
    String? sort,
    String? search,
  }) {
    final queryParams = <String, dynamic>{
      if (category != null && category.isNotEmpty) 'category': category,
      if (status != null && status.isNotEmpty) 'status': status,
      if (sort != null && sort.isNotEmpty) 'sort': sort,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.bets, queryParameters: queryParams),
      (dynamic data) => BetModel.fromJsonList(data),
      'Get Public Bets',
    );
  }

  @override
  Future<BetModel> getBetById(String id) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.betDetails(id)),
      (dynamic data) => BetModel.fromJson(data as Map<String, dynamic>),
      'Get Bet Details',
    );
  }

  @override
  Future<BetModel> createBet({
    required String title,
    String? description,
    required String category,
    String betType = 'BINARY',
    List<String>? outcomes,
    required DateTime deadline,
    bool isPrivate = false,
    double? initialStake,
    String? initialSide,
    String? initialOutcome,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.bets,
        data: {
          'title': title,
          if (description != null && description.isNotEmpty)
            'description': description,
          'category': category,
          'bet_type': betType,
          if (outcomes != null && outcomes.isNotEmpty) 'outcomes': outcomes,
          'deadline': deadline.toIso8601String(),
          'is_private': isPrivate,
          if (initialStake != null) 'initial_stake': initialStake,
          if (initialSide != null) 'initial_side': initialSide,
          if (initialOutcome != null) 'initial_outcome': initialOutcome,
        },
      ),
      (dynamic data) => BetModel.fromJson(data as Map<String, dynamic>),
      'Create Bet',
    );
  }

  @override
  Future<BetModel> getBetByInviteCode(String code) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.betInvite(code.trim())),
      (dynamic data) => BetModel.fromJson(data as Map<String, dynamic>),
      'Get Bet By Invite Code',
    );
  }

  @override
  Future<Map<String, dynamic>> joinBetByInviteCode(
    String code, {
    String? side,
    String? outcomeId,
    required double stake,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.betInviteJoin(code.trim()),
        data: {
          if (side != null) 'side': side,
          if (outcomeId != null) 'outcome_id': outcomeId,
          'stake': stake,
        },
      ),
      (dynamic data) => data as Map<String, dynamic>,
      'Join Bet By Invite Code',
    );
  }

  @override
  Future<List<BetParticipantModel>> getBetParticipants(String betId) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.betParticipants(betId)),
      (dynamic data) => BetParticipantModel.fromJsonList(data),
      'Get Bet Participants',
    );
  }

  @override
  Future<Map<String, dynamic>> placeStake(
    String betId, {
    String? outcomeId,
    String? side,
    required double stake,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.betStake(betId),
        data: {
          if (outcomeId != null) 'outcome_id': outcomeId,
          if (side != null) 'side': side,
          'stake': stake,
        },
      ),
      (dynamic data) => data as Map<String, dynamic>,
      'Place Stake',
    );
  }

  @override
  Future<List<BetOutcomeModel>> getBetOutcomes(String betId) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.betOutcomes(betId)),
      (dynamic data) => BetOutcomeModel.fromJsonList(data),
      'Get Bet Outcomes',
    );
  }

  @override
  Future<List<BetCommentModel>> getBetComments(String betId) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.betComments(betId)),
      (dynamic data) => BetCommentModel.fromJsonList(data),
      'Get Bet Comments',
    );
  }

  @override
  Future<BetCommentModel> postBetComment({
    required String betId,
    required String content,
    String? stance,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.betComments(betId),
        data: {
          'content': content,
          'stance': stance ?? 'SPECTATOR',
        },
      ),
      (dynamic data) => BetCommentModel.fromJson(data as Map<String, dynamic>),
      'Post Bet Comment',
    );
  }

  @override
  Future<void> deleteBetComment({
    required String betId,
    required String commentId,
  }) {
    return _client.handleRequest(
      () => _client.dio.delete(ApiEndpoint.deleteBetComment(betId, commentId)),
      (dynamic data) {},
      'Delete Bet Comment',
    );
  }

  @override
  Future<BetMatchedStatusModel> getBetMatchedStatus(String betId) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.betMatchedStatus(betId)),
      (dynamic data) =>
          BetMatchedStatusModel.fromJson(data as Map<String, dynamic>),
      'Get Bet Matched Status',
    );
  }

  @override
  Future<Map<String, dynamic>> refundUnmatchedStakes(String betId) {
    return _client.handleRequest(
      () => _client.dio.post(ApiEndpoint.betRefundUnmatched(betId)),
      (dynamic data) => data as Map<String, dynamic>,
      'Refund Unmatched Stakes',
    );
  }

  @override
  Future<BetEscrowModel> getBetEscrowStatus(String betId) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.betEscrow(betId)),
      (dynamic data) => BetEscrowModel.fromJson(data as Map<String, dynamic>),
      'Get Bet Escrow Status',
    );
  }

  @override
  Future<Map<String, dynamic>> resolveBet(
    String betId, {
    String? winningSide,
    String? winningOutcomeId,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.betResolve(betId),
        data: {
          if (winningSide != null) 'winning_side': winningSide,
          if (winningOutcomeId != null) 'winning_outcome_id': winningOutcomeId,
        },
      ),
      (dynamic data) => data as Map<String, dynamic>,
      'Resolve Bet',
    );
  }

  @override
  Future<FeeConfigModel> getFeeConfig() {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.feesConfig),
      (dynamic data) => FeeConfigModel.fromJson(data as Map<String, dynamic>),
      'Get Fee Config',
    );
  }

  @override
  Future<FeeConfigModel> updateFeeConfig({
    required double commissionRate,
    String? description,
  }) {
    return _client.handleRequest(
      () => _client.dio.put(
        ApiEndpoint.feesConfig,
        data: {
          'commission_rate': commissionRate,
          if (description != null) 'description': description,
        },
      ),
      (dynamic data) => FeeConfigModel.fromJson(data as Map<String, dynamic>),
      'Update Fee Config',
    );
  }

  @override
  Future<BetCommissionModel> getBetCommission(String betId) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.betCommission(betId)),
      (dynamic data) =>
          BetCommissionModel.fromJson(data as Map<String, dynamic>),
      'Get Bet Commission',
    );
  }

  @override
  Future<List<BetModel>> exploreBets({
    String? category,
    String? status,
    String? sort,
    String? search,
    String? country,
    bool? isFeatured,
  }) {
    final query = <String, dynamic>{
      if (category != null && category != 'ALL') 'category': category,
      if (status != null && status != 'ALL') 'status': status,
      if (sort != null) 'sort': sort,
      if (search != null && search.isNotEmpty) 'search': search,
      if (country != null && country != 'GLOBAL' && country != 'ALL')
        'country': country,
      if (isFeatured != null) 'is_featured': isFeatured.toString(),
    };

    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.exploreBets, queryParameters: query),
      (dynamic data) => BetModel.fromJsonList(data),
      'Explore Bets',
    );
  }

  @override
  Future<List<TrendingTopicModel>> getTrendingTopics() {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.trendingTopics),
      (dynamic data) => TrendingTopicModel.fromJsonList(data),
      'Get Trending Topics',
    );
  }

  @override
  Future<List<DiscoveryCountryModel>> getSupportedCountries() {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.supportedCountries),
      (dynamic data) => DiscoveryCountryModel.fromJsonList(data),
      'Get Supported Countries',
    );
  }
}
