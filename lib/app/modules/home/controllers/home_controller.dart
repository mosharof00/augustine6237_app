import 'package:augustine6237/app/core/network/handle_exceptions.dart';
import 'package:augustine6237/app/core/theme/app_color.dart';
import 'package:augustine6237/app/core/utils/helper_utils.dart';
import 'package:augustine6237/app/data/models/bet_models/bet_model.dart';
import 'package:augustine6237/app/data/models/user_models/user_model.dart';
import 'package:augustine6237/app/data/repositories/auth_repository.dart';
import 'package:augustine6237/app/data/repositories/bet_repository.dart';
import 'package:augustine6237/app/data/repositories/wallet_repository.dart';
import 'package:augustine6237/app/data/models/wallet_models/wallet_model.dart';
import 'package:augustine6237/app/data/repositories/payment_repository.dart';
import 'package:augustine6237/app/data/models/payment_models/payment_model.dart';
import 'package:augustine6237/app/data/repositories/kyc_dispute_repository.dart';
import 'package:augustine6237/app/data/models/kyc_dispute_models/kyc_model.dart';
import 'package:augustine6237/app/data/repositories/gaming_repository.dart';
import 'package:augustine6237/app/data/models/gaming_models/gaming_match_model.dart';
import 'package:augustine6237/app/data/repositories/ai_repository.dart';
import 'package:augustine6237/app/data/models/ai_models/ai_research_model.dart';
import 'package:augustine6237/app/data/repositories/admin_repository.dart';
import 'package:augustine6237/app/data/models/admin_models/admin_control_model.dart';
import 'package:augustine6237/app/data/models/discovery_models/discovery_model.dart';
import 'package:augustine6237/app/global/widgets/global_snackbar.dart';
import 'package:augustine6237/app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final IAuthRepository _authRepository;
  final IBetRepository _betRepository;
  final IWalletRepository _walletRepository;
  final IPaymentRepository _paymentRepository;
  final IKycDisputeRepository _kycDisputeRepository;
  final IGamingRepository _gamingRepository;
  final IAiRepository _aiRepository;
  final IAdminRepository _adminRepository;

  HomeController({
    IAuthRepository? authRepository,
    IBetRepository? betRepository,
    IWalletRepository? walletRepository,
    IPaymentRepository? paymentRepository,
    IKycDisputeRepository? kycDisputeRepository,
    IGamingRepository? gamingRepository,
    IAiRepository? aiRepository,
    IAdminRepository? adminRepository,
  })  : _authRepository = authRepository ?? Get.find<IAuthRepository>(),
        _betRepository = betRepository ?? Get.find<IBetRepository>(),
        _walletRepository = walletRepository ?? Get.find<IWalletRepository>(),
        _paymentRepository = paymentRepository ?? Get.find<IPaymentRepository>(),
        _kycDisputeRepository =
            kycDisputeRepository ?? Get.find<IKycDisputeRepository>(),
        _gamingRepository =
            gamingRepository ?? Get.find<IGamingRepository>(),
        _aiRepository =
            aiRepository ?? Get.find<IAiRepository>(),
        _adminRepository =
            adminRepository ?? Get.find<IAdminRepository>();

  final user = Rxn<UserData>();
  final isUserLoading = false.obs;

  final wallet = Rxn<WalletModel>();
  final transactions = <WalletTransactionModel>[].obs;
  final isWalletLoading = false.obs;
  final isTransactionsLoading = false.obs;

  final paymentMethods = <PaymentMethodModel>[].obs;
  final isPaymentMethodsLoading = false.obs;
  final bankInstructions = Rxn<BankInstructionsModel>();
  final cryptoDepositAddress = Rxn<CryptoAddressModel>();

  final kycStatus = Rxn<KycStatusModel>();
  final isKycLoading = false.obs;
  final disputes = <BetDisputeModel>[].obs;
  final isDisputesLoading = false.obs;

  final gamingMatch = Rxn<GamingMatchCheckModel>();
  final isGamingLoading = false.obs;

  final aiResearch = Rxn<AiBetResearchModel>();
  final isAiLoading = false.obs;
  final aiChatMessages = <Map<String, String>>[].obs;

  final adminOverview = Rxn<AdminOverviewModel>();
  final adminUsers = <AdminUserModel>[].obs;
  final adminWithdrawals = <AdminWithdrawalModel>[].obs;
  final isAdminLoading = false.obs;

  final bets = <BetModel>[].obs;
  final isBetsLoading = false.obs;
  final isCreatingBet = false.obs;

  final selectedCategory = 'ALL'.obs;
  final selectedSort = 'trending'.obs; // 'trending', 'ending_soon', 'newest'
  final searchQuery = ''.obs;
  final selectedCountry = 'GLOBAL'.obs;
  final onlyFeatured = false.obs;
  final trendingTopics = <TrendingTopicModel>[].obs;
  final supportedCountries = <DiscoveryCountryModel>[].obs;
  final isDiscoveryLoading = false.obs;

  bool get isLoggedIn => HelperUtils.isLogin;

  String get avatarUrl => user.value?.hasAvatar == true
      ? user.value!.avatar!
      : HelperUtils.defaultProfileImage;

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn) {
      fetchUser();
      fetchWallet();
    }
    fetchBets();
    fetchTrendingTopics();
    fetchSupportedCountries();
  }

  Future<void> fetchTrendingTopics() async {
    try {
      final res = await _betRepository.getTrendingTopics();
      trendingTopics.assignAll(res);
    } catch (_) {}
  }

  Future<void> fetchSupportedCountries() async {
    try {
      final res = await _betRepository.getSupportedCountries();
      supportedCountries.assignAll(res);
    } catch (_) {}
  }

  void setCountry(String country) {
    if (selectedCountry.value == country) return;
    selectedCountry.value = country;
    fetchBets();
  }

  void toggleOnlyFeatured() {
    onlyFeatured.value = !onlyFeatured.value;
    fetchBets();
  }

  Future<void> fetchUser() async {
    if (isUserLoading.value) return;
    try {
      isUserLoading.value = true;
      final response = await _authRepository.getMe();
      if (response.success == true) user.value = response.data;
    } catch (e) {
      handleException(e, context: 'Home - Get Me');
    } finally {
      isUserLoading.value = false;
    }
  }

  Future<void> fetchBets() async {
    try {
      isBetsLoading.value = true;
      final res = await _betRepository.exploreBets(
        category: selectedCategory.value == 'ALL' ? null : selectedCategory.value,
        sort: selectedSort.value,
        search: searchQuery.value.trim().isEmpty ? null : searchQuery.value.trim(),
        country: selectedCountry.value,
        isFeatured: onlyFeatured.value ? true : null,
      );
      bets.assignAll(res);
    } catch (e) {
      // Non-blocking error toast for feed
    } finally {
      isBetsLoading.value = false;
    }
  }

  void setCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    fetchBets();
  }

  void setSort(String sort) {
    if (selectedSort.value == sort) return;
    selectedSort.value = sort;
    fetchBets();
  }

  void onSearch(String query) {
    searchQuery.value = query;
    fetchBets();
  }

  Future<bool> createBet({
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
  }) async {
    try {
      isCreatingBet.value = true;
      final newBet = await _betRepository.createBet(
        title: title,
        description: description,
        category: category,
        betType: betType,
        outcomes: outcomes,
        deadline: deadline,
        isPrivate: isPrivate,
        initialStake: initialStake,
        initialSide: initialSide,
        initialOutcome: initialOutcome,
      );
      if (!isPrivate) {
        bets.insert(0, newBet);
      }
      globalSnackBar(
        title: isPrivate ? 'Private Bet Created!' : 'Bet Created',
        message: isPrivate
            ? 'Share invite code: ${newBet.inviteCode}'
            : 'Your public bet is now live on BetSocial!',
        backgroundColor: AppColor.statusSuccess,
      );
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Error',
        message: 'Failed to create bet: $e',
        backgroundColor: AppColor.error,
      );
      return false;
    } finally {
      isCreatingBet.value = false;
    }
  }

  Future<bool> placeStake(
    String betId, {
    String? outcomeId,
    String? side,
    required double stake,
  }) async {
    try {
      await _betRepository.placeStake(
        betId,
        outcomeId: outcomeId,
        side: side,
        stake: stake,
      );
      globalSnackBar(
        title: 'Stake Placed!',
        message: 'Successfully staked \$$stake on this prediction.',
        backgroundColor: AppColor.statusSuccess,
      );
      fetchBets();
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Stake Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<BetModel?> lookupInviteBet(String code) async {
    try {
      return await _betRepository.getBetByInviteCode(code);
    } catch (e) {
      globalSnackBar(
        title: 'Invite Not Found',
        message: 'Invalid invite code or bet expired.',
        backgroundColor: AppColor.error,
      );
      return null;
    }
  }

  Future<bool> joinInviteBet(
    String code, {
    required String side,
    required double stake,
  }) async {
    try {
      await _betRepository.joinBetByInviteCode(
        code,
        side: side,
        stake: stake,
      );
      globalSnackBar(
        title: 'Joined Private Bet!',
        message: 'Locked \$$stake on $side stance.',
        backgroundColor: AppColor.statusSuccess,
      );
      fetchBets();
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Failed to Join',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<BetMatchedStatusModel?> getMatchedStatus(String betId) async {
    try {
      return await _betRepository.getBetMatchedStatus(betId);
    } catch (e) {
      globalSnackBar(
        title: 'Error',
        message: 'Failed to fetch matched status: $e',
        backgroundColor: AppColor.error,
      );
      return null;
    }
  }

  Future<bool> refundUnmatched(String betId) async {
    try {
      final res = await _betRepository.refundUnmatchedStakes(betId);
      final count = res['data']?['refunded_count'] ?? 0;
      final total = res['data']?['total_refunded'] ?? '0.00';
      globalSnackBar(
        title: 'Refunds Processed',
        message: 'Refunded \$$total across $count unmatched stake(s).',
        backgroundColor: AppColor.statusSuccess,
      );
      fetchBets();
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Refund Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<BetEscrowModel?> getEscrowStatus(String betId) async {
    try {
      return await _betRepository.getBetEscrowStatus(betId);
    } catch (e) {
      globalSnackBar(
        title: 'Error',
        message: 'Failed to fetch escrow status: $e',
        backgroundColor: AppColor.error,
      );
      return null;
    }
  }

  Future<bool> resolveBet(
    String betId, {
    String? winningSide,
    String? winningOutcomeId,
  }) async {
    try {
      final res = await _betRepository.resolveBet(
        betId,
        winningSide: winningSide,
        winningOutcomeId: winningOutcomeId,
      );
      final totalPaid = res['data']?['total_payout'] ?? '0.00';
      final winners = res['data']?['winners_count'] ?? 0;
      globalSnackBar(
        title: 'Bet Resolved & Paid Out',
        message:
            'Paid \$$totalPaid to $winners winner(s). Wallet balances credited.',
        backgroundColor: AppColor.statusSuccess,
      );
      fetchBets();
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Resolution Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<BetCommissionModel?> getBetCommission(String betId) async {
    try {
      return await _betRepository.getBetCommission(betId);
    } catch (e) {
      globalSnackBar(
        title: 'Error',
        message: 'Failed to fetch bet commission details: $e',
        backgroundColor: AppColor.error,
      );
      return null;
    }
  }

  Future<FeeConfigModel?> getFeeConfig() async {
    try {
      return await _betRepository.getFeeConfig();
    } catch (e) {
      globalSnackBar(
        title: 'Error',
        message: 'Failed to fetch platform fee config: $e',
        backgroundColor: AppColor.error,
      );
      return null;
    }
  }

  Future<void> fetchWallet() async {
    if (isWalletLoading.value) return;
    try {
      isWalletLoading.value = true;
      final res = await _walletRepository.getWallet();
      wallet.value = res;
    } catch (e) {
      // Wallet silent fetch fallback
    } finally {
      isWalletLoading.value = false;
    }
  }

  Future<void> fetchTransactions({String? type, String? status}) async {
    if (isTransactionsLoading.value) return;
    try {
      isTransactionsLoading.value = true;
      final res =
          await _walletRepository.getTransactions(type: type, status: status);
      transactions.assignAll(res);
    } catch (e) {
      globalSnackBar(
        title: 'Error',
        message: 'Failed to load transaction history: $e',
        backgroundColor: AppColor.error,
      );
    } finally {
      isTransactionsLoading.value = false;
    }
  }

  Future<bool> depositWallet(
    double amount, {
    String? paymentMethod,
    String? description,
  }) async {
    try {
      final res = await _walletRepository.deposit(
        amount: amount,
        paymentMethod: paymentMethod,
        description: description,
      );
      final newBal = res['data']?['new_balance'] ?? amount.toStringAsFixed(2);
      globalSnackBar(
        title: 'Deposit Successful',
        message: '\$$amount added. New available balance: \$$newBal',
        backgroundColor: AppColor.statusSuccess,
      );
      await fetchWallet();
      await fetchUser();
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Deposit Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<bool> withdrawWallet(
    double amount, {
    String? payoutMethod,
    String? destinationDetails,
  }) async {
    try {
      final res = await _walletRepository.withdraw(
        amount: amount,
        payoutMethod: payoutMethod,
        destinationDetails: destinationDetails,
      );
      final newBal = res['data']?['new_balance'] ?? '0.00';
      globalSnackBar(
        title: 'Withdrawal Submitted',
        message: 'Requested \$$amount payout. Remaining balance: \$$newBal',
        backgroundColor: AppColor.statusSuccess,
      );
      await fetchWallet();
      await fetchUser();
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Withdrawal Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<void> fetchPaymentMethods() async {
    isPaymentMethodsLoading.value = true;
    try {
      final list = await _paymentRepository.getPaymentMethods();
      paymentMethods.assignAll(list);
    } catch (_) {
      // Keep existing list if available
    } finally {
      isPaymentMethodsLoading.value = false;
    }
  }

  Future<StripeIntentModel?> createStripeIntent(
    double amount, {
    String? currency,
  }) async {
    try {
      return await _paymentRepository.createStripePaymentIntent(
        amount: amount,
        currency: currency,
      );
    } catch (e) {
      globalSnackBar(
        title: 'Stripe Intent Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return null;
    }
  }

  Future<bool> confirmStripePayment(String paymentIntentId) async {
    try {
      final res = await _paymentRepository.confirmStripePayment(
        paymentIntentId: paymentIntentId,
      );
      globalSnackBar(
        title: 'Deposit Confirmed',
        message:
            'Stripe payment verified! New balance: \$${res.newBalance}',
        backgroundColor: AppColor.statusSuccess,
      );
      await fetchWallet();
      await fetchUser();
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Payment Confirmation Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<BankInstructionsModel?> fetchBankInstructions() async {
    try {
      final inst = await _paymentRepository.getBankInstructions();
      bankInstructions.value = inst;
      return inst;
    } catch (e) {
      globalSnackBar(
        title: 'Bank Info Unavailable',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return null;
    }
  }

  Future<bool> submitWireProof({
    required double amount,
    required String senderBank,
    required String referenceNumber,
    String? proofUrl,
    String? notes,
  }) async {
    try {
      await _paymentRepository.submitWireProof(
        amount: amount,
        senderBank: senderBank,
        referenceNumber: referenceNumber,
        proofUrl: proofUrl,
        notes: notes,
      );
      globalSnackBar(
        title: 'Wire Proof Submitted',
        message:
            'Reference $referenceNumber queued for review and wallet credit.',
        backgroundColor: AppColor.statusSuccess,
      );
      await fetchWallet();
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Submission Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<CryptoAddressModel?> generateCryptoAddress(
    String crypto,
    String network,
  ) async {
    try {
      final addr = await _paymentRepository.createCryptoDepositAddress(
        cryptocurrency: crypto,
        network: network,
      );
      cryptoDepositAddress.value = addr;
      return addr;
    } catch (e) {
      globalSnackBar(
        title: 'Address Generation Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return null;
    }
  }

  Future<bool> verifyCryptoDeposit({
    required String txHash,
    required String crypto,
    required String network,
    required double amount,
  }) async {
    try {
      final res = await _paymentRepository.verifyCryptoDeposit(
        txHash: txHash,
        cryptocurrency: crypto,
        network: network,
        amount: amount,
      );
      globalSnackBar(
        title: 'Crypto Deposit Verified',
        message:
            '${res.amount} USD credited via $crypto ($network)! Balance: \$${res.newBalance}',
        backgroundColor: AppColor.statusSuccess,
      );
      await fetchWallet();
      await fetchUser();
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Verification Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<void> fetchKycStatus() async {
    isKycLoading.value = true;
    try {
      final status = await _kycDisputeRepository.getKycStatus();
      kycStatus.value = status;
    } catch (_) {
      // Keep existing state
    } finally {
      isKycLoading.value = false;
    }
  }

  Future<bool> submitKyc({
    required String documentType,
    required String documentNumber,
    required String documentUrl,
    String? fullName,
    String? country,
    String? dateOfBirth,
  }) async {
    try {
      await _kycDisputeRepository.submitKyc(
        documentType: documentType,
        documentNumber: documentNumber,
        documentUrl: documentUrl,
        fullName: fullName,
        country: country,
        dateOfBirth: dateOfBirth,
      );
      globalSnackBar(
        title: 'KYC Submitted',
        message: 'Your identity documents have been submitted for review.',
        backgroundColor: AppColor.statusSuccess,
      );
      await fetchKycStatus();
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'KYC Submission Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<void> fetchDisputes({
    String? betId,
    String? status,
    bool? myDisputes,
  }) async {
    isDisputesLoading.value = true;
    try {
      final list = await _kycDisputeRepository.getDisputes(
        betId: betId,
        status: status,
        myDisputes: myDisputes,
      );
      disputes.assignAll(list);
    } catch (_) {
      // Keep existing state
    } finally {
      isDisputesLoading.value = false;
    }
  }

  Future<bool> createBetDispute({
    required String betId,
    required String reason,
    required String description,
    String? evidenceUrl,
  }) async {
    try {
      final disp = await _kycDisputeRepository.createDispute(
        betId: betId,
        reason: reason,
        description: description,
        evidenceUrl: evidenceUrl,
      );
      globalSnackBar(
        title: 'Dispute Filed',
        message: 'Dispute #${disp.id} logged. Escrow pool frozen for review.',
        backgroundColor: AppColor.statusPending,
      );
      await fetchBets();
      await fetchDisputes(betId: betId);
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Dispute Submission Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<bool> resolveBetDispute({
    required String disputeId,
    required String resolution,
    required String resolutionNotes,
    String? newWinningSide,
    String? newWinningOutcomeId,
  }) async {
    try {
      await _kycDisputeRepository.resolveDispute(
        disputeId: disputeId,
        resolution: resolution,
        resolutionNotes: resolutionNotes,
        newWinningSide: newWinningSide,
        newWinningOutcomeId: newWinningOutcomeId,
      );
      globalSnackBar(
        title: 'Dispute Resolved',
        message: 'Resolution applied: $resolution',
        backgroundColor: AppColor.statusSuccess,
      );
      await fetchBets();
      await fetchDisputes();
      return true;
    } catch (e) {
      globalSnackBar(
        title: 'Resolution Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    }
  }

  Future<GamingMatchCheckModel?> fetchGamingMatchCheck(String betId) async {
    isGamingLoading.value = true;
    try {
      final res = await _gamingRepository.getMatchCheck(betId);
      gamingMatch.value = res;
      return res;
    } catch (e) {
      return null;
    } finally {
      isGamingLoading.value = false;
    }
  }

  Future<GamingMatchCheckModel?> submitGamingScore({
    required String betId,
    required int myScore,
    required int opponentScore,
    String? platform,
    String? gamertag,
    String? proofUrl,
  }) async {
    isGamingLoading.value = true;
    try {
      final res = await _gamingRepository.submitScore(
        betId: betId,
        myScore: myScore,
        opponentScore: opponentScore,
        platform: platform,
        gamertag: gamertag,
        proofUrl: proofUrl,
      );
      gamingMatch.value = res;
      if (res.isMatched) {
        globalSnackBar(
          title: 'Scores Matched!',
          message: 'Dual-player score verified. Payouts distributed automatically.',
          backgroundColor: AppColor.statusSuccess,
        );
      } else if (res.isMismatch) {
        globalSnackBar(
          title: 'Score Mismatch Detected',
          message: 'Mismatch escalated to arbitration. Bet escrow has been frozen.',
          backgroundColor: AppColor.error,
        );
      } else {
        globalSnackBar(
          title: 'Score Submitted',
          message: 'Awaiting opponent score verification.',
          backgroundColor: AppColor.actionBack,
        );
      }
      await fetchBets();
      return res;
    } catch (e) {
      globalSnackBar(
        title: 'Score Submission Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return null;
    } finally {
      isGamingLoading.value = false;
    }
  }

  Future<AiBetResearchModel?> researchBet({
    required String betId,
    String? prompt,
  }) async {
    isAiLoading.value = true;
    try {
      final res = await _aiRepository.researchBet(betId: betId, prompt: prompt);
      aiResearch.value = res;
      return res;
    } catch (e) {
      globalSnackBar(
        title: 'AI Research Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return null;
    } finally {
      isAiLoading.value = false;
    }
  }

  Future<AiBetResearchModel?> fetchBetInsights(String betId) async {
    isAiLoading.value = true;
    try {
      final res = await _aiRepository.getBetInsights(betId);
      aiResearch.value = res;
      return res;
    } catch (e) {
      return null;
    } finally {
      isAiLoading.value = false;
    }
  }

  Future<AiChatResponseModel?> sendAiChatMessage({
    required String query,
    String? betId,
  }) async {
    isAiLoading.value = true;
    aiChatMessages.add({'role': 'user', 'content': query});
    try {
      final history = aiChatMessages
          .map((m) => {'role': m['role'] ?? 'user', 'content': m['content'] ?? ''})
          .toList();
      final res = await _aiRepository.chat(
        query: query,
        betId: betId,
        history: history,
      );
      aiChatMessages.add({'role': 'assistant', 'content': res.reply});
      return res;
    } catch (e) {
      aiChatMessages.add({
        'role': 'assistant',
        'content': 'Unable to complete AI analysis: ${e.toString()}',
      });
      return null;
    } finally {
      isAiLoading.value = false;
    }
  }

  Future<AdminOverviewModel?> fetchAdminOverview() async {
    isAdminLoading.value = true;
    try {
      final res = await _adminRepository.getOverview();
      adminOverview.value = res;
      return res;
    } catch (e) {
      return null;
    } finally {
      isAdminLoading.value = false;
    }
  }

  Future<List<AdminUserModel>> fetchAdminUsers({String? search, String? status}) async {
    isAdminLoading.value = true;
    try {
      final res = await _adminRepository.getUsers(search: search, status: status);
      adminUsers.assignAll(res);
      return res;
    } catch (e) {
      return [];
    } finally {
      isAdminLoading.value = false;
    }
  }

  Future<bool> updateUserStatus(String userId, String status, {String? reason}) async {
    isAdminLoading.value = true;
    try {
      final res = await _adminRepository.updateUserStatus(
        userId: userId,
        status: status,
        reason: reason,
      );
      if (res) {
        globalSnackBar(
          title: 'User Moderated',
          message: 'Account status updated to $status',
          backgroundColor: AppColor.statusSuccess,
        );
        await fetchAdminUsers();
      }
      return res;
    } catch (e) {
      globalSnackBar(
        title: 'Moderation Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    } finally {
      isAdminLoading.value = false;
    }
  }

  Future<bool> toggleFeatureBet(String betId, bool isFeatured) async {
    isAdminLoading.value = true;
    try {
      final res = await _adminRepository.featureBet(
        betId: betId,
        isFeatured: isFeatured,
      );
      if (res) {
        globalSnackBar(
          title: isFeatured ? 'Bet Featured' : 'Bet Unfeatured',
          message: 'Discovery priority has been updated',
          backgroundColor: AppColor.statusSuccess,
        );
        await fetchBets();
      }
      return res;
    } catch (e) {
      globalSnackBar(
        title: 'Feature Update Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    } finally {
      isAdminLoading.value = false;
    }
  }

  Future<List<AdminWithdrawalModel>> fetchAdminWithdrawals() async {
    isAdminLoading.value = true;
    try {
      final res = await _adminRepository.getWithdrawals();
      adminWithdrawals.assignAll(res);
      return res;
    } catch (e) {
      return [];
    } finally {
      isAdminLoading.value = false;
    }
  }

  Future<bool> reviewWithdrawal(String transactionId, String action, {String? notes}) async {
    isAdminLoading.value = true;
    try {
      final res = await _adminRepository.reviewWithdrawal(
        transactionId: transactionId,
        action: action,
        notes: notes,
      );
      if (res) {
        globalSnackBar(
          title: 'Withdrawal Processed',
          message: 'Decision applied: $action',
          backgroundColor: action == 'APPROVED' ? AppColor.statusSuccess : AppColor.actionOppose,
        );
        await fetchAdminWithdrawals();
        await fetchAdminOverview();
      }
      return res;
    } catch (e) {
      globalSnackBar(
        title: 'Review Failed',
        message: e.toString(),
        backgroundColor: AppColor.error,
      );
      return false;
    } finally {
      isAdminLoading.value = false;
    }
  }

  void onAuthAction() {
    if (isLoggedIn) {
      HelperUtils.confirmLogout();
    } else {
      Get.toNamed(Routes.LOGIN);
    }
  }
}
