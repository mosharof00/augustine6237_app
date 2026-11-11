class TrendingTopicModel {
  final String tag;
  final String category;
  final int activeBetsCount;
  final double totalVolume;

  TrendingTopicModel({
    required this.tag,
    required this.category,
    required this.activeBetsCount,
    required this.totalVolume,
  });

  factory TrendingTopicModel.fromJson(Map<String, dynamic> json) {
    return TrendingTopicModel(
      tag: json['tag']?.toString() ?? '',
      category: json['category']?.toString() ?? 'SPORTS',
      activeBetsCount: (json['active_bets_count'] as num?)?.toInt() ?? 0,
      totalVolume: (json['total_volume'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static List<TrendingTopicModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final list = json is Map<String, dynamic> && json['data'] is List
        ? json['data'] as List
        : (json is List ? json : []);
    return list
        .map((e) => TrendingTopicModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class DiscoveryCountryModel {
  final String code;
  final String name;
  final int count;

  DiscoveryCountryModel({
    required this.code,
    required this.name,
    required this.count,
  });

  factory DiscoveryCountryModel.fromJson(Map<String, dynamic> json) {
    return DiscoveryCountryModel(
      code: json['code']?.toString() ?? 'GLOBAL',
      name: json['name']?.toString() ?? 'Global',
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  static List<DiscoveryCountryModel> fromJsonList(dynamic json) {
    if (json == null) return [];
    final list = json is Map<String, dynamic> && json['data'] is List
        ? json['data'] as List
        : (json is List ? json : []);
    return list
        .map((e) => DiscoveryCountryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

