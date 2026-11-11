import 'package:flutter/material.dart';
import 'package:augustine6237/app/core/config/app_config.dart';
import 'package:augustine6237/app/core/extensions/sizedbox_extension.dart';
import 'package:augustine6237/app/core/extensions/text_style_extension.dart';
import 'package:augustine6237/app/core/theme/app_color.dart';
import 'package:augustine6237/app/global/widgets/app_input_text_form_field.dart';
import 'package:augustine6237/app/global/widgets/app_text.dart';
import 'package:augustine6237/app/global/widgets/global_button.dart';
import 'package:augustine6237/app/global/widgets/global_loading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                20.height,
                Center(
                  child: Image.asset(AppConfig.appLogo, width: 100.w),
                ),
                20.height,
                AppText(
                  'Create BetSocial Account',
                  style: context.titleLarge.copyWith(
                    color: AppColor.actionBack,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                6.height,
                AppText(
                  'Join the social prediction & matched betting community',
                  style: context.bodyMedium.copyWith(color: AppColor.textSecondary),
                  textAlign: TextAlign.center,
                ),
                28.height,
                AppInputTextFormField(
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  controller: controller.nameController,
                  validator: controller.validateName,
                  prefixIcon: const Icon(Icons.person_outline, color: AppColor.textDim),
                ),
                16.height,
                AppInputTextFormField(
                  label: 'Email',
                  hintText: 'Enter your email address',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColor.textDim),
                ),
                16.height,
                AppInputTextFormField(
                  label: 'Phone Number (Optional)',
                  hintText: 'Enter your phone number',
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhone,
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColor.textDim),
                ),
                16.height,
                PasswordInputField(
                  label: 'Password',
                  hintText: 'Create a strong password (min 6 chars)',
                  controller: controller.passwordController,
                  validator: controller.validatePassword,
                ),
                16.height,
                PasswordInputField(
                  label: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  controller: controller.confirmPasswordController,
                  validator: controller.validateConfirmPassword,
                ),
                28.height,
                Obx(
                  () => GlobalButton(
                    text: 'Create Account',
                    onTap: controller.onRegister,
                    widget: controller.isLoading.value
                        ? GlobalLoading(size: 24.sp, color: AppColor.white)
                        : null,
                  ),
                ),
                20.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      'Already have an account? ',
                      style: context.bodyMedium.copyWith(color: AppColor.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => Get.offNamed(Routes.LOGIN),
                      child: AppText(
                        'Sign In',
                        style: context.bodyMedium.copyWith(
                          color: AppColor.actionBack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                24.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

