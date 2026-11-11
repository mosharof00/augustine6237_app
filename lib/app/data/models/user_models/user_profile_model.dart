class UserStats {
  final int wins;
  final int losses;
  final int totalBets;
  final double winRate;
  final double roi;

  UserStats({
    required this.wins,
    required this.losses,
    required this.totalBets,
    required this.winRate,
    required this.roi,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      wins: (json['wins'] as num?)?.toInt() ?? 0,
      losses: (json['losses'] as num?)?.toInt() ?? 0,
      totalBets: (json['total_bets'] as num?)?.toInt() ?? 0,
      winRate: (json['win_rate'] as num?)?.toDouble() ?? 0.0,
      roi: (json['roi'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wins': wins,
      'losses': losses,
      'total_bets': totalBets,
      'win_rate': winRate,
      'roi': roi,
    };
  }
}

class UserRatingAggregate {
  final double average;
  final int count;

  UserRatingAggregate({
    required this.average,
    required this.count,
  });

  factory UserRatingAggregate.fromJson(Map<String, dynamic> json) {
    return UserRatingAggregate(
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'count': count,
    };
  }
}

class UserProfileModel {
  final String id;
  final String name;
  final String? username;
  final String? avatar;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final String? type;
  final String? balance;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;
  final UserStats stats;
  final UserRatingAggregate rating;

  UserProfileModel({
    required this.id,
    required this.name,
    this.username,
    this.avatar,
    this.avatarUrl,
    this.bio,
    this.location,
    this.type,
    this.balance,
    required this.followersCount,
    required this.followingCount,
    required this.isFollowing,
    required this.stats,
    required this.rating,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return UserProfileModel(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      username: data['username']?.toString(),
      avatar: data['avatar']?.toString(),
      avatarUrl: data['avatar_url']?.toString(),
      bio: data['bio']?.toString(),
      location: data['location']?.toString(),
      type: data['type']?.toString(),
      balance: data['balance']?.toString(),
      followersCount: (data['followers_count'] as num?)?.toInt() ?? 0,
      followingCount: (data['following_count'] as num?)?.toInt() ?? 0,
      isFollowing: data['is_following'] == true,
      stats: data['stats'] is Map<String, dynamic>
          ? UserStats.fromJson(data['stats'] as Map<String, dynamic>)
          : UserStats(wins: 0, losses: 0, totalBets: 0, winRate: 0.0, roi: 0.0),
      rating: data['rating'] is Map<String, dynamic>
          ? UserRatingAggregate.fromJson(data['rating'] as Map<String, dynamic>)
          : UserRatingAggregate(average: 0.0, count: 0),
    );
  }

  UserProfileModel copyWith({
    bool? isFollowing,
    int? followersCount,
    int? followingCount,
  }) {
    return UserProfileModel(
      id: id,
      name: name,
      username: username,
      avatar: avatar,
      avatarUrl: avatarUrl,
      bio: bio,
      location: location,
      type: type,
      balance: balance,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowing: isFollowing ?? this.isFollowing,
      stats: stats,
      rating: rating,
    );
  }
}

