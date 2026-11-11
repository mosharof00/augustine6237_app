class AiMarketSentimentModel {
  final double backPercentage;
  final double opposePercentage;
  final String consensus;

  AiMarketSentimentModel({
    required this.backPercentage,
    required this.opposePercentage,
    required this.consensus,
  });

  factory AiMarketSentimentModel.fromJson(Map<String, dynamic> json) {
    return AiMarketSentimentModel(
      backPercentage: (json['back_percentage'] as num?)?.toDouble() ?? 50.0,
      opposePercentage: (json['oppose_percentage'] as num?)?.toDouble() ?? 50.0,
      consensus: json['consensus']?.toString() ?? 'NEUTRAL',
    );
  }

  Map<String, dynamic> toJson() => {
        'back_percentage': backPercentage,
        'oppose_percentage': opposePercentage,
        'consensus': consensus,
      };
}

class AiBetResearchModel {
  final String betId;
  final String topic;
  final String summary;
  final List<String> keyFactors;
  final AiMarketSentimentModel marketSentiment;
  final String suggestedStance; // BACK, OPPOSE, NEUTRAL
  final double confidenceScore;
  final String riskLevel; // LOW, MODERATE, HIGH
  final List<String> sources;
  final DateTime? generatedAt;

  AiBetResearchModel({
    required this.betId,
    required this.topic,
    required this.summary,
    required this.keyFactors,
    required this.marketSentiment,
    this.suggestedStance = 'NEUTRAL',
    this.confidenceScore = 0.75,
    this.riskLevel = 'MODERATE',
    required this.sources,
    this.generatedAt,
  });

  factory AiBetResearchModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final factors = data['key_factors'] is List
        ? (data['key_factors'] as List).map((e) => e.toString()).toList()
        : <String>[];

    final src = data['sources'] is List
        ? (data['sources'] as List).map((e) => e.toString()).toList()
        : <String>[];

    final sentimentMap = data['market_sentiment'] is Map<String, dynamic>
        ? data['market_sentiment'] as Map<String, dynamic>
        : <String, dynamic>{};

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    return AiBetResearchModel(
      betId: data['bet_id']?.toString() ?? '',
      topic: data['topic']?.toString() ?? '',
      summary: data['summary']?.toString() ?? '',
      keyFactors: factors,
      marketSentiment: AiMarketSentimentModel.fromJson(sentimentMap),
      suggestedStance:
          data['suggested_stance']?.toString().toUpperCase() ?? 'NEUTRAL',
      confidenceScore: (data['confidence_score'] as num?)?.toDouble() ?? 0.75,
      riskLevel: data['risk_level']?.toString().toUpperCase() ?? 'MODERATE',
      sources: src,
      generatedAt: parseDate(data['generated_at']),
    );
  }
}

class AiChatResponseModel {
  final String reply;
  final List<String> suggestions;
  final List<String> sources;

  AiChatResponseModel({
    required this.reply,
    required this.suggestions,
    required this.sources,
  });

  factory AiChatResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final sugg = data['suggestions'] is List
        ? (data['suggestions'] as List).map((e) => e.toString()).toList()
        : <String>[];

    final src = data['sources'] is List
        ? (data['sources'] as List).map((e) => e.toString()).toList()
        : <String>[];

    return AiChatResponseModel(
      reply: data['reply']?.toString() ?? '',
      suggestions: sugg,
      sources: src,
    );
  }
}

