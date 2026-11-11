import 'package:augustine6237/app/core/theme/app_color.dart';
import 'package:augustine6237/app/data/models/bet_models/bet_model.dart';
import 'package:augustine6237/app/modules/bet_comments/views/bet_comments_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.actionBack.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'BetSocial',
                style: TextStyle(
                  color: AppColor.actionBack,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Obx(() {
            if (controller.isLoggedIn) {
              final bal = controller.wallet.value?.balance ??
                  controller.user.value?.balance ??
                  '0.00';
              return Center(
                child: InkWell(
                  onTap: () => _showWalletSheet(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColor.surfaceSubtle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.borderSubtle),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            size: 14, color: AppColor.statusSuccess),
                        const SizedBox(width: 4),
                        Text(
                          '\$$bal',
                          style: const TextStyle(
                            color: AppColor.statusSuccess,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          Obx(() {
            if (controller.isLoggedIn) {
              final kyc = controller.kycStatus.value;
              final isVerified = kyc?.isVerified == true;
              final isPending = kyc?.isPending == true;
              final color = isVerified
                  ? AppColor.statusSuccess
                  : (isPending ? AppColor.statusPending : AppColor.textDim);
              final label =
                  isVerified ? 'KYC' : (isPending ? 'KYC...' : 'Verify');

              return Center(
                child: InkWell(
                  onTap: () => _showKycVerificationDialog(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVerified ? Icons.verified : Icons.shield_outlined,
                          size: 13,
                          color: color,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          label,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          IconButton(
            onPressed: () => _showDisputesSheet(context),
            icon: const Icon(Icons.gavel_outlined, color: AppColor.textSecondary),
            tooltip: 'Disputes & Arbitration',
          ),
          IconButton(
            onPressed: () => _showAdminPanelSheet(context),
            icon: const Icon(Icons.admin_panel_settings_outlined, color: AppColor.textSecondary),
            tooltip: 'Admin Control Panel',
          ),
          IconButton(
            onPressed: () => _showJoinInviteModal(context),
            icon: const Icon(Icons.vpn_key_outlined, color: AppColor.textSecondary),
            tooltip: 'Join with Invite Code',
          ),
          IconButton(
            onPressed: () => _showCreateBetModal(context),
            icon: const Icon(Icons.add_circle, color: AppColor.actionBack),
            tooltip: 'Create Bet',
          ),
          IconButton(
            onPressed: controller.onAuthAction,
            icon: Icon(
              controller.isLoggedIn ? Icons.logout : Icons.login,
              color: AppColor.textSecondary,
            ),
            tooltip: controller.isLoggedIn ? 'Logout' : 'Login',
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColor.actionBack,
        backgroundColor: AppColor.surface,
        onRefresh: () async => controller.fetchBets(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Input
              TextField(
                onChanged: controller.onSearch,
                style: const TextStyle(color: AppColor.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search sports, politics, public bets...',
                  hintStyle: const TextStyle(color: AppColor.textDim, fontSize: 13),
                  prefixIcon:
                      const Icon(Icons.search, color: AppColor.textDim, size: 18),
                  filled: true,
                  fillColor: AppColor.surface,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.actionBack),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Category Pills Carousel
              _buildCategoryChips(),

              const SizedBox(height: 10),

              // Country & Featured Filter Row
              _buildCountryAndFeaturedFilter(),

              const SizedBox(height: 10),

              // Trending Topics Carousel
              _buildTrendingTopics(),

              const SizedBox(height: 12),

              // Sort Tabs Row
              _buildSortTabs(),

              const SizedBox(height: 14),

              // Bets Stream
              Obx(() {
                if (controller.isBetsLoading.value && controller.bets.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColor.actionBack),
                    ),
                  );
                }

                if (controller.bets.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.borderSubtle),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.sports_esports_outlined,
                              size: 48, color: AppColor.textDim),
                          const SizedBox(height: 12),
                          const Text(
                            'No bets found in this category',
                            style: TextStyle(
                              color: AppColor.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Be the first bettor to create a prediction market!',
                            style:
                                TextStyle(color: AppColor.textDim, fontSize: 12),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.actionBack,
                            ),
                            onPressed: () => _showCreateBetModal(context),
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Create New Bet',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.bets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final bet = controller.bets[index];
                    return _buildBetCard(context, bet);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = [
      {'label': 'All', 'value': 'ALL'},
      {'label': 'Sports', 'value': 'SPORTS'},
      {'label': 'Politics', 'value': 'POLITICS'},
      {'label': 'Public Issues', 'value': 'PUBLIC_ISSUES'},
      {'label': 'Crypto', 'value': 'CRYPTO'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: categories.map((cat) {
            final isSelected = controller.selectedCategory.value == cat['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => controller.setCategory(cat['value']!),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.actionBack
                        : AppColor.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColor.actionBack
                          : AppColor.borderSubtle,
                    ),
                  ),
                  child: Text(
                    cat['label']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColor.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCountryAndFeaturedFilter() {
    final countries = [
      {'code': 'GLOBAL', 'label': '🌐 Global'},
      {'code': 'US', 'label': '🇺🇸 USA'},
      {'code': 'GB', 'label': '🇬🇧 UK'},
      {'code': 'NG', 'label': '🇳🇬 Nigeria'},
      {'code': 'CA', 'label': '🇨🇦 Canada'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: [
            ...countries.map((c) {
              final isSelected = controller.selectedCountry.value == c['code'];
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => controller.setCountry(c['code']!),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.surfaceSubtle : AppColor.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.actionBack
                            : AppColor.borderSubtle,
                      ),
                    ),
                    child: Text(
                      c['label']!,
                      style: TextStyle(
                        color: isSelected
                            ? AppColor.actionBack
                            : AppColor.textSecondary,
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
            GestureDetector(
              onTap: controller.toggleOnlyFeatured,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: controller.onlyFeatured.value
                      ? Colors.amber.withValues(alpha: 0.2)
                      : AppColor.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: controller.onlyFeatured.value
                        ? Colors.amber
                        : AppColor.borderSubtle,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 11,
                      color: controller.onlyFeatured.value
                          ? Colors.amber
                          : AppColor.textDim,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Featured',
                      style: TextStyle(
                        color: controller.onlyFeatured.value
                            ? Colors.amber
                            : AppColor.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingTopics() {
    return Obx(() {
      if (controller.trendingTopics.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.trendingTopics.map((topic) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () => controller.onSearch(topic.tag),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColor.surfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.borderSubtle),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up,
                              size: 11, color: AppColor.actionBack),
                          const SizedBox(width: 4),
                          Text(
                            topic.tag,
                            style: const TextStyle(
                              color: AppColor.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColor.surface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${topic.activeBetsCount}',
                              style: const TextStyle(
                                color: AppColor.textDim,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSortTabs() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildSortButton('trending', 'Trending'),
              const SizedBox(width: 8),
              _buildSortButton('ending_soon', 'Ending Soon'),
              const SizedBox(width: 8),
              _buildSortButton('newest', 'Newest'),
            ],
          ),
          Text(
            '${controller.bets.length} Bets',
            style: const TextStyle(color: AppColor.textDim, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(String value, String label) {
    final isSelected = controller.selectedSort.value == value;
    return GestureDetector(
      onTap: () => controller.setSort(value),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColor.actionBack : AppColor.textDim,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBetCard(BuildContext context, BetModel bet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Category tag + Deadline pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColor.surfaceSubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  bet.category.toUpperCase(),
                  style: const TextStyle(
                    color: AppColor.actionBack,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (bet.isFeatured) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 10, color: Colors.amber),
                      SizedBox(width: 3),
                      Text(
                        'FEATURED',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (bet.country != 'GLOBAL') ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColor.surfaceSubtle,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    bet.country,
                    style: const TextStyle(
                      color: AppColor.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              if (bet.isPrivate && bet.inviteCode != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColor.actionBack.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline,
                          size: 10, color: AppColor.actionBack),
                      const SizedBox(width: 3),
                      Text(
                        bet.inviteCode!,
                        style: const TextStyle(
                          color: AppColor.actionBack,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 13, color: AppColor.statusPending),
                  const SizedBox(width: 4),
                  Text(
                    bet.timeRemainingText,
                    style: const TextStyle(
                      color: AppColor.statusPending,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Bet Title
          Text(
            bet.title,
            style: const TextStyle(
              color: AppColor.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (bet.description != null && bet.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              bet.description!,
              style: const TextStyle(
                color: AppColor.textSecondary,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Matched Status & Odds Pill
          Row(
            children: [
              InkWell(
                onTap: () => _showMatchedStatusSheet(context, bet),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColor.surfaceSubtle,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColor.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sync_alt,
                          size: 11, color: AppColor.actionBack),
                      const SizedBox(width: 4),
                      Text(
                        bet.matchedPoolDouble > 0
                            ? '\$${bet.matchedPool} Matched'
                            : 'Open Pool',
                        style: const TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.info_outline,
                          size: 11, color: AppColor.textDim),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => _showEscrowSheet(context, bet),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: bet.status == 'RESOLVED'
                        ? AppColor.statusSuccess.withValues(alpha: 0.15)
                        : AppColor.surfaceSubtle,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: bet.status == 'RESOLVED'
                          ? AppColor.statusSuccess.withValues(alpha: 0.4)
                          : AppColor.borderSubtle,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        bet.status == 'RESOLVED'
                            ? Icons.verified
                            : Icons.lock_outline,
                        size: 11,
                        color: bet.status == 'RESOLVED'
                            ? AppColor.statusSuccess
                            : AppColor.statusPending,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        bet.status == 'RESOLVED' ? 'Settled' : 'Escrow',
                        style: TextStyle(
                          color: bet.status == 'RESOLVED'
                              ? AppColor.statusSuccess
                              : AppColor.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => _showCommissionSheet(context, bet),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColor.surfaceSubtle,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColor.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.percent,
                          size: 10, color: AppColor.actionBack),
                      const SizedBox(width: 3),
                      Text(
                        '${bet.commissionRate}%',
                        style: const TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (bet.betType != 'CUSTOM')
                Text(
                  'Back @ ${bet.backOdds.toStringAsFixed(2)}x · Oppose @ ${bet.opposeOdds.toStringAsFixed(2)}x',
                  style: const TextStyle(
                    color: AppColor.textDim,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Render outcomes based on bet_type (CUSTOM vs BINARY)
          if (bet.betType == 'CUSTOM' && bet.outcomes.isNotEmpty)
            _buildCustomOutcomesList(bet)
          else
            _buildRatioBar(bet),

          const SizedBox(height: 14),

          // Actions Row: Stake Buttons + Comments
          if (bet.betType == 'CUSTOM')
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.how_to_vote_outlined, size: 16),
                    label: const Text(
                      'Stake on Outcome',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.actionBack,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () => _showStakeDialog(context, bet),
                  ),
                ),
                const SizedBox(width: 8),
                _buildCommentButton(context, bet),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.actionBack,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () =>
                        _showStakeDialog(context, bet, side: 'BACK'),
                    child: const Text(
                      'Back (Yes)',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.actionOppose,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () =>
                        _showStakeDialog(context, bet, side: 'OPPOSE'),
                    child: const Text(
                      'Oppose (No)',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildCommentButton(context, bet),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCommentButton(BuildContext context, BetModel bet) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: AppColor.surfaceSubtle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.forum_outlined,
              size: 16, color: AppColor.textSecondary),
          if (bet.commentsCount > 0) ...[
            const SizedBox(width: 4),
            Text(
              '${bet.commentsCount}',
              style: const TextStyle(
                color: AppColor.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
      onPressed: () => BetCommentsSheet.show(
        context,
        betId: bet.id,
        betTitle: bet.title,
      ),
    );
  }

  Widget _buildCustomOutcomesList(BetModel bet) {
    return Column(
      children: bet.outcomes.map((outcome) {
        final pct = outcome.percent;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.surfaceSubtle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      outcome.title,
                      style: const TextStyle(
                        color: AppColor.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '\$${outcome.pool} (${pct.toStringAsFixed(0)}%)',
                    style: const TextStyle(
                      color: AppColor.actionBack,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (pct / 100).clamp(0.0, 1.0),
                  backgroundColor: AppColor.surface,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColor.actionBack),
                  minHeight: 5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRatioBar(BetModel bet) {
    final backPct = bet.backPercent;
    final opposePct = bet.opposePercent;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Back: \$${bet.backPool} (${backPct.toStringAsFixed(0)}%)',
              style: const TextStyle(
                color: AppColor.actionBack,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Oppose: \$${bet.opposePool} (${opposePct.toStringAsFixed(0)}%)',
              style: const TextStyle(
                color: AppColor.actionOppose,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 6,
            child: Row(
              children: [
                Expanded(
                  flex: (backPct * 10).toInt(),
                  child: Container(color: AppColor.actionBack),
                ),
                Expanded(
                  flex: (opposePct * 10).toInt(),
                  child: Container(color: AppColor.actionOppose),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMatchedStatusSheet(BuildContext context, BetModel bet) {
    Get.bottomSheet(
      FutureBuilder<BetMatchedStatusModel?>(
        future: controller.getMatchedStatus(bet.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 250,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final status = snapshot.data;
          if (status == null) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: Text(
                  'Failed to load matched betting data',
                  style: TextStyle(color: AppColor.textSecondary),
                ),
              ),
            );
          }

          final unmatchedVal = double.tryParse(status.unmatchedPool) ?? 0.0;

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Matched Betting Order Pool',
                        style: TextStyle(
                          color: AppColor.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                              AppColor.statusSuccess.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '\$${status.matchedPool} MATCHED',
                          style: const TextStyle(
                            color: AppColor.statusSuccess,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bet.title,
                    style: const TextStyle(
                      color: AppColor.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Pools Breakdown Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColor.surfaceSubtle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColor.borderSubtle),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Matched Pool',
                                style: TextStyle(
                                  color: AppColor.textDim,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${status.matchedPool}',
                                style: const TextStyle(
                                  color: AppColor.actionBack,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColor.surfaceSubtle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColor.borderSubtle),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Unmatched Pool',
                                style: TextStyle(
                                  color: AppColor.textDim,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${status.unmatchedPool}',
                                style: TextStyle(
                                  color: unmatchedVal > 0
                                      ? AppColor.statusPending
                                      : AppColor.textSecondary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Odds Summary
                  if (status.betType != 'CUSTOM')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColor.surfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Back Odds: ${status.backOdds}x',
                            style: const TextStyle(
                              color: AppColor.actionBack,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Oppose Odds: ${status.opposeOdds}x',
                            style: const TextStyle(
                              color: AppColor.actionOppose,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Participants match roster
                  const Text(
                    'Participant Orders & Stances',
                    style: TextStyle(
                      color: AppColor.textDim,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ...status.participants.map((p) {
                    Color statusColor = AppColor.textDim;
                    if (p.matchStatus == 'MATCHED') {
                      statusColor = AppColor.statusSuccess;
                    } else if (p.matchStatus == 'PARTIALLY_MATCHED') {
                      statusColor = AppColor.statusPending;
                    } else if (p.matchStatus == 'REFUNDED') {
                      statusColor = Colors.purpleAccent;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.surfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.borderSubtle),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${p.user?.name ?? "Bettor"} (${p.side})',
                                style: const TextStyle(
                                  color: AppColor.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Matched: \$${p.matchedStake} · Unmatched: \$${p.unmatchedStake}',
                                style: const TextStyle(
                                  color: AppColor.textDim,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              p.matchStatus,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  if (unmatchedVal > 0) ...[
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.surfaceSubtle,
                        foregroundColor: AppColor.statusPending,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              const BorderSide(color: AppColor.statusPending),
                        ),
                      ),
                      onPressed: () async {
                        Get.back();
                        await controller.refundUnmatched(bet.id);
                      },
                      icon: const Icon(Icons.currency_exchange, size: 16),
                      label: Text(
                        'Refund \$${status.unmatchedPool} Unmatched Stakes',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showEscrowSheet(BuildContext context, BetModel bet) {
    Get.bottomSheet(
      FutureBuilder<BetEscrowModel?>(
        future: controller.getEscrowStatus(bet.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: AppColor.actionBack),
              ),
            );
          }

          final escrow = snapshot.data;
          if (escrow == null) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: Text(
                  'Failed to load escrow status',
                  style: TextStyle(color: AppColor.textSecondary),
                ),
              ),
            );
          }

          final isSettled = escrow.status == 'RESOLVED' ||
              escrow.escrowStatus == 'SETTLED';

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle indicator
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColor.borderSubtle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSettled
                              ? AppColor.statusSuccess.withValues(alpha: 0.15)
                              : AppColor.actionBack.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isSettled ? Icons.verified : Icons.lock_outline,
                          color: isSettled
                              ? AppColor.statusSuccess
                              : AppColor.actionBack,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Escrow & Payout Pool',
                              style: TextStyle(
                                color: AppColor.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              isSettled
                                  ? 'Settled & Distributed'
                                  : 'Funds Locked in Escrow',
                              style: TextStyle(
                                color: isSettled
                                    ? AppColor.statusSuccess
                                    : AppColor.statusPending,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Escrow Pool Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.surfaceSubtle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColor.borderSubtle),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Locked Pool',
                                style: TextStyle(
                                  color: AppColor.textDim,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${escrow.totalEscrow}',
                                style: const TextStyle(
                                  color: AppColor.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.surfaceSubtle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColor.borderSubtle),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSettled ? 'Paid Out Pool' : 'Matched Escrow',
                                style: const TextStyle(
                                  color: AppColor.textDim,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${escrow.matchedPool}',
                                style: const TextStyle(
                                  color: AppColor.statusSuccess,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColor.actionBack.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColor.actionBack.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.percent,
                            color: AppColor.actionBack, size: 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isSettled && escrow.commissionAmount != '0.00'
                                ? 'Platform Fee: ${escrow.commissionRate}% (\$${escrow.commissionAmount} deducted on net profit)'
                                : 'Platform Fee: ${escrow.commissionRate}% on Net Profit only',
                            style: const TextStyle(
                              color: AppColor.actionBack,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            _showCommissionSheet(context, bet);
                          },
                          child: const Text(
                            'Details >',
                            style: TextStyle(
                              color: AppColor.actionBack,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Winner Result Banner if resolved
                  if (isSettled && escrow.winningSide != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.statusSuccess.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColor.statusSuccess.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.emoji_events,
                              color: AppColor.statusSuccess, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Winning Outcome: ${escrow.winningSide}',
                                  style: const TextStyle(
                                    color: AppColor.statusSuccess,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${escrow.winnersCount} winner(s) credited proportionally',
                                  style: const TextStyle(
                                    color: AppColor.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 18),
                  Text(
                    'Participant Payouts (${escrow.payouts.length})',
                    style: const TextStyle(
                      color: AppColor.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (escrow.payouts.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.surfaceSubtle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'No orders in escrow yet',
                          style: TextStyle(
                            color: AppColor.textDim,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  else
                    ...escrow.payouts.map((p) {
                      final isWin = p.isWinner == true;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.surfaceSubtle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isWin
                                ? AppColor.statusSuccess.withValues(alpha: 0.3)
                                : AppColor.borderSubtle,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColor.surface,
                              child: Text(
                                p.userName.isNotEmpty
                                    ? p.userName[0].toUpperCase()
                                    : 'B',
                                style: const TextStyle(
                                  color: AppColor.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        p.userName,
                                        style: const TextStyle(
                                          color: AppColor.textPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 1.5),
                                        decoration: BoxDecoration(
                                          color: (p.side == 'BACK'
                                                  ? AppColor.actionBack
                                                  : AppColor.actionOppose)
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          p.outcomeTitle ?? p.side,
                                          style: TextStyle(
                                            color: p.side == 'BACK'
                                                ? AppColor.actionBack
                                                : AppColor.actionOppose,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Stake: \$${p.stake} (Matched: \$${p.matchedStake})',
                                    style: const TextStyle(
                                      color: AppColor.textDim,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  isWin
                                      ? '+\$${p.payoutAmount}'
                                      : (isSettled ? '\$0.00' : 'In Escrow'),
                                  style: TextStyle(
                                    color: isWin
                                        ? AppColor.statusSuccess
                                        : AppColor.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (isWin && p.roiPercent > 0)
                                  Text(
                                    '+${p.roiPercent.toStringAsFixed(1)}% ROI',
                                    style: const TextStyle(
                                      color: AppColor.statusSuccess,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                else if (isSettled && !isWin)
                                  const Text(
                                    'Lost',
                                    style: TextStyle(
                                      color: AppColor.statusFailed,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                  // Resolve action button if bet is still open
                  if (!isSettled) ...[
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.actionBack,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        _showResolveDialog(context, bet);
                      },
                      icon: const Icon(Icons.gavel, size: 16),
                      label: const Text(
                        'Declare Winner & Distribute Escrow',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.actionOppose,
                      side: const BorderSide(color: AppColor.actionOppose),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      _showDisputeDialog(context, bet);
                    },
                    icon: const Icon(Icons.report_problem_outlined, size: 16),
                    label: const Text(
                      'Dispute Bet Outcome',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF818CF8),
                      side: const BorderSide(color: Color(0xFF6366F1)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      _showGamingScoreDialog(context, bet);
                    },
                    icon: const Icon(Icons.sports_esports_outlined, size: 16),
                    label: const Text(
                      'PlayStation / Gaming Result Check',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF38BDF8),
                      side: const BorderSide(color: Color(0xFF0EA5E9)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      _showAiResearchSheet(context, bet);
                    },
                    icon: const Icon(Icons.auto_awesome, size: 16),
                    label: const Text(
                      'AI Research Assistant',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showCommissionSheet(BuildContext context, BetModel bet) {
    Get.bottomSheet(
      FutureBuilder<BetCommissionModel?>(
        future: controller.getBetCommission(bet.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: AppColor.actionBack),
              ),
            );
          }

          final comm = snapshot.data;
          if (comm == null) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: Text(
                  'Failed to load commission details',
                  style: TextStyle(color: AppColor.textSecondary),
                ),
              ),
            );
          }

          final isResolved = comm.status == 'RESOLVED';

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColor.borderSubtle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.actionBack.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.account_balance,
                            color: AppColor.actionBack, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Platform Fee & Commission',
                              style: TextStyle(
                                color: AppColor.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              comm.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColor.textDim,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.surfaceSubtle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.borderSubtle),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Commission Rate',
                              style: TextStyle(
                                  color: AppColor.textSecondary, fontSize: 12),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color:
                                    AppColor.actionBack.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${comm.commissionRate}% on Net Profit',
                                style: const TextStyle(
                                  color: AppColor.actionBack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: AppColor.borderSubtle, height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Gross Payout Pool',
                                style: TextStyle(
                                    color: AppColor.textSecondary,
                                    fontSize: 12)),
                            Text('\$${comm.grossPayoutPool}',
                                style: const TextStyle(
                                    color: AppColor.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Platform Fee Collected',
                                style: TextStyle(
                                    color: AppColor.textSecondary,
                                    fontSize: 12)),
                            Text(
                              isResolved
                                  ? '-\$${comm.totalCommissionCollected}'
                                  : 'Est. ${comm.commissionRate}%',
                              style: const TextStyle(
                                  color: AppColor.statusPending,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Net Distributed to Bettors',
                                style: TextStyle(
                                    color: AppColor.textSecondary,
                                    fontSize: 12)),
                            Text(
                              '\$${comm.netPayoutPool}',
                              style: const TextStyle(
                                  color: AppColor.statusSuccess,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Fee Deductions by Bettor (${comm.participantFees.length})',
                    style: const TextStyle(
                      color: AppColor.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (comm.participantFees.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColor.surfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'No participants in fee roster yet',
                          style:
                              TextStyle(color: AppColor.textDim, fontSize: 12),
                        ),
                      ),
                    )
                  else
                    ...comm.participantFees.map((p) {
                      final hasProfit = double.tryParse(p.netProfit) != null &&
                          double.parse(p.netProfit) > 0;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.surfaceSubtle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColor.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColor.surface,
                              child: Text(
                                p.userName.isNotEmpty
                                    ? p.userName[0].toUpperCase()
                                    : 'B',
                                style: const TextStyle(
                                    color: AppColor.textPrimary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.userName,
                                    style: const TextStyle(
                                      color: AppColor.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Matched: \$${p.matchedStake} · Profit: \$${p.netProfit}',
                                    style: const TextStyle(
                                        color: AppColor.textDim, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  hasProfit
                                      ? '-\$${p.commissionDeducted} fee'
                                      : 'No fee',
                                  style: TextStyle(
                                    color: hasProfit
                                        ? AppColor.statusPending
                                        : AppColor.textDim,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Net: \$${p.netPayout}',
                                  style: const TextStyle(
                                    color: AppColor.statusSuccess,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showResolveDialog(BuildContext context, BetModel bet) {
    String selectedWinningSide = 'BACK';
    String? selectedOutcomeId =
        bet.betType == 'CUSTOM' && bet.outcomes.isNotEmpty
            ? bet.outcomes.first.id
            : null;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColor.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.gavel, color: AppColor.actionBack, size: 22),
                SizedBox(width: 8),
                Text(
                  'Resolve Bet',
                  style: TextStyle(
                    color: AppColor.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bet.title,
                  style: const TextStyle(
                    color: AppColor.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Select Official Winner:',
                  style: TextStyle(
                    color: AppColor.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (bet.betType == 'CUSTOM' && bet.outcomes.isNotEmpty)
                  ...bet.outcomes.map((o) {
                    final isSel = selectedOutcomeId == o.id;
                    return InkWell(
                      onTap: () => setState(() => selectedOutcomeId = o.id),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppColor.actionBack.withValues(alpha: 0.15)
                              : AppColor.surfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSel
                                ? AppColor.actionBack
                                : AppColor.borderSubtle,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSel
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              size: 16,
                              color: isSel
                                  ? AppColor.actionBack
                                  : AppColor.textDim,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                o.title,
                                style: TextStyle(
                                  color: isSel
                                      ? AppColor.textPrimary
                                      : AppColor.textSecondary,
                                  fontWeight: isSel
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
                else
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () =>
                              setState(() => selectedWinningSide = 'BACK'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedWinningSide == 'BACK'
                                  ? AppColor.actionBack.withValues(alpha: 0.2)
                                  : AppColor.surfaceSubtle,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selectedWinningSide == 'BACK'
                                    ? AppColor.actionBack
                                    : AppColor.borderSubtle,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'BACK (Yes)',
                                style: TextStyle(
                                  color: AppColor.actionBack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () =>
                              setState(() => selectedWinningSide = 'OPPOSE'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedWinningSide == 'OPPOSE'
                                  ? AppColor.actionOppose.withValues(alpha: 0.2)
                                  : AppColor.surfaceSubtle,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selectedWinningSide == 'OPPOSE'
                                    ? AppColor.actionOppose
                                    : AppColor.borderSubtle,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'OPPOSE (No)',
                                style: TextStyle(
                                  color: AppColor.actionOppose,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel',
                    style: TextStyle(color: AppColor.textDim)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.statusSuccess,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  Get.back();
                  await controller.resolveBet(
                    bet.id,
                    winningSide: bet.betType == 'CUSTOM'
                        ? null
                        : selectedWinningSide,
                    winningOutcomeId: bet.betType == 'CUSTOM'
                        ? selectedOutcomeId
                        : null,
                  );
                },
                child: const Text('Confirm Resolution'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showKycVerificationDialog(BuildContext context) {
    controller.fetchKycStatus();
    final docNumberController = TextEditingController(text: 'P12345678');
    final docUrlController = TextEditingController(
      text: 'https://storage.betsocial.app/kyc/doc_sample.jpg',
    );
    final fullNameController =
        TextEditingController(text: controller.user.value?.name ?? 'Alex Mercer');
    String selectedDocType = 'PASSPORT';

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          final kyc = controller.kycStatus.value;
          final isVerified = kyc?.isVerified == true;
          final isPending = kyc?.isPending == true;

          return AlertDialog(
            backgroundColor: AppColor.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(
                  isVerified ? Icons.verified : Icons.shield_outlined,
                  color: isVerified
                      ? AppColor.statusSuccess
                      : (isPending
                          ? AppColor.statusPending
                          : AppColor.actionBack),
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  isVerified
                      ? 'Identity Verified'
                      : (isPending
                          ? 'Verification In Review'
                          : 'Identity KYC Verification'),
                  style: const TextStyle(
                    color: AppColor.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isVerified
                              ? AppColor.statusSuccess
                              : (isPending
                                  ? AppColor.statusPending
                                  : AppColor.actionBack))
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isVerified ? Icons.check_circle : Icons.info_outline,
                          size: 16,
                          color: isVerified
                              ? AppColor.statusSuccess
                              : (isPending
                                  ? AppColor.statusPending
                                  : AppColor.actionBack),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isVerified
                                ? 'Your profile is fully verified for high-stakes bets and instant withdrawals.'
                                : (isPending
                                    ? 'Your documents have been submitted and are being reviewed.'
                                    : 'Upload a government photo ID to enable higher withdrawal limits and verified bettor status.'),
                            style: const TextStyle(
                              color: AppColor.textPrimary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isVerified) ...[
                    const SizedBox(height: 14),
                    const Text(
                      'Document Type:',
                      style: TextStyle(color: AppColor.textDim, fontSize: 11),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColor.surfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.borderSubtle),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedDocType,
                          isExpanded: true,
                          dropdownColor: AppColor.surface,
                          items: const [
                            DropdownMenuItem(
                              value: 'PASSPORT',
                              child: Text('International Passport',
                                  style: TextStyle(
                                      color: AppColor.textPrimary,
                                      fontSize: 12)),
                            ),
                            DropdownMenuItem(
                              value: 'DRIVERS_LICENSE',
                              child: Text('Driver\'s License',
                                  style: TextStyle(
                                      color: AppColor.textPrimary,
                                      fontSize: 12)),
                            ),
                            DropdownMenuItem(
                              value: 'NATIONAL_ID',
                              child: Text('National ID Card',
                                  style: TextStyle(
                                      color: AppColor.textPrimary,
                                      fontSize: 12)),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => selectedDocType = v);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: fullNameController,
                      style: const TextStyle(
                          color: AppColor.textPrimary, fontSize: 12),
                      decoration: InputDecoration(
                        labelText: 'Legal Full Name',
                        labelStyle:
                            const TextStyle(color: AppColor.textSecondary),
                        filled: true,
                        fillColor: AppColor.surfaceSubtle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: docNumberController,
                      style: const TextStyle(
                          color: AppColor.textPrimary, fontSize: 12),
                      decoration: InputDecoration(
                        labelText: 'Document / ID Number',
                        labelStyle:
                            const TextStyle(color: AppColor.textSecondary),
                        filled: true,
                        fillColor: AppColor.surfaceSubtle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: docUrlController,
                      style: const TextStyle(
                          color: AppColor.textPrimary, fontSize: 12),
                      decoration: InputDecoration(
                        labelText: 'Document Upload URL',
                        labelStyle:
                            const TextStyle(color: AppColor.textSecondary),
                        filled: true,
                        fillColor: AppColor.surfaceSubtle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Close',
                    style: TextStyle(color: AppColor.textDim)),
              ),
              if (!isVerified)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.actionBack,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Get.back();
                    await controller.submitKyc(
                      documentType: selectedDocType,
                      documentNumber: docNumberController.text,
                      documentUrl: docUrlController.text,
                      fullName: fullNameController.text,
                    );
                  },
                  child: const Text('Submit for Review'),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showDisputeDialog(BuildContext context, BetModel bet) {
    String selectedReason = 'INCORRECT_RESULT';
    final descController = TextEditingController(
      text: 'Official event results contradict the declared outcome.',
    );
    final evidenceController = TextEditingController(
      text: 'https://storage.betsocial.app/evidence/match_report.pdf',
    );

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColor.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.gavel, color: AppColor.actionOppose, size: 22),
                SizedBox(width: 8),
                Text(
                  'File Bet Dispute',
                  style: TextStyle(
                    color: AppColor.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bet.title,
                    style: const TextStyle(
                      color: AppColor.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Dispute Reason:',
                    style: TextStyle(color: AppColor.textDim, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColor.surfaceSubtle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.borderSubtle),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedReason,
                        isExpanded: true,
                        dropdownColor: AppColor.surface,
                        items: const [
                          DropdownMenuItem(
                            value: 'INCORRECT_RESULT',
                            child: Text('Incorrect Outcome Declared',
                                style: TextStyle(
                                    color: AppColor.textPrimary, fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value: 'EVENT_CANCELLED',
                            child: Text('Event Postponed or Cancelled',
                                style: TextStyle(
                                    color: AppColor.textPrimary, fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value: 'COLLUSION',
                            child: Text('Fraud or Collusion Suspected',
                                style: TextStyle(
                                    color: AppColor.textPrimary, fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value: 'SCORE_MISMATCH',
                            child: Text('Gaming / Score Mismatch',
                                style: TextStyle(
                                    color: AppColor.textPrimary, fontSize: 12)),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => selectedReason = v);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    style: const TextStyle(
                        color: AppColor.textPrimary, fontSize: 12),
                    decoration: InputDecoration(
                      labelText: 'Explanation & Details',
                      labelStyle:
                          const TextStyle(color: AppColor.textSecondary),
                      filled: true,
                      fillColor: AppColor.surfaceSubtle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: evidenceController,
                    style: const TextStyle(
                        color: AppColor.textPrimary, fontSize: 12),
                    decoration: InputDecoration(
                      labelText: 'Proof Document URL / Link',
                      labelStyle:
                          const TextStyle(color: AppColor.textSecondary),
                      filled: true,
                      fillColor: AppColor.surfaceSubtle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel',
                    style: TextStyle(color: AppColor.textDim)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.actionOppose,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  Get.back();
                  await controller.createBetDispute(
                    betId: bet.id,
                    reason: selectedReason,
                    description: descController.text,
                    evidenceUrl: evidenceController.text,
                  );
                },
                child: const Text('Escalate Dispute'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDisputesSheet(BuildContext context) {
    controller.fetchDisputes();

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.gavel, color: AppColor.actionOppose, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Disputes & Arbitration Ledger',
                    style: TextStyle(
                      color: AppColor.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColor.textDim),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isDisputesLoading.value &&
                    controller.disputes.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColor.actionBack),
                  );
                }
                if (controller.disputes.isEmpty) {
                  return const Center(
                    child: Text(
                      'No open or recorded disputes found.',
                      style: TextStyle(color: AppColor.textDim),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.disputes.length,
                  itemBuilder: (context, index) {
                    final d = controller.disputes[index];
                    final isOpen = d.isOpen;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.surfaceSubtle,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isOpen
                              ? AppColor.actionOppose.withValues(alpha: 0.3)
                              : AppColor.borderSubtle,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (isOpen
                                          ? AppColor.actionOppose
                                          : AppColor.statusSuccess)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  d.status,
                                  style: TextStyle(
                                    color: isOpen
                                        ? AppColor.actionOppose
                                        : AppColor.statusSuccess,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  d.reason,
                                  style: const TextStyle(
                                    color: AppColor.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            d.description,
                            style: const TextStyle(
                              color: AppColor.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                          if (d.evidenceUrl != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Evidence: ${d.evidenceUrl}',
                              style: const TextStyle(
                                color: AppColor.actionBack,
                                fontSize: 10,
                              ),
                            ),
                          ],
                          if (isOpen) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: const Icon(Icons.check_circle_outline,
                                    size: 14),
                                label: const Text('Resolve Dispute',
                                    style: TextStyle(fontSize: 11)),
                                onPressed: () {
                                  Get.back();
                                  controller.resolveBetDispute(
                                    disputeId: d.id,
                                    resolution: 'OVERTURN_RESULT',
                                    resolutionNotes: 'Evidence verified by referee',
                                    newWinningSide: 'BACK',
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showGamingScoreDialog(BuildContext context, BetModel bet) {
    controller.fetchGamingMatchCheck(bet.id);
    String selectedPlatform = 'PLAYSTATION';
    final gamertagController = TextEditingController(text: 'Player_1');
    final myScoreController = TextEditingController(text: '3');
    final opponentScoreController = TextEditingController(text: '1');
    final proofController = TextEditingController(
      text: 'https://storage.betsocial.app/gaming/ps5_match.png',
    );

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColor.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.sports_esports, color: Color(0xFF818CF8), size: 22),
                SizedBox(width: 8),
                Text(
                  'PlayStation / Gaming Result',
                  style: TextStyle(
                    color: AppColor.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bet.title,
                    style: const TextStyle(
                      color: AppColor.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Existing submissions check / status banner
                  Obx(() {
                    final match = controller.gamingMatch.value;
                    if (match == null || match.submissions.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final isMatched = match.isMatched;
                    final isMismatch = match.isMismatch;
                    final statusColor = isMatched
                        ? AppColor.statusSuccess
                        : (isMismatch ? AppColor.statusFailed : AppColor.statusPending);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isMatched
                                    ? Icons.check_circle
                                    : (isMismatch
                                        ? Icons.error_outline
                                        : Icons.hourglass_top),
                                color: statusColor,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Match Status: ${match.matchStatus}',
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ...match.submissions.map((s) => Text(
                                '• ${s.playerName ?? s.gamertag ?? s.playerId}: ${s.myScore} - ${s.opponentScore} (${s.platform})',
                                style: const TextStyle(
                                  color: AppColor.textSecondary,
                                  fontSize: 11,
                                ),
                              )),
                        ],
                      ),
                    );
                  }),

                  const Text(
                    'Gaming Platform:',
                    style: TextStyle(color: AppColor.textDim, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColor.surfaceSubtle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.borderSubtle),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPlatform,
                        isExpanded: true,
                        dropdownColor: AppColor.surface,
                        items: const [
                          DropdownMenuItem(
                            value: 'PLAYSTATION',
                            child: Text('PlayStation (PS5 / PS4)',
                                style: TextStyle(
                                    color: AppColor.textPrimary, fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value: 'XBOX',
                            child: Text('Xbox Series X|S / One',
                                style: TextStyle(
                                    color: AppColor.textPrimary, fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value: 'PC',
                            child: Text('PC / Steam',
                                style: TextStyle(
                                    color: AppColor.textPrimary, fontSize: 12)),
                          ),
                          DropdownMenuItem(
                            value: 'NINTENDO',
                            child: Text('Nintendo Switch',
                                style: TextStyle(
                                    color: AppColor.textPrimary, fontSize: 12)),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => selectedPlatform = v);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: gamertagController,
                    style: const TextStyle(
                        color: AppColor.textPrimary, fontSize: 12),
                    decoration: InputDecoration(
                      labelText: 'Gamertag / PSN ID',
                      labelStyle:
                          const TextStyle(color: AppColor.textSecondary),
                      filled: true,
                      fillColor: AppColor.surfaceSubtle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: myScoreController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: AppColor.textPrimary, fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'My Score',
                            labelStyle:
                                const TextStyle(color: AppColor.textSecondary),
                            filled: true,
                            fillColor: AppColor.surfaceSubtle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: opponentScoreController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: AppColor.textPrimary, fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Opponent Score',
                            labelStyle:
                                const TextStyle(color: AppColor.textSecondary),
                            filled: true,
                            fillColor: AppColor.surfaceSubtle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: proofController,
                    style: const TextStyle(
                        color: AppColor.textPrimary, fontSize: 12),
                    decoration: InputDecoration(
                      labelText: 'Screenshot / Match Proof URL',
                      labelStyle:
                          const TextStyle(color: AppColor.textSecondary),
                      filled: true,
                      fillColor: AppColor.surfaceSubtle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel',
                    style: TextStyle(color: AppColor.textDim)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final myScore = int.tryParse(myScoreController.text) ?? 0;
                  final oppScore =
                      int.tryParse(opponentScoreController.text) ?? 0;
                  Get.back();
                  await controller.submitGamingScore(
                    betId: bet.id,
                    myScore: myScore,
                    opponentScore: oppScore,
                    platform: selectedPlatform,
                    gamertag: gamertagController.text,
                    proofUrl: proofController.text,
                  );
                },
                child: const Text('Submit Score Check'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAiResearchSheet(BuildContext context, BetModel bet) {
    controller.researchBet(betId: bet.id);
    final chatInputController = TextEditingController();

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.actionBack.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColor.actionBack,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'AI Research Assistant',
                            style: TextStyle(
                              color: AppColor.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6),
                          Chip(
                            label: Text(
                              'BETA',
                              style: TextStyle(
                                color: AppColor.actionBack,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Color(0x1F0EA5E9),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                      Text(
                        bet.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Scrollable Content
            Expanded(
              child: Obx(() {
                if (controller.isAiLoading.value &&
                    controller.aiResearch.value == null) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColor.actionBack),
                        SizedBox(height: 12),
                        Text(
                          'Analyzing historical form & orderbook liquidity...',
                          style: TextStyle(
                            color: AppColor.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final research = controller.aiResearch.value;
                if (research == null) {
                  return const Center(
                    child: Text(
                      'AI analysis unavailable. Tap to retry.',
                      style: TextStyle(color: AppColor.textDim),
                    ),
                  );
                }

                final isBack = research.suggestedStance == 'BACK';
                final isOppose = research.suggestedStance == 'OPPOSE';
                final stanceColor = isBack
                    ? AppColor.actionBack
                    : (isOppose ? AppColor.actionOppose : AppColor.statusPending);

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Strategic Stance Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.surfaceSubtle,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: stanceColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color:
                                            stanceColor.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Suggested: ${research.suggestedStance}',
                                        style: TextStyle(
                                          color: stanceColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${(research.confidenceScore * 100).toInt()}% Confidence',
                                      style: const TextStyle(
                                        color: AppColor.textDim,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: research.riskLevel == 'LOW'
                                        ? AppColor.statusSuccess
                                            .withValues(alpha: 0.15)
                                        : (research.riskLevel == 'MODERATE'
                                            ? AppColor.statusPending
                                                .withValues(alpha: 0.15)
                                            : AppColor.statusFailed
                                                .withValues(alpha: 0.15)),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${research.riskLevel} RISK',
                                    style: TextStyle(
                                      color: research.riskLevel == 'LOW'
                                          ? AppColor.statusSuccess
                                          : (research.riskLevel == 'MODERATE'
                                              ? AppColor.statusPending
                                              : AppColor.statusFailed),
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              research.summary,
                              style: const TextStyle(
                                color: AppColor.textPrimary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Market Sentiment Bar
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.surfaceSubtle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Back (${research.marketSentiment.backPercentage}%)',
                                  style: const TextStyle(
                                    color: AppColor.actionBack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  'Oppose (${research.marketSentiment.opposePercentage}%)',
                                  style: const TextStyle(
                                    color: AppColor.actionOppose,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: research.marketSentiment.backPercentage /
                                    100.0,
                                backgroundColor: AppColor.actionOppose,
                                color: AppColor.actionBack,
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Key Statistical Factors
                      const Text(
                        'Key Intelligence & Drivers',
                        style: TextStyle(
                          color: AppColor.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...research.keyFactors.map((kf) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(
                                      color: AppColor.actionBack,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    kf,
                                    style: const TextStyle(
                                      color: AppColor.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 12),

                      // Citations
                      if (research.sources.isNotEmpty) ...[
                        const Text(
                          'Authoritative Sources',
                          style: TextStyle(
                            color: AppColor.textDim,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: research.sources
                              .map((src) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColor.surface,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: AppColor.borderSubtle),
                                    ),
                                    child: Text(
                                      src,
                                      style: const TextStyle(
                                        color: AppColor.textDim,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Chat History
                      if (controller.aiChatMessages.isNotEmpty) ...[
                        const Text(
                          'Conversational Analysis',
                          style: TextStyle(
                            color: AppColor.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...controller.aiChatMessages.map((msg) {
                          final isUser = msg['role'] == 'user';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? AppColor.actionBack
                                      .withValues(alpha: 0.12)
                                  : AppColor.surfaceSubtle,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isUser
                                    ? AppColor.actionBack
                                        .withValues(alpha: 0.3)
                                    : AppColor.borderSubtle,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isUser ? 'You' : 'BetSocial AI',
                                  style: TextStyle(
                                    color: isUser
                                        ? AppColor.actionBack
                                        : AppColor.statusSuccess,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  msg['content'] ?? '',
                                  style: const TextStyle(
                                    color: AppColor.textPrimary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),

            // Interactive Chat Query Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatInputController,
                    style: const TextStyle(
                      color: AppColor.textPrimary,
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask AI anything about this bet...',
                      hintStyle:
                          const TextStyle(color: AppColor.textDim, fontSize: 12),
                      filled: true,
                      fillColor: AppColor.surfaceSubtle,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColor.borderSubtle),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded,
                      color: AppColor.actionBack, size: 20),
                  onPressed: () {
                    final q = chatInputController.text.trim();
                    if (q.isNotEmpty) {
                      chatInputController.clear();
                      controller.sendAiChatMessage(query: q, betId: bet.id);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showAdminPanelSheet(BuildContext context) {
    controller.fetchAdminOverview();
    controller.fetchAdminUsers();
    controller.fetchAdminWithdrawals();

    Get.bottomSheet(
      DefaultTabController(
        length: 3,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: const BoxDecoration(
            color: AppColor.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings,
                        color: AppColor.actionBack, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Admin Control Panel',
                      style: TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const TabBar(
                indicatorColor: AppColor.actionBack,
                labelColor: AppColor.actionBack,
                unselectedLabelColor: AppColor.textSecondary,
                labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Users'),
                  Tab(text: 'Withdrawals'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: Overview
                    Obx(() {
                      final ov = controller.adminOverview.value;
                      if (controller.isAdminLoading.value && ov == null) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppColor.actionBack),
                        );
                      }
                      if (ov == null) {
                        return const Center(
                          child: Text('Failed to load admin metrics',
                              style: TextStyle(color: AppColor.textDim)),
                        );
                      }
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricTile(
                                    'Total Bettors',
                                    '${ov.totalUsers}',
                                    Icons.people_outline,
                                    AppColor.actionBack,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildMetricTile(
                                    'Active Bets',
                                    '${ov.activeBets}',
                                    Icons.sports_esports_outlined,
                                    const Color(0xFF818CF8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricTile(
                                    'Escrow Locked',
                                    '\$${ov.totalEscrowLocked.toStringAsFixed(2)}',
                                    Icons.lock_outline,
                                    AppColor.statusPending,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildMetricTile(
                                    'Traded Volume',
                                    '\$${ov.totalVolumeTraded.toStringAsFixed(2)}',
                                    Icons.trending_up,
                                    AppColor.statusSuccess,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricTile(
                                    'Commissions',
                                    '\$${ov.totalCommissionsEarned.toStringAsFixed(2)}',
                                    Icons.account_balance_outlined,
                                    AppColor.statusSuccess,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildMetricTile(
                                    'Open Disputes',
                                    '${ov.openDisputesCount}',
                                    Icons.gavel_outlined,
                                    AppColor.actionOppose,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricTile(
                                    'Pending Payouts',
                                    '${ov.pendingWithdrawalsCount}',
                                    Icons.hourglass_top,
                                    AppColor.statusPending,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildMetricTile(
                                    'Pending KYC',
                                    '${ov.unverifiedKycCount}',
                                    Icons.shield_outlined,
                                    AppColor.actionBack,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                    // Tab 2: Users
                    Obx(() {
                      final users = controller.adminUsers;
                      if (controller.isAdminLoading.value && users.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppColor.actionBack),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: users.length,
                        itemBuilder: (context, i) {
                          final u = users[i];
                          final isSuspended = u.isSuspended;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.surfaceSubtle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSuspended
                                    ? AppColor.statusFailed.withValues(alpha: 0.3)
                                    : AppColor.borderSubtle,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColor.surface,
                                  child: Text(
                                    u.name.isNotEmpty ? u.name[0].toUpperCase() : 'U',
                                    style: const TextStyle(
                                      color: AppColor.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        u.name,
                                        style: const TextStyle(
                                          color: AppColor.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${u.email ?? u.username ?? ''} • Bal: \$${u.walletBalance.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: AppColor.textDim,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: isSuspended
                                        ? AppColor.statusSuccess
                                        : AppColor.statusFailed,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                  onPressed: () {
                                    controller.updateUserStatus(
                                      u.id,
                                      isSuspended ? 'ACTIVE' : 'SUSPENDED',
                                      reason: 'Administrative action',
                                    );
                                  },
                                  child: Text(
                                    isSuspended ? 'Reactivate' : 'Suspend',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),

                    // Tab 3: Withdrawals
                    Obx(() {
                      final withdrawals = controller.adminWithdrawals;
                      if (controller.isAdminLoading.value && withdrawals.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppColor.actionBack),
                        );
                      }
                      if (withdrawals.isEmpty) {
                        return const Center(
                          child: Text(
                            'No pending withdrawal requests',
                            style: TextStyle(color: AppColor.textDim, fontSize: 12),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: withdrawals.length,
                        itemBuilder: (context, i) {
                          final w = withdrawals[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.surfaceSubtle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColor.borderSubtle),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      w.userName,
                                      style: const TextStyle(
                                        color: AppColor.textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      '\$${w.amount.toStringAsFixed(2)} ${w.currency}',
                                      style: const TextStyle(
                                        color: AppColor.statusPending,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Via ${w.paymentMethod} • ${w.destination}',
                                  style: const TextStyle(
                                    color: AppColor.textDim,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColor.statusFailed,
                                      ),
                                      onPressed: () {
                                        controller.reviewWithdrawal(
                                          w.id,
                                          'REJECTED',
                                          notes: 'Rejected by admin review',
                                        );
                                      },
                                      child: const Text('Reject & Refund',
                                          style: TextStyle(fontSize: 11)),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.statusSuccess,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                      ),
                                      onPressed: () {
                                        controller.reviewWithdrawal(
                                          w.id,
                                          'APPROVED',
                                          notes: 'Wire confirmed',
                                        );
                                      },
                                      child: const Text('Approve Payout',
                                          style: TextStyle(fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.surfaceSubtle,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: AppColor.textDim, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void _showWalletSheet(BuildContext context) {
    controller.fetchWallet();
    controller.fetchTransactions();

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.statusSuccess.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.account_balance_wallet,
                            color: AppColor.statusSuccess, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Wallet & Ledger',
                            style: TextStyle(
                              color: AppColor.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Real-time balance & transaction ledger',
                            style: TextStyle(
                              color: AppColor.textDim,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      controller.fetchWallet();
                      controller.fetchTransactions();
                    },
                    icon: const Icon(Icons.refresh,
                        color: AppColor.textSecondary, size: 20),
                    tooltip: 'Refresh Ledger',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Balance Card
              Obx(() {
                final wallet = controller.wallet.value;
                final bal = wallet?.balance ??
                    controller.user.value?.balance ??
                    '0.00';
                final locked = wallet?.escrowLocked ?? '0.00';
                final deposited = wallet?.totalDeposited ?? '0.00';
                final withdrawn = wallet?.totalWithdrawn ?? '0.00';

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.surfaceSubtle,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColor.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Balance',
                        style: TextStyle(color: AppColor.textDim, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$$bal',
                        style: const TextStyle(
                          color: AppColor.statusSuccess,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(color: AppColor.borderSubtle, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('In Escrow Bets',
                                  style: TextStyle(
                                      color: AppColor.textDim, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text('\$$locked',
                                  style: const TextStyle(
                                      color: AppColor.statusPending,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Deposited',
                                  style: TextStyle(
                                      color: AppColor.textDim, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text('\$$deposited',
                                  style: const TextStyle(
                                      color: AppColor.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Withdrawn',
                                  style: TextStyle(
                                      color: AppColor.textDim, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text('\$$withdrawn',
                                  style: const TextStyle(
                                      color: AppColor.textSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 14),
              // Deposit & Withdraw Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.actionBack,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _showDepositDialog(context),
                      icon: const Icon(Icons.add_circle_outline, size: 16),
                      label: const Text('Deposit Funds',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.textPrimary,
                        side: const BorderSide(color: AppColor.borderSubtle),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _showWithdrawDialog(context),
                      icon: const Icon(Icons.arrow_circle_up, size: 16),
                      label: const Text('Withdraw',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Transaction Ledger
              const Text(
                'Transaction Ledger',
                style: TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.isTransactionsLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child:
                          CircularProgressIndicator(color: AppColor.actionBack),
                    ),
                  );
                }

                if (controller.transactions.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.surfaceSubtle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'No transactions recorded yet',
                        style: TextStyle(color: AppColor.textDim, fontSize: 12),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.transactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final tx = controller.transactions[index];
                    final isCredit = tx.type == 'DEPOSIT' ||
                        tx.type == 'PAYOUT' ||
                        tx.type == 'REFUND';
                    Color color = isCredit
                        ? AppColor.statusSuccess
                        : (tx.type == 'WITHDRAWAL'
                            ? AppColor.statusPending
                            : AppColor.actionOppose);
                    IconData icon = tx.type == 'DEPOSIT'
                        ? Icons.arrow_downward
                        : (tx.type == 'PAYOUT'
                            ? Icons.emoji_events
                            : (tx.type == 'REFUND'
                                ? Icons.replay
                                : (tx.type == 'WITHDRAWAL'
                                    ? Icons.arrow_upward
                                    : Icons.sports_esports)));

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.surfaceSubtle,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColor.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, color: color, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColor.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColor.surface,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        tx.type,
                                        style: TextStyle(
                                            color: color,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      tx.status,
                                      style: TextStyle(
                                        color: tx.status == 'COMPLETED'
                                            ? AppColor.statusSuccess
                                            : AppColor.statusPending,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            isCredit ? '+\$${tx.amount}' : '-\$${tx.amount}',
                            style: TextStyle(
                              color: color,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showDepositDialog(BuildContext context) {
    final amountController = TextEditingController(text: '100');
    String selectedMethod = 'CARD';

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColor.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.add_circle, color: AppColor.actionBack, size: 22),
                SizedBox(width: 8),
                Text(
                  'Deposit Funds',
                  style: TextStyle(
                    color: AppColor.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Select Amount:',
                  style: TextStyle(color: AppColor.textDim, fontSize: 11),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [25, 50, 100, 250].map((amt) {
                    final isSel = amountController.text == amt.toString();
                    return Expanded(
                      child: InkWell(
                        onTap: () => setState(
                            () => amountController.text = amt.toString()),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColor.actionBack.withValues(alpha: 0.2)
                                : AppColor.surfaceSubtle,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSel
                                  ? AppColor.actionBack
                                  : AppColor.borderSubtle,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '\$$amt',
                              style: TextStyle(
                                color: isSel
                                    ? AppColor.actionBack
                                    : AppColor.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(
                      color: AppColor.textPrimary, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.attach_money,
                        color: AppColor.actionBack),
                    labelText: 'Deposit Amount (USD)',
                    labelStyle: const TextStyle(color: AppColor.textSecondary),
                    filled: true,
                    fillColor: AppColor.surfaceSubtle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColor.borderSubtle),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Payment Method:',
                  style: TextStyle(color: AppColor.textDim, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColor.surfaceSubtle,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.borderSubtle),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedMethod,
                      isExpanded: true,
                      dropdownColor: AppColor.surface,
                      items: const [
                        DropdownMenuItem(
                          value: 'CARD',
                          child: Text('Credit / Debit Card (Instant)',
                              style: TextStyle(
                                  color: AppColor.textPrimary, fontSize: 12)),
                        ),
                        DropdownMenuItem(
                          value: 'BANK_TRANSFER',
                          child: Text('Bank Wire (ACH / SEPA)',
                              style: TextStyle(
                                  color: AppColor.textPrimary, fontSize: 12)),
                        ),
                        DropdownMenuItem(
                          value: 'CRYPTO',
                          child: Text('USDC / USDT (Instant)',
                              style: TextStyle(
                                  color: AppColor.textPrimary, fontSize: 12)),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => selectedMethod = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel',
                    style: TextStyle(color: AppColor.textDim)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.actionBack,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final amt = double.tryParse(amountController.text) ?? 0.0;
                  if (amt <= 0) return;
                  Get.back();

                  if (selectedMethod == 'BANK_TRANSFER') {
                    _showBankWireDialog(context, amt);
                  } else if (selectedMethod == 'CRYPTO') {
                    _showCryptoDepositDialog(context, amt);
                  } else {
                    // Card Deposit via Stripe Intent & Confirmation
                    final intent = await controller.createStripeIntent(amt);
                    if (intent != null) {
                      await controller.confirmStripePayment(intent.paymentIntentId);
                    }
                  }
                },
                child: const Text('Continue Deposit'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showBankWireDialog(BuildContext context, double amount) {
    final senderBankController = TextEditingController(text: 'Chase Bank');
    final refController = TextEditingController(
      text:
          'BS-DEPOSIT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
    );
    final notesController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.account_balance, color: AppColor.actionBack, size: 22),
            SizedBox(width: 8),
            Text(
              'Bank Wire Instructions',
              style: TextStyle(
                color: AppColor.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.surfaceSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.borderSubtle),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Beneficiary: BetSocial Global Ltd',
                      style: TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Bank: JPMorgan Chase Bank, N.A.',
                      style: TextStyle(color: AppColor.textDim, fontSize: 11),
                    ),
                    Text(
                      'SWIFT/BIC: CHASUS33XXX',
                      style: TextStyle(color: AppColor.textDim, fontSize: 11),
                    ),
                    Text(
                      'IBAN: GB82WEST12345698765432',
                      style: TextStyle(color: AppColor.textDim, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: refController,
                style: const TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'Wire Reference Code',
                  labelStyle: const TextStyle(color: AppColor.textSecondary),
                  filled: true,
                  fillColor: AppColor.surfaceSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: senderBankController,
                style: const TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  labelText: 'Your Bank Name',
                  labelStyle: const TextStyle(color: AppColor.textSecondary),
                  filled: true,
                  fillColor: AppColor.surfaceSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: notesController,
                style: const TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  labelText: 'Notes / Wire Memo (Optional)',
                  labelStyle: const TextStyle(color: AppColor.textSecondary),
                  filled: true,
                  fillColor: AppColor.surfaceSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColor.textDim)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.actionBack,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Get.back();
              await controller.submitWireProof(
                amount: amount,
                senderBank: senderBankController.text,
                referenceNumber: refController.text,
                notes: notesController.text,
              );
            },
            child: const Text('Submit Wire Proof'),
          ),
        ],
      ),
    );
  }

  void _showCryptoDepositDialog(BuildContext context, double amount) {
    String selectedCrypto = 'USDT';
    String selectedNetwork = 'POLYGON';
    final txHashController = TextEditingController(
      text: '0x${DateTime.now().millisecondsSinceEpoch}ab42',
    );

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          final addr =
              '0x71C${(controller.user.value?.id ?? "demo").padRight(8, "0").substring(0, 8)}e275d31b816280b2aB38';

          return AlertDialog(
            backgroundColor: AppColor.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.currency_bitcoin,
                    color: AppColor.actionBack, size: 22),
                SizedBox(width: 8),
                Text(
                  'Crypto Deposit (Instant)',
                  style: TextStyle(
                    color: AppColor.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: selectedCrypto,
                          dropdownColor: AppColor.surface,
                          items: const [
                            DropdownMenuItem(
                              value: 'USDT',
                              child: Text('USDT',
                                  style: TextStyle(
                                      color: AppColor.textPrimary,
                                      fontSize: 12)),
                            ),
                            DropdownMenuItem(
                              value: 'USDC',
                              child: Text('USDC',
                                  style: TextStyle(
                                      color: AppColor.textPrimary,
                                      fontSize: 12)),
                            ),
                            DropdownMenuItem(
                              value: 'BTC',
                              child: Text('BTC',
                                  style: TextStyle(
                                      color: AppColor.textPrimary,
                                      fontSize: 12)),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => selectedCrypto = v ?? 'USDT'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          value: selectedNetwork,
                          dropdownColor: AppColor.surface,
                          items: const [
                            DropdownMenuItem(
                              value: 'POLYGON',
                              child: Text('Polygon',
                                  style: TextStyle(
                                      color: AppColor.textPrimary,
                                      fontSize: 12)),
                            ),
                            DropdownMenuItem(
                              value: 'ETHEREUM',
                              child: Text('Ethereum',
                                  style: TextStyle(
                                      color: AppColor.textPrimary,
                                      fontSize: 12)),
                            ),
                            DropdownMenuItem(
                              value: 'TRON',
                              child: Text('Tron (TRC20)',
                                  style: TextStyle(
                                      color: AppColor.textPrimary,
                                      fontSize: 12)),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => selectedNetwork = v ?? 'POLYGON'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Send deposit to Address:',
                    style: TextStyle(color: AppColor.textDim, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.surfaceSubtle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.borderSubtle),
                    ),
                    child: SelectableText(
                      addr,
                      style: const TextStyle(
                        color: AppColor.actionBack,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: txHashController,
                    style: const TextStyle(
                      color: AppColor.textPrimary,
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Transaction Hash (tx_hash)',
                      labelStyle:
                          const TextStyle(color: AppColor.textSecondary),
                      filled: true,
                      fillColor: AppColor.surfaceSubtle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel',
                    style: TextStyle(color: AppColor.textDim)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.actionBack,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  Get.back();
                  await controller.verifyCryptoDeposit(
                    txHash: txHashController.text,
                    crypto: selectedCrypto,
                    network: selectedNetwork,
                    amount: amount,
                  );
                },
                child: const Text('Verify & Credit'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    final amountController = TextEditingController(text: '50');
    final destinationController =
        TextEditingController(text: 'IBAN GB82WEST12345698765432');
    String selectedMethod = 'BANK_TRANSFER';

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          final walletBal = controller.wallet.value?.balanceDouble ??
              double.tryParse(controller.user.value?.balance ?? '0') ??
              0.0;

          return AlertDialog(
            backgroundColor: AppColor.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.arrow_circle_up,
                    color: AppColor.statusPending, size: 22),
                SizedBox(width: 8),
                Text(
                  'Withdraw Funds',
                  style: TextStyle(
                    color: AppColor.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available: \$${walletBal.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: AppColor.statusSuccess,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(
                      color: AppColor.textPrimary, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.attach_money,
                        color: AppColor.statusPending),
                    labelText: 'Withdrawal Amount (USD)',
                    labelStyle: const TextStyle(color: AppColor.textSecondary),
                    filled: true,
                    fillColor: AppColor.surfaceSubtle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColor.borderSubtle),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: destinationController,
                  style: const TextStyle(
                      color: AppColor.textPrimary, fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Destination Details (Account / IBAN)',
                    labelStyle: const TextStyle(color: AppColor.textSecondary),
                    filled: true,
                    fillColor: AppColor.surfaceSubtle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColor.borderSubtle),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel',
                    style: TextStyle(color: AppColor.textDim)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.statusPending,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final amt = double.tryParse(amountController.text) ?? 0.0;
                  if (amt <= 0) return;
                  Get.back();
                  await controller.withdrawWallet(
                    amt,
                    payoutMethod: selectedMethod,
                    destinationDetails: destinationController.text,
                  );
                },
                child: const Text('Confirm Withdrawal'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showStakeDialog(
    BuildContext context,
    BetModel bet, {
    String? side,
    BetOutcomeModel? outcome,
  }) {
    final stakeController = TextEditingController(text: '25');
    String currentSide = side ?? 'BACK';
    String? currentOutcomeId =
        outcome?.id ?? (bet.outcomes.isNotEmpty ? bet.outcomes.first.id : null);

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          final isCustom = bet.betType == 'CUSTOM' && bet.outcomes.isNotEmpty;
          final currentStake = double.tryParse(stakeController.text) ?? 0.0;

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Place Stake on Prediction',
                    style: const TextStyle(
                      color: AppColor.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bet.title,
                    style: const TextStyle(
                      color: AppColor.textSecondary,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Side or Outcome Selector
                  if (isCustom) ...[
                    const Text(
                      'Choose Outcome Candidate:',
                      style: TextStyle(
                        color: AppColor.textDim,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColor.surfaceSubtle,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColor.borderSubtle),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: AppColor.surface,
                          value: currentOutcomeId,
                          style: const TextStyle(
                            color: AppColor.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          items: bet.outcomes.map((o) {
                            return DropdownMenuItem<String>(
                              value: o.id,
                              child: Text(
                                '${o.title} (${o.percent.toStringAsFixed(0)}% · \$${o.pool})',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() => currentOutcomeId = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                setModalState(() => currentSide = 'BACK'),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: currentSide == 'BACK'
                                    ? AppColor.actionBack.withValues(alpha: 0.2)
                                    : AppColor.surfaceSubtle,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: currentSide == 'BACK'
                                      ? AppColor.actionBack
                                      : AppColor.borderSubtle,
                                  width: currentSide == 'BACK' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Back (Yes)',
                                    style: TextStyle(
                                      color: currentSide == 'BACK'
                                          ? AppColor.actionBack
                                          : AppColor.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${bet.backPercent.toStringAsFixed(0)}% · \$${bet.backPool}',
                                    style: const TextStyle(
                                      color: AppColor.textDim,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                setModalState(() => currentSide = 'OPPOSE'),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: currentSide == 'OPPOSE'
                                    ? AppColor.actionOppose
                                        .withValues(alpha: 0.2)
                                    : AppColor.surfaceSubtle,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: currentSide == 'OPPOSE'
                                      ? AppColor.actionOppose
                                      : AppColor.borderSubtle,
                                  width: currentSide == 'OPPOSE' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Oppose (No)',
                                    style: TextStyle(
                                      color: currentSide == 'OPPOSE'
                                          ? AppColor.actionOppose
                                          : AppColor.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${bet.opposePercent.toStringAsFixed(0)}% · \$${bet.opposePool}',
                                    style: const TextStyle(
                                      color: AppColor.textDim,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Stake Amount Input
                  TextField(
                    controller: stakeController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: AppColor.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      prefixStyle: const TextStyle(
                        color: AppColor.actionBack,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      labelText: 'Stake Amount',
                      labelStyle: const TextStyle(color: AppColor.textDim),
                      filled: true,
                      fillColor: AppColor.surfaceSubtle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColor.borderSubtle),
                      ),
                    ),
                    onChanged: (_) => setModalState(() {}),
                  ),

                  const SizedBox(height: 10),

                  // Quick Stake Chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [10, 25, 50, 100, 250].map((amt) {
                      return InkWell(
                        onTap: () {
                          stakeController.text = amt.toString();
                          setModalState(() {});
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColor.surfaceSubtle,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColor.borderSubtle),
                          ),
                          child: Text(
                            '\$$amt',
                            style: const TextStyle(
                              color: AppColor.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCustom || currentSide == 'BACK'
                          ? AppColor.actionBack
                          : AppColor.actionOppose,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: currentStake <= 0
                        ? null
                        : () async {
                            Get.back();
                            if (isCustom) {
                              await controller.placeStake(
                                bet.id,
                                outcomeId: currentOutcomeId,
                                stake: currentStake,
                              );
                            } else {
                              await controller.placeStake(
                                bet.id,
                                side: currentSide,
                                stake: currentStake,
                              );
                            }
                          },
                    child: Text(
                      'Confirm \$${currentStake.toStringAsFixed(0)} Stake',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showCreateBetModal(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final stakeController = TextEditingController(text: '50');
    final outcomeControllers = [
      TextEditingController(text: 'Option A'),
      TextEditingController(text: 'Option B'),
    ];
    String selectedBetType = 'BINARY'; // 'BINARY' or 'CUSTOM'
    String selectedCat = 'SPORTS';
    String selectedSide = 'BACK';
    int selectedInitialOutcomeIdx = 0;
    bool isPrivate = false;
    DateTime selectedDeadline = DateTime.now().add(const Duration(days: 2));

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          final isCustom = selectedBetType == 'CUSTOM';

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isPrivate ? 'Create Private Bet' : 'Create Public Prediction',
                    style: const TextStyle(
                      color: AppColor.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Bet Type Segmented Selector
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(
                            child: Text(
                              'YES / NO (Binary)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          selected: !isCustom,
                          selectedColor: AppColor.actionBack,
                          backgroundColor: AppColor.surfaceSubtle,
                          labelStyle: TextStyle(
                            color: !isCustom ? Colors.white : AppColor.textDim,
                            fontSize: 12,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setModalState(() => selectedBetType = 'BINARY');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(
                            child: Text(
                              'Multi-Outcome',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          selected: isCustom,
                          selectedColor: AppColor.actionBack,
                          backgroundColor: AppColor.surfaceSubtle,
                          labelStyle: TextStyle(
                            color: isCustom ? Colors.white : AppColor.textDim,
                            fontSize: 12,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setModalState(() => selectedBetType = 'CUSTOM');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: AppColor.textPrimary),
                    decoration: InputDecoration(
                      hintText: isCustom
                          ? 'e.g. Who will win the 2026 World Cup?'
                          : 'Prediction statement (e.g. Lakers to win tonight)',
                      hintStyle: const TextStyle(color: AppColor.textDim),
                      filled: true,
                      fillColor: AppColor.surfaceSubtle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColor.borderSubtle),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  TextField(
                    controller: descController,
                    maxLines: 2,
                    style: const TextStyle(color: AppColor.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Optional rules or resolution conditions...',
                      hintStyle: const TextStyle(color: AppColor.textDim),
                      filled: true,
                      fillColor: AppColor.surfaceSubtle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColor.borderSubtle),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Custom Outcomes Options Builder
                  if (isCustom) ...[
                    const Text(
                      'Candidates / Outcomes Options:',
                      style: TextStyle(
                        color: AppColor.textDim,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...List.generate(outcomeControllers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: outcomeControllers[index],
                                style: const TextStyle(
                                    color: AppColor.textPrimary),
                                decoration: InputDecoration(
                                  hintText: 'Option ${index + 1}',
                                  hintStyle:
                                      const TextStyle(color: AppColor.textDim),
                                  filled: true,
                                  fillColor: AppColor.surfaceSubtle,
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: AppColor.borderSubtle),
                                  ),
                                ),
                              ),
                            ),
                            if (outcomeControllers.length > 2) ...[
                              const SizedBox(width: 6),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: AppColor.actionOppose, size: 20),
                                onPressed: () {
                                  setModalState(() {
                                    outcomeControllers.removeAt(index);
                                    if (selectedInitialOutcomeIdx >=
                                        outcomeControllers.length) {
                                      selectedInitialOutcomeIdx = 0;
                                    }
                                  });
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                    if (outcomeControllers.length < 8)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () {
                            setModalState(() {
                              outcomeControllers.add(
                                TextEditingController(
                                  text: 'Option ${outcomeControllers.length + 1}',
                                ),
                              );
                            });
                          },
                          icon: const Icon(Icons.add,
                              size: 16, color: AppColor.actionBack),
                          label: const Text(
                            '+ Add Another Option',
                            style: TextStyle(
                                color: AppColor.actionBack, fontSize: 12),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],

                  // Category Selector
                  Row(
                    children: [
                      const Text('Category: ',
                          style:
                              TextStyle(color: AppColor.textDim, fontSize: 13)),
                      DropdownButton<String>(
                        dropdownColor: AppColor.surface,
                        value: selectedCat,
                        style: const TextStyle(color: AppColor.textPrimary),
                        items: ['SPORTS', 'POLITICS', 'PUBLIC_ISSUES', 'CRYPTO']
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedCat = val);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Stake and Stance
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: stakeController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: AppColor.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Initial Stake (\$)',
                            labelStyle:
                                const TextStyle(color: AppColor.textDim),
                            filled: true,
                            fillColor: AppColor.surfaceSubtle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColor.borderSubtle),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: isCustom
                            ? DropdownButtonFormField<int>(
                                dropdownColor: AppColor.surface,
                                initialValue: selectedInitialOutcomeIdx,
                                decoration: InputDecoration(
                                  labelText: 'Your Pick',
                                  labelStyle:
                                      const TextStyle(color: AppColor.textDim),
                                  filled: true,
                                  fillColor: AppColor.surfaceSubtle,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColor.borderSubtle),
                                  ),
                                ),
                                items: List.generate(
                                    outcomeControllers.length, (idx) {
                                  final title = outcomeControllers[idx]
                                          .text
                                          .trim()
                                          .isNotEmpty
                                      ? outcomeControllers[idx].text.trim()
                                      : 'Option ${idx + 1}';
                                  return DropdownMenuItem<int>(
                                    value: idx,
                                    child: Text(
                                      title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }),
                                onChanged: (v) {
                                  if (v != null) {
                                    setModalState(
                                        () => selectedInitialOutcomeIdx = v);
                                  }
                                },
                              )
                            : DropdownButtonFormField<String>(
                                dropdownColor: AppColor.surface,
                                initialValue: selectedSide,
                                decoration: InputDecoration(
                                  labelText: 'Your Side',
                                  labelStyle:
                                      const TextStyle(color: AppColor.textDim),
                                  filled: true,
                                  fillColor: AppColor.surfaceSubtle,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColor.borderSubtle),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'BACK',
                                      child: Text('Back (Yes)')),
                                  DropdownMenuItem(
                                      value: 'OPPOSE',
                                      child: Text('Oppose (No)')),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setModalState(() => selectedSide = v);
                                  }
                                },
                              ),
                      ),
                    ],
                  ),

                  // Private Bet Switch
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Private Bet (Friends & Family)',
                      style: TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Hidden from public feed. Generates an invite code.',
                      style: TextStyle(color: AppColor.textDim, fontSize: 11),
                    ),
                    value: isPrivate,
                    activeThumbColor: AppColor.actionBack,
                    onChanged: (val) => setModalState(() => isPrivate = val),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.actionBack,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final title = titleController.text.trim();
                      if (title.isEmpty) return;
                      Get.back();

                      final outcomes = isCustom
                          ? outcomeControllers
                              .map((c) => c.text.trim())
                              .where((t) => t.isNotEmpty)
                              .toList()
                          : null;

                      final initialOutcome = isCustom &&
                              outcomes != null &&
                              selectedInitialOutcomeIdx < outcomes.length
                          ? outcomes[selectedInitialOutcomeIdx]
                          : null;

                      await controller.createBet(
                        title: title,
                        description: descController.text.trim().isEmpty
                            ? null
                            : descController.text.trim(),
                        category: selectedCat,
                        betType: selectedBetType,
                        outcomes: outcomes,
                        initialOutcome: initialOutcome,
                        deadline: selectedDeadline,
                        isPrivate: isPrivate,
                        initialStake: double.tryParse(stakeController.text),
                        initialSide: isCustom ? null : selectedSide,
                      );
                    },
                    child: Text(
                      isPrivate ? 'Create Private Bet' : 'Publish Market',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showJoinInviteModal(BuildContext context) {
    final codeController = TextEditingController();
    final stakeController = TextEditingController(text: '25');
    String selectedSide = 'BACK';
    BetModel? resolvedBet;
    bool isLoading = false;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Join Bet with Invite Code',
                    style: TextStyle(
                      color: AppColor.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter a 6-character code from a friend (e.g. BET-9K2L8X) to preview and stake.',
                    style: TextStyle(color: AppColor.textDim, fontSize: 12),
                  ),
                  const SizedBox(height: 16),

                  // Code input and lookup
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: codeController,
                          textCapitalization: TextCapitalization.characters,
                          style: const TextStyle(
                            color: AppColor.textPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                          decoration: InputDecoration(
                            hintText: 'BET-XXXXXX',
                            hintStyle: const TextStyle(color: AppColor.textDim),
                            filled: true,
                            fillColor: AppColor.surfaceSubtle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColor.borderSubtle),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.surfaceSubtle,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: AppColor.borderSubtle),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                final code = codeController.text.trim();
                                if (code.isEmpty) return;
                                setModalState(() => isLoading = true);
                                final bet = await controller.lookupInviteBet(code);
                                setModalState(() {
                                  resolvedBet = bet;
                                  isLoading = false;
                                });
                              },
                        child: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Find',
                                style: TextStyle(
                                    color: AppColor.actionBack,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  if (resolvedBet != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColor.surfaceSubtle,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                resolvedBet!.category,
                                style: const TextStyle(
                                  color: AppColor.actionBack,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                resolvedBet!.timeRemainingText,
                                style: const TextStyle(
                                  color: AppColor.textDim,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            resolvedBet!.title,
                            style: const TextStyle(
                              color: AppColor.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildRatioBar(resolvedBet!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Stake & Side selection
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: stakeController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: AppColor.textPrimary),
                            decoration: InputDecoration(
                              labelText: 'Your Stake (\$)',
                              labelStyle:
                                  const TextStyle(color: AppColor.textDim),
                              filled: true,
                              fillColor: AppColor.surfaceSubtle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: AppColor.borderSubtle),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            dropdownColor: AppColor.surface,
                            initialValue: selectedSide,
                            decoration: InputDecoration(
                              labelText: 'Side',
                              labelStyle:
                                  const TextStyle(color: AppColor.textDim),
                              filled: true,
                              fillColor: AppColor.surfaceSubtle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: AppColor.borderSubtle),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'BACK', child: Text('Back (Yes)')),
                              DropdownMenuItem(
                                  value: 'OPPOSE', child: Text('Oppose (No)')),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                setModalState(() => selectedSide = v);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedSide == 'BACK'
                            ? AppColor.actionBack
                            : AppColor.actionOppose,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        final stake =
                            double.tryParse(stakeController.text.trim()) ?? 0;
                        if (stake <= 0) return;
                        Get.back();
                        await controller.joinInviteBet(
                          codeController.text.trim(),
                          side: selectedSide,
                          stake: stake,
                        );
                      },
                      child: Text(
                        'Confirm \$${stakeController.text} Stake ($selectedSide)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
