import 'package:flutter/material.dart';
import 'package:augustine6237/app/core/network/handle_exceptions.dart';
import 'package:augustine6237/app/data/repositories/auth_repository.dart';
import 'package:augustine6237/app/global/widgets/global_snackbar.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final IAuthRepository _authRepository = Get.find<IAuthRepository>();

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Full name is required';
    if (name.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(email)) return 'Enter a valid email address';
    return null;
  }

  String? validatePhone(String? value) {
    // Phone is optional but if provided should be valid format
    final phone = value?.trim() ?? '';
    if (phone.isNotEmpty && phone.length < 7) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    final pass = value ?? '';
    if (pass.isEmpty) return 'Password is required';
    if (pass.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> onRegister() async {
    if (isLoading.value) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      isLoading.value = true;
      final response = await _authRepository.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phoneNumber: phoneController.text.trim(),
      );

      final isSuccess = response is Map && (response['success'] == true || response['statusCode'] == null || response['statusCode'] == 200 || response['statusCode'] == 201);

      if (isSuccess) {
        globalSnackBar(
          title: 'Account Created',
          message: 'Welcome to BetSocial! Please sign in with your credentials.',
        );
        Get.offNamed(Routes.LOGIN);
      } else {
        final message = (response is Map && response['message'] != null)
            ? response['message'].toString()
            : 'Registration failed. Please try again.';
        globalSnackBar(title: 'Registration Failed', message: message);
      }
    } catch (e) {
      handleException(e, context: 'Registration');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

