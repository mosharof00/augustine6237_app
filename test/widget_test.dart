import 'package:flutter_test/flutter_test.dart';
import 'package:augustine6237/app/data/models/auth_models/login_model.dart';
import 'package:augustine6237/app/data/models/user_models/user_model.dart';
import 'package:augustine6237/app/data/models/user_models/user_profile_model.dart';
import 'package:augustine6237/app/data/models/review_models/user_review_model.dart';
import 'package:augustine6237/app/data/models/post_models/user_post_model.dart';
import 'package:augustine6237/app/data/models/bet_models/bet_comment_model.dart';
import 'package:augustine6237/app/data/models/bet_models/bet_model.dart';
import 'package:augustine6237/app/data/models/wallet_models/wallet_model.dart';
import 'package:augustine6237/app/data/models/payment_models/payment_model.dart';
import 'package:augustine6237/app/data/models/kyc_dispute_models/kyc_model.dart';
import 'package:augustine6237/app/data/models/gaming_models/gaming_match_model.dart';
import 'package:augustine6237/app/data/models/ai_models/ai_research_model.dart';
import 'package:augustine6237/app/data/models/admin_models/admin_control_model.dart';
import 'package:augustine6237/app/data/models/discovery_models/discovery_model.dart';

void main() {
  group('Slice 1: Auth & User Model Tests', () {
    test('LoginModel parses standard data format', () {
      final json = {
        'success': true,
        'message': 'Logged in successfully',
        'data': {
          'userId': 'user-123',
          'type': 'CLIENT',
          'accessToken': 'jwt-access-token',
          'refreshToken': 'jwt-refresh-token',
        },
      };

      final model = LoginModel.fromJson(json);
      expect(model.success, isTrue);
      expect(model.message, 'Logged in successfully');
      expect(model.data?.userId, 'user-123');
      expect(model.data?.type, 'CLIENT');
      expect(model.data?.accessToken, 'jwt-access-token');
      expect(model.data?.refreshToken, 'jwt-refresh-token');
    });

    test('LoginModel falls back to nested authorization object', () {
      final json = {
        'success': true,
        'authorization': {
          'type': 'bearer',
          'access_token': 'jwt-access-token-legacy',
          'refresh_token': 'jwt-refresh-token-legacy',
        },
        'userid': 'user-legacy-456',
        'type': 'CLIENT',
      };

      final model = LoginModel.fromJson(json);
      expect(model.success, isTrue);
      expect(model.data?.userId, 'user-legacy-456');
      expect(model.data?.accessToken, 'jwt-access-token-legacy');
      expect(model.data?.refreshToken, 'jwt-refresh-token-legacy');
    });

    test('UserModel parses user profile data with balance', () {
      final json = {
        'success': true,
        'data': {
          'id': 'user-789',
          'name': 'Test Bettor',
          'username': 'bettor1',
          'email': 'bettor@betsocial.com',
          'balance': '150.00',
          'type': 'CLIENT',
          'created_at': '2026-11-10T12:00:00Z',
        },
      };

      final user = UserModel.fromJson(json);
      expect(user.success, isTrue);
      expect(user.data?.id, 'user-789');
      expect(user.data?.name, 'Test Bettor');
      expect(user.data?.username, 'bettor1');
      expect(user.data?.balance, '150.00');
    });
  });

  group('Slice 2: User Profiles & Social Graph Tests', () {
    test('UserProfileModel parses full profile data correctly', () {
      final json = {
        'success': true,
        'data': {
          'id': 'cuid_alex',
          'name': 'Alex Mercer',
          'username': 'alexm',
          'bio': 'Sports Bettor',
          'location': 'London, UK',
          'balance': '350.00',
          'followers_count': 42,
          'following_count': 18,
          'is_following': false,
          'stats': {
            'wins': 34,
            'losses': 12,
            'total_bets': 46,
            'win_rate': 73.9,
            'roi': 18.5,
          },
          'rating': {
            'average': 4.8,
            'count': 21,
          },
        },
      };

      final profile = UserProfileModel.fromJson(json);
      expect(profile.id, 'cuid_alex');
      expect(profile.name, 'Alex Mercer');
      expect(profile.username, 'alexm');
      expect(profile.followersCount, 42);
      expect(profile.followingCount, 18);
      expect(profile.isFollowing, isFalse);
      expect(profile.stats.wins, 34);
      expect(profile.stats.losses, 12);
      expect(profile.stats.totalBets, 46);
      expect(profile.stats.winRate, 73.9);
      expect(profile.stats.roi, 18.5);
      expect(profile.rating.average, 4.8);
      expect(profile.rating.count, 21);
    });

    test('UserProfileModel copyWith updates follow status', () {
      final profile = UserProfileModel(
        id: 'u1',
        name: 'User 1',
        followersCount: 10,
        followingCount: 5,
        isFollowing: false,
        stats: UserStats(wins: 5, losses: 1, totalBets: 6, winRate: 83.3, roi: 12.0),
        rating: UserRatingAggregate(average: 4.5, count: 2),
      );

      final updated = profile.copyWith(isFollowing: true, followersCount: 11);
      expect(updated.isFollowing, isTrue);
      expect(updated.followersCount, 11);
      expect(updated.followingCount, 5);
    });

    test('UserReviewModel parses review list correctly', () {
      final json = {
        'success': true,
        'data': [
          {
            'id': 'rev_1',
            'rating': 5,
            'comment': 'Fast payout and fair bettor on sports predictions!',
            'created_at': '2026-11-10T14:30:00Z',
            'author': {
              'id': 'user_2',
              'name': 'Sam Carter',
              'username': 'samc',
              'avatar_url': null,
            },
          },
        ],
      };

      final reviews = UserReviewModel.fromJsonList(json);
      expect(reviews.length, 1);
      expect(reviews.first.id, 'rev_1');
      expect(reviews.first.rating, 5);
      expect(reviews.first.comment, 'Fast payout and fair bettor on sports predictions!');
      expect(reviews.first.author?.name, 'Sam Carter');
      expect(reviews.first.author?.username, 'samc');
    });
  });

  group('Slice 3: Personal Profile Posts Tests', () {
    test('UserPostModel parses post and list correctly', () {
      final json = {
        'success': true,
        'data': [
          {
            'id': 'post-101',
            'caption': 'Locked my bet on Arsenal vs Chelsea',
            'image_url': 'https://storage.betsocial.com/posts/arsenal.jpg',
            'location_tag': 'London',
            'created_at': '2026-11-10T16:00:00Z',
            'likes_count': 14,
            'comments_count': 3,
            'is_liked': true,
            'author': {
              'id': 'user-1',
              'name': 'Alex Mercer',
              'username': 'alexm',
              'avatar_url': null,
            },
          },
        ],
      };

      final posts = UserPostModel.fromJsonList(json);
      expect(posts.length, 1);
      final post = posts.first;
      expect(post.id, 'post-101');
      expect(post.caption, 'Locked my bet on Arsenal vs Chelsea');
      expect(post.imageUrl, 'https://storage.betsocial.com/posts/arsenal.jpg');
      expect(post.locationTag, 'London');
      expect(post.likesCount, 14);
      expect(post.commentsCount, 3);
      expect(post.isLiked, isTrue);
      expect(post.author?.name, 'Alex Mercer');
    });

    test('UserPostModel copyWith updates like status and count', () {
      final post = UserPostModel(
        id: 'post-1',
        caption: 'Test Caption',
        likesCount: 5,
        commentsCount: 1,
        isLiked: false,
      );

      final updated = post.copyWith(isLiked: true, likesCount: 6);
      expect(updated.isLiked, isTrue);
      expect(updated.likesCount, 6);
    });
  });

  group('Slice 4: Bettor Social Interaction Tests', () {
    test('BetCommentModel parses comment data and stances', () {
      final json = {
        'id': 'comm-10',
        'bet_id': 'bet-arsenal-chelsea',
        'content': 'Arsenal will dominate possession and win 2-0!',
        'stance': 'BACK',
        'created_at': '2026-11-10T16:30:00Z',
        'author': {
          'id': 'u1',
          'name': 'Alex Mercer',
          'username': 'alexm',
          'avatar_url': null,
        },
      };

      final comment = BetCommentModel.fromJson(json);
      expect(comment.id, 'comm-10');
      expect(comment.betId, 'bet-arsenal-chelsea');
      expect(comment.content, 'Arsenal will dominate possession and win 2-0!');
      expect(comment.stance, 'BACK');
      expect(comment.author?.name, 'Alex Mercer');
    });

    test('BetCommentModel.fromJsonList parses discussion array', () {
      final json = {
        'success': true,
        'data': [
          {
            'id': 'comm-1',
            'bet_id': 'bet-1',
            'content': 'Backing Yes!',
            'stance': 'BACK',
            'author': {'id': 'u1', 'name': 'Alex'},
          },
          {
            'id': 'comm-2',
            'bet_id': 'bet-1',
            'content': 'Opposing No!',
            'stance': 'OPPOSE',
            'author': {'id': 'u2', 'name': 'Sam'},
          },
        ],
      };

      final list = BetCommentModel.fromJsonList(json);
      expect(list.length, 2);
      expect(list[0].stance, 'BACK');
      expect(list[1].stance, 'OPPOSE');
    });
  });

  group('Slice 5: Public Bets Engine Tests', () {
    test('BetModel parses bet data, ratio calculations and creator info', () {
      final json = {
        'id': 'bet-chelsea-arsenal',
        'title': 'Will Chelsea beat Arsenal in London Derby?',
        'description': 'Premier League clash at Stamford Bridge.',
        'category': 'SPORTS',
        'creator_id': 'u1',
        'status': 'ACTIVE',
        'is_private': false,
        'deadline': DateTime.now().add(const Duration(hours: 48)).toIso8601String(),
        'total_pool': '1000.00',
        'back_pool': '700.00',
        'oppose_pool': '300.00',
        'comments_count': 15,
        'created_at': '2026-11-10T12:00:00Z',
        'creator': {
          'id': 'u1',
          'name': 'Alex Mercer',
          'username': 'alexm',
          'avatar_url': 'https://storage.betsocial.com/avatars/u1.png',
        },
      };

      final bet = BetModel.fromJson(json);
      expect(bet.id, 'bet-chelsea-arsenal');
      expect(bet.title, 'Will Chelsea beat Arsenal in London Derby?');
      expect(bet.category, 'SPORTS');
      expect(bet.totalPool, '1000.00');
      expect(bet.backPool, '700.00');
      expect(bet.opposePool, '300.00');
      expect(bet.backPercent, 70.0);
      expect(bet.opposePercent, 30.0);
      expect(bet.creator?.name, 'Alex Mercer');
      expect(bet.creator?.username, 'alexm');
      expect(bet.timeRemainingText.contains('left'), isTrue);
    });

    test('BetModel handles 0 pool amounts gracefully with 50/50 fallback', () {
      final json = {
        'id': 'bet-new',
        'title': 'New prediction without bets',
        'category': 'POLITICS',
        'creator_id': 'u2',
        'status': 'ACTIVE',
        'is_private': false,
        'total_pool': '0.00',
        'back_pool': '0.00',
        'oppose_pool': '0.00',
        'comments_count': 0,
      };

      final bet = BetModel.fromJson(json);
      expect(bet.backPercent, 50.0);
      expect(bet.opposePercent, 50.0);
    });

    test('BetModel.fromJsonList correctly parses array of bets', () {
      final json = {
        'success': true,
        'data': [
          {
            'id': 'bet-1',
            'title': 'Bet 1',
            'category': 'SPORTS',
            'creator_id': 'u1',
            'status': 'ACTIVE',
            'is_private': false,
            'total_pool': '100.00',
            'back_pool': '50.00',
            'oppose_pool': '50.00',
            'comments_count': 0,
          },
          {
            'id': 'bet-2',
            'title': 'Bet 2',
            'category': 'CRYPTO',
            'creator_id': 'u2',
            'status': 'ACTIVE',
            'is_private': false,
            'total_pool': '200.00',
            'back_pool': '150.00',
            'oppose_pool': '50.00',
            'comments_count': 4,
          },
        ],
      };

      final bets = BetModel.fromJsonList(json);
      expect(bets.length, 2);
      expect(bets[0].id, 'bet-1');
      expect(bets[1].category, 'CRYPTO');
      expect(bets[1].backPercent, 75.0);
    });
  });

  group('Slice 6: Private Bets & Shareable Invite Links Tests', () {
    test('BetModel correctly parses private bet with invite_code and participants', () {
      final json = {
        'id': 'bet-priv-100',
        'title': 'Half-Marathon Challenge between Alex and Jordan',
        'category': 'SPORTS',
        'creator_id': 'u1',
        'status': 'ACTIVE',
        'is_private': true,
        'invite_code': 'BET-9K2L8X',
        'total_pool': '100.00',
        'back_pool': '50.00',
        'oppose_pool': '50.00',
        'comments_count': 1,
        'participants': [
          {
            'id': 'part-1',
            'bet_id': 'bet-priv-100',
            'user_id': 'u1',
            'side': 'BACK',
            'stake': '50.00',
            'created_at': '2026-11-11T08:30:00Z',
            'user': {
              'id': 'u1',
              'name': 'Alex Mercer',
              'username': 'alexm',
            },
          },
          {
            'id': 'part-2',
            'bet_id': 'bet-priv-100',
            'user_id': 'u2',
            'side': 'OPPOSE',
            'stake': '50.00',
            'created_at': '2026-11-11T08:45:00Z',
            'user': {
              'id': 'u2',
              'name': 'Jordan Cole',
              'username': 'jordanc',
            },
          },
        ],
      };

      final bet = BetModel.fromJson(json);
      expect(bet.id, 'bet-priv-100');
      expect(bet.isPrivate, isTrue);
      expect(bet.inviteCode, 'BET-9K2L8X');
      expect(bet.participants.length, 2);
      expect(bet.participants[0].side, 'BACK');
      expect(bet.participants[0].stake, '50.00');
      expect(bet.participants[0].user?.name, 'Alex Mercer');
      expect(bet.participants[1].side, 'OPPOSE');
      expect(bet.participants[1].user?.username, 'jordanc');
    });

    test('BetParticipantModel.fromJsonList handles null and empty list gracefully', () {
      expect(BetParticipantModel.fromJsonList(null), isEmpty);
      expect(BetParticipantModel.fromJsonList([]), isEmpty);
    });
  });

  group('Slice 7: YES/NO and Custom Outcome Betting Tests', () {
    test('BetOutcomeModel parses outcome candidate and percentage', () {
      final json = {
        'id': 'out-1',
        'bet_id': 'bet-custom-1',
        'title': 'Arsenal',
        'pool': '150.00',
        'percent': 60.0,
        'is_winner': null,
      };

      final outcome = BetOutcomeModel.fromJson(json);
      expect(outcome.id, 'out-1');
      expect(outcome.betId, 'bet-custom-1');
      expect(outcome.title, 'Arsenal');
      expect(outcome.pool, '150.00');
      expect(outcome.percent, 60.0);
      expect(outcome.isWinner, isNull);
    });

    test('BetModel parses custom multi-outcome bet with outcomes list', () {
      final json = {
        'id': 'bet-custom-1',
        'title': 'Who will win the Premier League 2026/27?',
        'category': 'SPORTS',
        'bet_type': 'CUSTOM',
        'creator_id': 'u1',
        'status': 'ACTIVE',
        'is_private': false,
        'total_pool': '250.00',
        'back_pool': '0.00',
        'oppose_pool': '0.00',
        'comments_count': 5,
        'outcomes': [
          {
            'id': 'out-1',
            'bet_id': 'bet-custom-1',
            'title': 'Arsenal',
            'pool': '150.00',
            'percent': 60.0,
          },
          {
            'id': 'out-2',
            'bet_id': 'bet-custom-1',
            'title': 'Manchester City',
            'pool': '100.00',
            'percent': 40.0,
          },
        ],
      };

      final bet = BetModel.fromJson(json);
      expect(bet.id, 'bet-custom-1');
      expect(bet.betType, 'CUSTOM');
      expect(bet.outcomes.length, 2);
      expect(bet.outcomes[0].title, 'Arsenal');
      expect(bet.outcomes[0].percent, 60.0);
      expect(bet.outcomes[1].title, 'Manchester City');
      expect(bet.outcomes[1].percent, 40.0);
    });

    test('BetModel defaults to BINARY betType when not specified', () {
      final json = {
        'id': 'bet-bin-1',
        'title': 'Lakers vs Warriors',
        'category': 'SPORTS',
        'creator_id': 'u1',
        'status': 'ACTIVE',
        'is_private': false,
        'total_pool': '100.00',
        'back_pool': '50.00',
        'oppose_pool': '50.00',
        'comments_count': 0,
      };

      final bet = BetModel.fromJson(json);
      expect(bet.betType, 'BINARY');
      expect(bet.outcomes, isEmpty);
      expect(bet.backPercent, 50.0);
    });
  });

  group('Slice 8: Matched Betting Engine Tests', () {
    test('BetMatchedStatusModel correctly parses pool matching and decimal odds', () {
      final json = {
        'bet_id': 'bet-match-100',
        'bet_type': 'BINARY',
        'total_pool': '250.00',
        'matched_pool': '200.00',
        'unmatched_pool': '50.00',
        'back_pool': '150.00',
        'oppose_pool': '100.00',
        'back_matched': '100.00',
        'oppose_matched': '100.00',
        'back_unmatched': '50.00',
        'oppose_unmatched': '0.00',
        'back_odds': '1.67',
        'oppose_odds': '2.50',
        'participants': [
          {
            'id': 'p1',
            'user_id': 'u1',
            'side': 'BACK',
            'stake': '150.00',
            'matched_stake': '100.00',
            'unmatched_stake': '50.00',
            'match_status': 'PARTIALLY_MATCHED',
            'refunded_amount': '0.00',
          },
          {
            'id': 'p2',
            'user_id': 'u2',
            'side': 'OPPOSE',
            'stake': '100.00',
            'matched_stake': '100.00',
            'unmatched_stake': '0.00',
            'match_status': 'MATCHED',
            'refunded_amount': '0.00',
          },
        ],
      };

      final model = BetMatchedStatusModel.fromJson(json);
      expect(model.betId, 'bet-match-100');
      expect(model.matchedPool, '200.00');
      expect(model.unmatchedPool, '50.00');
      expect(model.backOdds, '1.67');
      expect(model.opposeOdds, '2.50');
      expect(model.participants.length, 2);
      expect(model.participants[0].matchStatus, 'PARTIALLY_MATCHED');
      expect(model.participants[0].unmatchedStake, '50.00');
      expect(model.participants[1].matchStatus, 'MATCHED');
      expect(model.participants[1].unmatchedStake, '0.00');
    });

    test('BetModel calculates decimal odds and matched pool doubles', () {
      final json = {
        'id': 'bet-odds-1',
        'title': 'Odds Calculation Test',
        'category': 'SPORTS',
        'creator_id': 'u1',
        'status': 'ACTIVE',
        'is_private': false,
        'total_pool': '300.00',
        'back_pool': '100.00',
        'oppose_pool': '200.00',
        'matched_pool': '200.00',
        'unmatched_pool': '100.00',
        'comments_count': 0,
      };

      final bet = BetModel.fromJson(json);
      expect(bet.matchedPoolDouble, 200.00);
      expect(bet.unmatchedPoolDouble, 100.00);
      expect(bet.backOdds, 3.0); // 300 / 100
      expect(bet.opposeOdds, 1.5); // 300 / 200
    });
  });

  group('Slice 9: Escrow & Automated Payout Pool Tests', () {
    test('BetEscrowModel parses escrow status, locked funds, and payouts', () {
      final json = {
        'data': {
          'bet_id': 'bet-escrow-100',
          'title': 'Arsenal vs Chelsea',
          'status': 'RESOLVED',
          'escrow_status': 'SETTLED',
          'total_escrow': '200.00',
          'matched_pool': '160.00',
          'unmatched_pool': '40.00',
          'payout_pool': '160.00',
          'winning_side': 'BACK',
          'winners_count': 1,
          'losers_count': 1,
          'payouts': [
            {
              'participant_id': 'part-1',
              'user_id': 'u1',
              'user_name': 'Alice Backer',
              'side': 'BACK',
              'stake': '100.00',
              'matched_stake': '80.00',
              'payout_amount': '160.00',
              'profit': '80.00',
              'roi_percent': 100.0,
              'is_winner': true,
              'payout_status': 'PAID',
            },
            {
              'participant_id': 'part-2',
              'user_id': 'u2',
              'user_name': 'Bob Opposer',
              'side': 'OPPOSE',
              'stake': '80.00',
              'matched_stake': '80.00',
              'payout_amount': '0.00',
              'profit': '0.00',
              'roi_percent': 0.0,
              'is_winner': false,
              'payout_status': 'LOST',
            },
          ],
        },
      };

      final escrow = BetEscrowModel.fromJson(json);
      expect(escrow.betId, 'bet-escrow-100');
      expect(escrow.escrowStatus, 'SETTLED');
      expect(escrow.totalEscrow, '200.00');
      expect(escrow.matchedPool, '160.00');
      expect(escrow.winningSide, 'BACK');
      expect(escrow.winnersCount, 1);
      expect(escrow.losersCount, 1);
      expect(escrow.payouts.length, 2);

      final winner = escrow.payouts[0];
      expect(winner.userName, 'Alice Backer');
      expect(winner.isWinner, isTrue);
      expect(winner.payoutAmount, '160.00');
      expect(winner.profit, '80.00');
      expect(winner.roiPercent, 100.0);
      expect(winner.payoutStatus, 'PAID');

      final loser = escrow.payouts[1];
      expect(loser.userName, 'Bob Opposer');
      expect(loser.isWinner, isFalse);
      expect(loser.payoutAmount, '0.00');
      expect(loser.payoutStatus, 'LOST');
    });

    test('BetModel includes escrow status and winning outcome attributes', () {
      final json = {
        'id': 'bet-escrow-open',
        'title': 'Active Escrow Bet',
        'category': 'SPORTS',
        'creator_id': 'u1',
        'status': 'ACTIVE',
        'escrow_status': 'LOCKED',
        'is_private': false,
        'total_pool': '500.00',
        'back_pool': '250.00',
        'oppose_pool': '250.00',
        'matched_pool': '500.00',
        'unmatched_pool': '0.00',
        'comments_count': 3,
      };

      final bet = BetModel.fromJson(json);
      expect(bet.escrowStatus, 'LOCKED');
      expect(bet.status, 'ACTIVE');
      expect(bet.totalPoolDouble, 500.00);
      expect(bet.matchedPoolDouble, 500.00);
    });
  });

  group('Slice 10: Platform Commission & Fee Management Tests', () {
    test('FeeConfigModel parses platform commission config', () {
      final json = {
        'success': true,
        'data': {
          'commission_rate': '10.0',
          'applies_to_profit': true,
          'description': 'Default platform commission on net winning profit',
          'updated_at': '2026-11-11T00:00:00.000Z',
        },
      };

      final config = FeeConfigModel.fromJson(json);
      expect(config.commissionRate, '10.0');
      expect(config.appliesToProfit, isTrue);
      expect(config.description, contains('Default platform commission'));
      expect(config.updatedAt, isNotNull);
    });

    test('BetCommissionModel parses commission summary and participant fee roster', () {
      final json = {
        'success': true,
        'data': {
          'bet_id': 'bet-comm-100',
          'title': 'World Cup Final',
          'status': 'RESOLVED',
          'commission_rate': '10.0',
          'gross_payout_pool': '200.00',
          'total_commission_collected': '10.00',
          'net_payout_pool': '190.00',
          'participant_fees': [
            {
              'participant_id': 'part-1',
              'user_id': 'u1',
              'user_name': 'Winner Alice',
              'side': 'BACK',
              'matched_stake': '100.00',
              'gross_payout': '200.00',
              'net_profit': '100.00',
              'commission_deducted': '10.00',
              'net_payout': '190.00',
            },
            {
              'participant_id': 'part-2',
              'user_id': 'u2',
              'user_name': 'Loser Bob',
              'side': 'OPPOSE',
              'matched_stake': '100.00',
              'gross_payout': '0.00',
              'net_profit': '0.00',
              'commission_deducted': '0.00',
              'net_payout': '0.00',
            },
          ],
        },
      };

      final comm = BetCommissionModel.fromJson(json);
      expect(comm.betId, 'bet-comm-100');
      expect(comm.commissionRate, '10.0');
      expect(comm.grossPayoutPool, '200.00');
      expect(comm.totalCommissionCollected, '10.00');
      expect(comm.netPayoutPool, '190.00');
      expect(comm.participantFees.length, 2);

      final winner = comm.participantFees[0];
      expect(winner.userName, 'Winner Alice');
      expect(winner.matchedStake, '100.00');
      expect(winner.netProfit, '100.00');
      expect(winner.commissionDeducted, '10.00');
      expect(winner.netPayout, '190.00');

      final loser = comm.participantFees[1];
      expect(loser.userName, 'Loser Bob');
      expect(loser.commissionDeducted, '0.00');
      expect(loser.netPayout, '0.00');
    });

    test('BetModel and BetParticipantModel include commission rate and fee attributes', () {
      final betJson = {
        'id': 'bet-fee-1',
        'title': 'Test Fee Bet',
        'category': 'CRYPTO',
        'creator_id': 'u1',
        'status': 'RESOLVED',
        'is_private': false,
        'total_pool': '100.00',
        'back_pool': '50.00',
        'oppose_pool': '50.00',
        'commission_rate': '8.5',
        'commission_amount': '4.25',
        'comments_count': 0,
      };

      final bet = BetModel.fromJson(betJson);
      expect(bet.commissionRate, '8.5');
      expect(bet.commissionAmount, '4.25');

      final partJson = {
        'id': 'p-fee-1',
        'user_id': 'u1',
        'side': 'BACK',
        'stake': '50.00',
        'matched_stake': '50.00',
        'gross_payout': '100.00',
        'commission_deducted': '4.25',
        'net_payout': '95.75',
      };

      final participant = BetParticipantModel.fromJson(partJson);
      expect(participant.grossPayout, '100.00');
      expect(participant.commissionDeducted, '4.25');
      expect(participant.netPayout, '95.75');
    });
  });

  group('Slice 11: User Wallet System Tests', () {
    test('WalletModel parses balances and stats correctly', () {
      final json = {
        'success': true,
        'data': {
          'user_id': 'u100',
          'balance': '350.50',
          'escrow_locked': '75.00',
          'total_deposited': '500.00',
          'total_withdrawn': '150.00',
          'currency': 'USD',
        },
      };

      final wallet = WalletModel.fromJson(json);
      expect(wallet.userId, 'u100');
      expect(wallet.balance, '350.50');
      expect(wallet.balanceDouble, 350.50);
      expect(wallet.escrowLocked, '75.00');
      expect(wallet.escrowLockedDouble, 75.00);
      expect(wallet.totalDeposited, '500.00');
      expect(wallet.totalWithdrawn, '150.00');
      expect(wallet.currency, 'USD');
    });

    test('WalletTransactionModel parses transactions with credits and debits', () {
      final json = {
        'id': 'tx-100',
        'user_id': 'u100',
        'type': 'PAYOUT',
        'amount': '152.00',
        'currency': 'USD',
        'status': 'COMPLETED',
        'description': 'Payout won for Arsenal vs Chelsea',
        'reference_id': 'bet-123',
        'created_at': '2026-11-11T12:00:00Z',
      };

      final tx = WalletTransactionModel.fromJson(json);
      expect(tx.id, 'tx-100');
      expect(tx.userId, 'u100');
      expect(tx.type, 'PAYOUT');
      expect(tx.amount, '152.00');
      expect(tx.status, 'COMPLETED');
      expect(tx.description, contains('Payout won'));
      expect(tx.referenceId, 'bet-123');
      expect(tx.createdAt, isNotNull);
    });

    test('WalletTransactionModel.fromJsonList parses transaction ledger', () {
      final listJson = [
        {
          'id': 'tx-1',
          'type': 'DEPOSIT',
          'amount': '100.00',
          'status': 'COMPLETED',
          'description': 'Card deposit',
        },
        {
          'id': 'tx-2',
          'type': 'WITHDRAWAL',
          'amount': '50.00',
          'status': 'PENDING',
          'description': 'Bank transfer withdrawal',
          'destination_details': 'IBAN 987',
        },
      ];

      final txs = WalletTransactionModel.fromJsonList(listJson);
      expect(txs.length, 2);
      expect(txs[0].type, 'DEPOSIT');
      expect(txs[0].amount, '100.00');
      expect(txs[1].type, 'WITHDRAWAL');
      expect(txs[1].destinationDetails, 'IBAN 987');
      expect(txs[1].status, 'PENDING');
    });
  });

  group('Slice 12: Multi-Method Payment Processing Tests', () {
    test('PaymentMethodModel.fromJsonList parses payment methods', () {
      final json = {
        'methods': [
          {
            'id': 'stripe_card',
            'name': 'Credit / Debit Card',
            'provider': 'STRIPE',
            'type': 'CARD',
            'currencies': ['USD', 'EUR'],
            'min_deposit': 5.0,
            'max_deposit': 10000.0,
            'fee_percent': '0.00',
            'processing_time': 'Instant',
            'is_enabled': true,
          },
          {
            'id': 'crypto_deposit',
            'name': 'Cryptocurrency',
            'provider': 'CRYPTO',
            'type': 'CRYPTO',
            'currencies': ['USDT', 'USDC'],
            'min_deposit': 10.0,
            'max_deposit': 50000.0,
            'fee_percent': '0.00',
            'processing_time': 'Instant',
            'is_enabled': true,
          },
        ]
      };

      final methods = PaymentMethodModel.fromJsonList(json);
      expect(methods.length, 2);
      expect(methods[0].provider, 'STRIPE');
      expect(methods[0].minDeposit, 5.0);
      expect(methods[1].provider, 'CRYPTO');
      expect(methods[1].currencies, contains('USDT'));
    });

    test('StripeIntentModel parses payment intent data', () {
      final json = {
        'data': {
          'payment_intent_id': 'pi_12345',
          'client_secret': 'pi_12345_secret_abc',
          'amount': '150.00',
          'currency': 'USD',
          'transaction_id': 'tx_strp_99',
        }
      };

      final intent = StripeIntentModel.fromJson(json);
      expect(intent.paymentIntentId, 'pi_12345');
      expect(intent.clientSecret, 'pi_12345_secret_abc');
      expect(intent.amount, '150.00');
      expect(intent.transactionId, 'tx_strp_99');
    });

    test('BankInstructionsModel parses bank wire instructions', () {
      final json = {
        'data': {
          'beneficiary_name': 'BetSocial Global Ltd',
          'bank_name': 'JPMorgan Chase Bank, N.A.',
          'swift_bic': 'CHASUS33XXX',
          'iban': 'GB82WEST12345698765432',
          'account_number': '9876543210',
          'routing_number': '021000021',
          'reference_prefix': 'BS-DEPOSIT-',
          'notes': 'Include reference in wire memo',
        }
      };

      final inst = BankInstructionsModel.fromJson(json);
      expect(inst.beneficiaryName, 'BetSocial Global Ltd');
      expect(inst.swiftBic, 'CHASUS33XXX');
      expect(inst.iban, 'GB82WEST12345698765432');
    });

    test('CryptoAddressModel and PaymentConfirmResultModel parse properly', () {
      final addrJson = {
        'data': {
          'cryptocurrency': 'USDT',
          'network': 'POLYGON',
          'deposit_address': '0x71Ce275d31b816280b2aB38',
          'min_deposit': '10.00',
          'estimated_confirmations': 64,
        }
      };

      final addr = CryptoAddressModel.fromJson(addrJson);
      expect(addr.cryptocurrency, 'USDT');
      expect(addr.network, 'POLYGON');
      expect(addr.depositAddress, '0x71Ce275d31b816280b2aB38');
      expect(addr.estimatedConfirmations, 64);

      final confirmJson = {
        'data': {
          'transaction_id': 'tx_c100',
          'amount': '200.00',
          'new_balance': '650.00',
          'currency': 'USD',
          'status': 'COMPLETED',
          'reference_number': '0x98f123',
        }
      };

      final confirm = PaymentConfirmResultModel.fromJson(confirmJson);
      expect(confirm.transactionId, 'tx_c100');
      expect(confirm.newBalance, '650.00');
      expect(confirm.status, 'COMPLETED');
    });
  });

  group('Slice 13: Dispute Resolution & User KYC Verification Tests', () {
    test('KycStatusModel correctly parses verification levels', () {
      final unverifiedJson = {
        'data': {
          'user_id': 'u1',
          'kyc_status': 'UNVERIFIED',
          'can_deposit_large': false,
        }
      };
      final unverified = KycStatusModel.fromJson(unverifiedJson);
      expect(unverified.isUnverified, true);
      expect(unverified.isVerified, false);
      expect(unverified.canDepositLarge, false);

      final verifiedJson = {
        'data': {
          'user_id': 'u1',
          'kyc_status': 'VERIFIED',
          'document_type': 'PASSPORT',
          'document_url': 'https://doc.pdf',
          'submitted_at': '2026-11-10T12:00:00Z',
          'verified_at': '2026-11-10T14:00:00Z',
          'can_deposit_large': true,
          'can_create_high_stakes': true,
        }
      };
      final verified = KycStatusModel.fromJson(verifiedJson);
      expect(verified.isVerified, true);
      expect(verified.documentType, 'PASSPORT');
      expect(verified.canDepositLarge, true);
      expect(verified.canCreateHighStakes, true);
    });

    test('BetDisputeModel parses single dispute and list correctly', () {
      final singleJson = {
        'data': {
          'id': 'disp_101',
          'bet_id': 'bet_123',
          'creator_id': 'u101',
          'reason': 'INCORRECT_RESULT',
          'description': 'Discrepancy in goal count',
          'evidence_url': 'https://evidence/match.pdf',
          'status': 'OPEN',
          'created_at': '2026-11-11T10:00:00Z',
          'bet': {'title': 'Arsenal vs Chelsea'},
          'creator': {'name': 'Alex Mercer'},
        }
      };
      final disp = BetDisputeModel.fromJson(singleJson);
      expect(disp.id, 'disp_101');
      expect(disp.betId, 'bet_123');
      expect(disp.reason, 'INCORRECT_RESULT');
      expect(disp.isOpen, true);
      expect(disp.isResolved, false);
      expect(disp.betTitle, 'Arsenal vs Chelsea');
      expect(disp.creatorName, 'Alex Mercer');

      final listJson = [
        {
          'id': 'disp_1',
          'bet_id': 'b1',
          'reason': 'EVENT_CANCELLED',
          'description': 'Match rained out',
          'status': 'RESOLVED',
          'resolution': 'REFUND_ALL',
        },
        {
          'id': 'disp_2',
          'bet_id': 'b2',
          'reason': 'COLLUSION',
          'description': 'Match fixing suspected',
          'status': 'OPEN',
        },
      ];
      final list = BetDisputeModel.fromJsonList(listJson);
      expect(list.length, 2);
      expect(list[0].status, 'RESOLVED');
      expect(list[0].resolution, 'REFUND_ALL');
      expect(list[1].isOpen, true);
    });
  });

  group('Slice 14: PlayStation / Gaming Result Check Tests', () {
    test('GamingSubmissionModel parses single submission correctly', () {
      final json = {
        'player_id': 'u_p1',
        'gamertag': 'ApexStriker',
        'platform': 'PLAYSTATION',
        'my_score': 3,
        'opponent_score': 1,
        'proof_url': 'https://proof/match1.png',
        'submitted_at': '2026-11-11T12:00:00Z',
        'player_name': 'Alex Mercer',
      };
      final sub = GamingSubmissionModel.fromJson(json);
      expect(sub.playerId, 'u_p1');
      expect(sub.gamertag, 'ApexStriker');
      expect(sub.platform, 'PLAYSTATION');
      expect(sub.myScore, 3);
      expect(sub.opponentScore, 1);
      expect(sub.proofUrl, 'https://proof/match1.png');
      expect(sub.playerName, 'Alex Mercer');
    });

    test('GamingMatchCheckModel handles MATCHED dual scores reciprocity', () {
      final json = {
        'data': {
          'bet_id': 'bet_fifa_1',
          'match_status': 'MATCHED',
          'winner_id': 'u_p1',
          'is_auto_resolved': true,
          'submissions': [
            {
              'player_id': 'u_p1',
              'gamertag': 'ApexStriker',
              'platform': 'PLAYSTATION',
              'my_score': 3,
              'opponent_score': 1,
            },
            {
              'player_id': 'u_p2',
              'gamertag': 'DefendingChamp',
              'platform': 'PLAYSTATION',
              'my_score': 1,
              'opponent_score': 3,
            },
          ],
        }
      };
      final match = GamingMatchCheckModel.fromJson(json);
      expect(match.betId, 'bet_fifa_1');
      expect(match.matchStatus, 'MATCHED');
      expect(match.isMatched, true);
      expect(match.isMismatch, false);
      expect(match.isAutoResolved, true);
      expect(match.winnerId, 'u_p1');
      expect(match.submissions.length, 2);
    });

    test('GamingMatchCheckModel handles MISMATCH escalation to dispute', () {
      final json = {
        'data': {
          'bet_id': 'bet_fifa_2',
          'match_status': 'MISMATCH',
          'dispute_id': 'disp_mismatch_1',
          'is_auto_disputed': true,
          'submissions': [
            {
              'player_id': 'u_p1',
              'gamertag': 'ApexStriker',
              'my_score': 3,
              'opponent_score': 1,
            },
            {
              'player_id': 'u_p2',
              'gamertag': 'DefendingChamp',
              'my_score': 2,
              'opponent_score': 2,
            },
          ],
        }
      };
      final match = GamingMatchCheckModel.fromJson(json);
      expect(match.betId, 'bet_fifa_2');
      expect(match.matchStatus, 'MISMATCH');
      expect(match.isMismatch, true);
      expect(match.isAutoDisputed, true);
      expect(match.disputeId, 'disp_mismatch_1');
    });
  });

  group('Slice 15: AI Research Assistant Tests', () {
    test('AiMarketSentimentModel parses sentiment metrics correctly', () {
      final json = {
        'back_percentage': 68.5,
        'oppose_percentage': 31.5,
        'consensus': 'STRONG_BACK',
      };
      final sentiment = AiMarketSentimentModel.fromJson(json);
      expect(sentiment.backPercentage, 68.5);
      expect(sentiment.opposePercentage, 31.5);
      expect(sentiment.consensus, 'STRONG_BACK');
    });

    test('AiBetResearchModel parses complete AI intelligence payload', () {
      final json = {
        'data': {
          'bet_id': 'bet_arsenal_chelsea',
          'topic': 'Arsenal vs Chelsea',
          'summary': 'Arsenal enters London derby undefeated in 6 home matches.',
          'suggested_stance': 'BACK',
          'confidence_score': 0.86,
          'risk_level': 'MODERATE',
          'key_factors': [
            'Arsenal home advantage with 78% win rate',
            'Chelsea key midfielder injured',
          ],
          'market_sentiment': {
            'back_percentage': 68.5,
            'oppose_percentage': 31.5,
            'consensus': 'STRONG_BACK',
          },
          'sources': [
            'Opta Sports Statistics 2026',
            'Premier League Match Centre',
          ],
          'generated_at': '2026-11-11T14:30:00Z',
        }
      };

      final model = AiBetResearchModel.fromJson(json);
      expect(model.betId, 'bet_arsenal_chelsea');
      expect(model.topic, 'Arsenal vs Chelsea');
      expect(model.summary, contains('Arsenal enters London derby'));
      expect(model.suggestedStance, 'BACK');
      expect(model.confidenceScore, 0.86);
      expect(model.riskLevel, 'MODERATE');
      expect(model.keyFactors.length, 2);
      expect(model.sources, contains('Opta Sports Statistics 2026'));
      expect(model.marketSentiment.backPercentage, 68.5);
    });

    test('AiChatResponseModel parses interactive suggestions and reply', () {
      final json = {
        'data': {
          'reply': 'Manage risk carefully with bankroll allocation.',
          'suggestions': [
            'Check head to head records',
            'Compare decimal odds',
          ],
          'sources': ['BetSocial Research Engine'],
        }
      };

      final model = AiChatResponseModel.fromJson(json);
      expect(model.reply, contains('Manage risk carefully'));
      expect(model.suggestions.length, 2);
      expect(model.sources, contains('BetSocial Research Engine'));
    });
  });

  group('Slice 16: Admin Control Panel Tests', () {
    test('AdminOverviewModel parses platform metrics accurately', () {
      final json = {
        'data': {
          'total_users': 1250,
          'active_bets': 48,
          'total_escrow_locked': 142500.5,
          'total_volume_traded': 1280900.0,
          'total_commissions_earned': 128090.0,
          'pending_withdrawals_count': 5,
          'open_disputes_count': 2,
          'unverified_kyc_count': 8,
        }
      };

      final ov = AdminOverviewModel.fromJson(json);
      expect(ov.totalUsers, 1250);
      expect(ov.activeBets, 48);
      expect(ov.totalEscrowLocked, 142500.5);
      expect(ov.totalVolumeTraded, 1280900.0);
      expect(ov.totalCommissionsEarned, 128090.0);
      expect(ov.pendingWithdrawalsCount, 5);
      expect(ov.openDisputesCount, 2);
      expect(ov.unverifiedKycCount, 8);
    });

    test('AdminUserModel parses directory items and status states', () {
      final jsonList = [
        {
          'id': 'u_alex',
          'name': 'Alex Mercer',
          'email': 'alex@example.com',
          'username': 'alexm',
          'role': 'CLIENT',
          'status': 'ACTIVE',
          'kyc_status': 'VERIFIED',
          'wallet_balance': 1250.0,
          'created_at': '2026-11-01T10:00:00Z',
        },
        {
          'id': 'u_bad',
          'name': 'Fraud Actor',
          'role': 'CLIENT',
          'status': 'SUSPENDED',
          'kyc_status': 'REJECTED',
          'wallet_balance': 0.0,
        },
      ];

      final users = AdminUserModel.fromJsonList(jsonList);
      expect(users.length, 2);
      expect(users[0].name, 'Alex Mercer');
      expect(users[0].isActive, true);
      expect(users[0].isSuspended, false);
      expect(users[1].name, 'Fraud Actor');
      expect(users[1].isSuspended, true);
      expect(users[1].isActive, false);
    });

    test('AdminWithdrawalModel parses queue entries correctly', () {
      final jsonList = [
        {
          'id': 'tx_w123',
          'user_id': 'u_alex',
          'user_name': 'Alex Mercer',
          'amount': 250.0,
          'currency': 'USD',
          'status': 'PENDING',
          'payment_method': 'BANK_WIRE',
          'destination': 'IBAN: GB29NWBK60161331926819',
          'created_at': '2026-11-11T13:45:00Z',
        }
      ];

      final list = AdminWithdrawalModel.fromJsonList(jsonList);
      expect(list.length, 1);
      expect(list[0].id, 'tx_w123');
      expect(list[0].userName, 'Alex Mercer');
      expect(list[0].amount, 250.0);
      expect(list[0].isPending, true);
      expect(list[0].paymentMethod, 'BANK_WIRE');
    });
  });

  group('Slice 17: Discovery & Feed Filtering Tests', () {
    test('BetModel parses country and is_featured attributes', () {
      final json = {
        'id': 'bet_explore_1',
        'title': 'Arsenal vs Chelsea Derby',
        'category': 'SPORTS',
        'creator_id': 'u1',
        'status': 'ACTIVE',
        'total_pool': '12500.00',
        'back_pool': '7500.00',
        'oppose_pool': '5000.00',
        'comments_count': 14,
        'country': 'GB',
        'is_featured': true,
      };

      final bet = BetModel.fromJson(json);
      expect(bet.id, 'bet_explore_1');
      expect(bet.country, 'GB');
      expect(bet.isFeatured, true);
    });

    test('TrendingTopicModel parses topic cards and volume', () {
      final jsonList = [
        {
          'tag': 'Premier League',
          'category': 'SPORTS',
          'active_bets_count': 18,
          'total_volume': 45200.0,
        },
        {
          'tag': 'US Elections',
          'category': 'POLITICS',
          'active_bets_count': 12,
          'total_volume': 78900.0,
        },
      ];

      final topics = TrendingTopicModel.fromJsonList(jsonList);
      expect(topics.length, 2);
      expect(topics[0].tag, 'Premier League');
      expect(topics[0].activeBetsCount, 18);
      expect(topics[0].totalVolume, 45200.0);
      expect(topics[1].tag, 'US Elections');
      expect(topics[1].category, 'POLITICS');
    });

    test('DiscoveryCountryModel parses regional options and counts', () {
      final jsonList = [
        {'code': 'GLOBAL', 'name': 'Global / All', 'count': 48},
        {'code': 'US', 'name': 'United States', 'count': 22},
        {'code': 'GB', 'name': 'United Kingdom', 'count': 14},
      ];

      final countries = DiscoveryCountryModel.fromJsonList(jsonList);
      expect(countries.length, 3);
      expect(countries[0].code, 'GLOBAL');
      expect(countries[0].count, 48);
      expect(countries[1].code, 'US');
      expect(countries[2].code, 'GB');
    });
  });
}
