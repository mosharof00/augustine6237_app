import 'package:augustine6237/app/core/network/api_client.dart';
import 'package:augustine6237/app/core/network/api_endpoints.dart';
import 'package:augustine6237/app/data/models/ai_models/ai_research_model.dart';

abstract class IAiRepository {
  Future<AiBetResearchModel> researchBet({
    required String betId,
    String? prompt,
  });

  Future<AiChatResponseModel> chat({
    required String query,
    String? betId,
    List<Map<String, String>>? history,
  });

  Future<AiBetResearchModel> getBetInsights(String betId);
}

class AiRepository implements IAiRepository {
  final ApiClient _client = ApiClient();

  @override
  Future<AiBetResearchModel> researchBet({
    required String betId,
    String? prompt,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.aiResearchBet,
        data: {
          'bet_id': betId,
          if (prompt != null) 'prompt': prompt,
        },
      ),
      (dynamic data) =>
          AiBetResearchModel.fromJson(data as Map<String, dynamic>),
      'AI Research Bet',
    );
  }

  @override
  Future<AiChatResponseModel> chat({
    required String query,
    String? betId,
    List<Map<String, String>>? history,
  }) {
    return _client.handleRequest(
      () => _client.dio.post(
        ApiEndpoint.aiChat,
        data: {
          'query': query,
          if (betId != null) 'bet_id': betId,
          if (history != null) 'history': history,
        },
      ),
      (dynamic data) =>
          AiChatResponseModel.fromJson(data as Map<String, dynamic>),
      'AI Chat Assistant',
    );
  }

  @override
  Future<AiBetResearchModel> getBetInsights(String betId) {
    return _client.handleRequest(
      () => _client.dio.get(ApiEndpoint.aiBetInsights(betId)),
      (dynamic data) =>
          AiBetResearchModel.fromJson(data as Map<String, dynamic>),
      'Get AI Bet Insights',
    );
  }
}

