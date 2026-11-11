import 'package:augustine6237/app/core/network/api_client.dart';
import 'package:augustine6237/app/core/network/api_endpoints.dart';
import 'package:augustine6237/app/data/models/gaming_models/gaming_match_model.dart';

abstract class IGamingRepository {
  Future<GamingMatchCheckModel> submitScore({
    required String betId,
    required int myScore,
    required int opponentScore,
    String? platform,
    String? gamertag,
    String? proofUrl,
  });

  Future<GamingMatchCheckModel> getMatchCheck(String betId);
}

class GamingRepository implements IGamingRepository {
  final ApiClient _client = ApiClient();

  @override
  Future<GamingMatchCheckModel> submitScore({
    required String betId,
    required int myScore,
    required int opponentScore,
    String? platform,
    String? gamertag,
    String? proofUrl,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.gamingSubmitScore(betId),
        data: {
          'my_score': myScore,
          'opponent_score': opponentScore,
          if (platform != null) 'platform': platform,
          if (gamertag != null) 'gamertag': gamertag,
          if (proofUrl != null) 'proof_url': proofUrl,
        },
      ),
      (dynamic data) =>
          GamingMatchCheckModel.fromJson(data as Map<String, dynamic>),
      'Submit Gaming Score',
    );
  }

  @override
  Future<GamingMatchCheckModel> getMatchCheck(String betId) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.gamingMatchCheck(betId)),
      (dynamic data) =>
          GamingMatchCheckModel.fromJson(data as Map<String, dynamic>),
      'Get Gaming Match Check',
    );
  }
}

