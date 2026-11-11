import 'package:get/get.dart';
import 'package:augustine6237/app/core/network/api_client.dart';
import 'auth_repository.dart';
import 'profile_repository.dart';
import 'bet_repository.dart';
import 'wallet_repository.dart';
import 'payment_repository.dart';
import 'kyc_dispute_repository.dart';
import 'gaming_repository.dart';
import 'ai_repository.dart';
import 'admin_repository.dart';

class AppRepositoryBinding extends Bindings {
  @override
  void dependencies() {
    // ApiClient — permanent, created immediately, shared by all repositories
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Repositories — lazy, created only when first Get.find() is called
    Get.lazyPut<IAuthRepository>(
      () => AuthRepository(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<IProfileRepository>(
      () => ProfileRepository(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<IBetRepository>(
      () => BetRepository(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<IWalletRepository>(
      () => WalletRepository(),
      fenix: true,
    );
    Get.lazyPut<IPaymentRepository>(
      () => PaymentRepository(),
      fenix: true,
    );
    Get.lazyPut<IKycDisputeRepository>(
      () => KycDisputeRepository(),
      fenix: true,
    );
    Get.lazyPut<IGamingRepository>(
      () => GamingRepository(),
      fenix: true,
    );
    Get.lazyPut<IAiRepository>(
      () => AiRepository(),
      fenix: true,
    );
    Get.lazyPut<IAdminRepository>(
      () => AdminRepository(),
      fenix: true,
    );
  }
}