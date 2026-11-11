import 'package:flutter/material.dart';
import 'package:augustine6237/app/core/config/app_config.dart';
import 'package:augustine6237/app/core/extensions/sizedbox_extension.dart';
import 'package:augustine6237/app/core/extensions/text_style_extension.dart';
import 'package:augustine6237/app/core/theme/app_color.dart';
import 'package:augustine6237/app/global/widgets/app_input_text_form_field.dart';
import 'package:augustine6237/app/global/widgets/app_text.dart';
import 'package:augustine6237/app/global/widgets/custom_check_box.dart';
import 'package:augustine6237/app/global/widgets/global_button.dart';
import 'package:augustine6237/app/global/widgets/global_loading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
                40.height,
                Center(child: Image.asset(AppConfig.appLogo, width: 120.w)),
                24.height,
                AppText(
                  'Welcome Back',
                  style: context.titleLarge.copyWith(color: AppColor.primary),
                  textAlign: TextAlign.center,
                ),
                8.height,
                AppText(
                  'Sign in to continue',
                  style: context.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                32.height,
                AppInputTextFormField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                16.height,
                PasswordInputField(
                  hintText: 'Enter your password',
                  controller: controller.passwordController,
                  validator: controller.validatePassword,
                ),
                12.height,
                Row(
                  children: [
                    Obx(
                      () => CustomCheckBox(
                        isChecked: controller.rememberMe.value,
                        onTap: controller.toggleRememberMe,
                      ),
                    ),
                    6.width,
                    GestureDetector(
                      onTap: controller.toggleRememberMe,
                      child: AppText('Remember me', style: context.bodyMedium),
                    ),
                  ],
                ),
                32.height,
                Obx(
                  () => GlobalButton(
                    text: 'Login',
                    onTap: controller.onLogin,
                    widget: controller.isLoading.value
                        ? GlobalLoading(size: 24.sp, color: AppColor.white)
                        : null,
                  ),
                ),
                24.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      "Don't have an account? ",
                      style: context.bodyMedium.copyWith(color: AppColor.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.REGISTER),
                      child: AppText(
                        'Sign Up',
                        style: context.bodyMedium.copyWith(
                          color: AppColor.actionBack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
