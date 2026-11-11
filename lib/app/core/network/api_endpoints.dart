import '../config/app_config.dart';

class ApiEndpoint {
  ///  Base URL
  static const String domainUrl = AppConfig.domainUrl;
  static const String baseUrl = '$domainUrl/api';

  ///  Auth
  static const String authBase = '$baseUrl/auth';
  static const String register = '$authBase/register'; // post
  static const String login = '$authBase/login'; // post
  static const String me = '$authBase/me'; // get
  static const String logout = '$authBase/logout'; // post

  /// Endpoints whose 401 must not trigger the session-expired flow: bad
  /// credentials on login/register, or an already-expired token on logout.
  static const List<String> _credentialPaths = [login, register, logout];

  static bool isAuthPath(String? path) =>
      path != null && _credentialPaths.any(path.startsWith);

  /// user profile
  static const String profileDetails = '$baseUrl/profile/details'; // get
  static const String profileUpdate = '$baseUrl/profile/update'; // post

  /// Users & Social Graph (Slice 2)
  static String userProfile(String id) => '$baseUrl/users/$id/profile';
  static String userFollow(String id) => '$baseUrl/users/$id/follow';
  static String userReviews(String id) => '$baseUrl/users/$id/reviews';

  /// Personal Profile Posts (Slice 3)
  static String userPosts(String id) => '$baseUrl/users/$id/posts';
  static const String createPost = '$baseUrl/posts';
  static String deletePost(String id) => '$baseUrl/posts/$id';
  static String likePost(String id) => '$baseUrl/posts/$id/like';

  /// Bettor Social Interaction / Bet Comments (Slice 4)
  static String betComments(String betId) => '$baseUrl/bets/$betId/comments';
  static String deleteBetComment(String betId, String commentId) =>
      '$baseUrl/bets/$betId/comments/$commentId';

  /// Public Bets Engine (Slice 5)
  static const String bets = '$baseUrl/bets';
  static String betDetails(String id) => '$baseUrl/bets/$id';

  /// Private Bets & Invite Links (Slice 6)
  static String betInvite(String code) => '$baseUrl/bets/invite/$code';
  static String betInviteJoin(String code) => '$baseUrl/bets/invite/$code/join';
  static String betParticipants(String id) => '$baseUrl/bets/$id/participants';

  /// YES/NO and Custom Outcome Betting (Slice 7)
  static String betStake(String id) => '$baseUrl/bets/$id/stake';
  static String betOutcomes(String id) => '$baseUrl/bets/$id/outcomes';

  /// Matched Betting Engine (Slice 8)
  static String betMatchedStatus(String id) => '$baseUrl/bets/$id/matched-status';
  static String betRefundUnmatched(String id) => '$baseUrl/bets/$id/refund-unmatched';

  /// Escrow & Automated Payout Pool (Slice 9)
  static String betEscrow(String id) => '$baseUrl/bets/$id/escrow';
  static String betResolve(String id) => '$baseUrl/bets/$id/resolve';

  /// Platform Commission & Fee Management (Slice 10)
  static const String feesConfig = '$baseUrl/fees/config';
  static String betCommission(String id) => '$baseUrl/bets/$id/commission';

  /// User Wallet System (Slice 11)
  static const String wallet = '$baseUrl/wallet';
  static const String walletTransactions = '$baseUrl/wallet/transactions';
  static const String walletDeposit = '$baseUrl/wallet/deposit';
  static const String walletWithdraw = '$baseUrl/wallet/withdraw';

  /// Multi-Method Payment Processing (Slice 12)
  static const String paymentMethods = '$baseUrl/payments/methods';
  static const String stripeCreateIntent = '$baseUrl/payments/stripe/create-payment-intent';
  static const String stripeConfirm = '$baseUrl/payments/stripe/confirm';
  static const String bankInstructions = '$baseUrl/payments/bank/instructions';
  static const String bankSubmitProof = '$baseUrl/payments/bank/submit-wire-proof';
  static const String cryptoCreateAddress = '$baseUrl/payments/crypto/create-deposit-address';
  static const String cryptoVerifyDeposit = '$baseUrl/payments/crypto/verify-deposit';

  /// Dispute Resolution & KYC Verification (Slice 13)
  static const String kycStatus = '$baseUrl/kyc/status';
  static const String kycSubmit = '$baseUrl/kyc/submit';
  static const String disputes = '$baseUrl/disputes';
  static String disputeDetail(String id) => '$baseUrl/disputes/$id';
  static String disputeResolve(String id) => '$baseUrl/disputes/$id/resolve';

  /// PlayStation / Gaming Result Check (Slice 14)
  static String gamingSubmitScore(String betId) =>
      '$baseUrl/gaming/$betId/submit-score';
  static String gamingMatchCheck(String betId) =>
      '$baseUrl/gaming/$betId/match-check';

  /// AI Research Assistant (Slice 15)
  static const String aiResearchBet = '$baseUrl/ai/research-bet';
  static const String aiChat = '$baseUrl/ai/chat';
  static String aiBetInsights(String betId) => '$baseUrl/ai/bet-insights/$betId';

  /// Admin Control Panel (Slice 16)
  static const String adminOverview = '$baseUrl/admin/overview';
  static const String adminUsers = '$baseUrl/admin/users';
  static String adminUserStatus(String id) => '$baseUrl/admin/users/$id/status';
  static String adminBetFeature(String id) => '$baseUrl/admin/bets/$id/feature';
  static const String adminWithdrawals = '$baseUrl/admin/withdrawals';
  static String adminWithdrawalReview(String id) =>
      '$baseUrl/admin/withdrawals/$id/review';

  /// Discovery & Feed Filtering (Slice 17)
  static const String exploreBets = '$baseUrl/bets/explore';
  static const String trendingTopics = '$baseUrl/bets/trending-topics';
  static const String supportedCountries = '$baseUrl/bets/countries';
}
