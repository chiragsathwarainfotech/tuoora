import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/shared/controllers/login_controller.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.find<LoginController>();
  String _selectedRole = 'STUDENT';

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      _selectedRole = Get.arguments;
    }
  }

  void _handleLogin() {
    controller.login(_selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppSpacing.v32,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: AppSpacing.s40,
                    height: AppSpacing.s40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrandLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.school,
                        color: AppColors.primaryBrand,
                        size: AppSpacing.s24,
                      ),
                    ),
                  ),
                  AppSpacing.h12,
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                ],
              ),
              AppSpacing.v32,
              Text(
                AppStrings.loginHeader,
                style: AppTextStyles.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBrand,
                  letterSpacing: 1.5,
                ),
              ),
              AppSpacing.v8,
              Text(
                AppStrings.loginWelcome,
                style: AppTextStyles.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blueSapphire,
                  height: 1.5,
                ),
              ),
              AppSpacing.v8,
              Text(
                AppStrings.loginSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blueSapphire,
                  height: 1.5,
                ),
              ),
              AppSpacing.v32,
              Container(
                margin: AppSpacing.x24,
                padding: const EdgeInsets.all(AppSpacing.s28),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.s32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: AppSpacing.s24,
                      offset: const Offset(0, AppSpacing.s12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'IDENTIFIER',
                      style: AppTextStyles.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brandAppBarColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                    AppSpacing.v8,
                    _buildTextField(
                      controller: controller.emailController,
                      hint: 'Phone or Institutional Email',
                      prefixIcon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    AppSpacing.v24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ACCESS KEY',
                          style: AppTextStyles.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.brandAppBarColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_selectedRole == 'INSTITUTE') {
                              Get.toNamed(AppRoutes.instituteForgotPassword);
                            } else {
                              Get.snackbar(
                                'Coming Soon',
                                'Recovery for this role will be available soon.',
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'RECOVER?',
                            style: AppTextStyles.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBrand,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.v8,
                    Obx(
                      () => _buildTextField(
                        controller: controller.passwordController,
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        obscureText: controller.obscurePassword.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textMuted,
                            size: AppSpacing.s20,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                    AppSpacing.v24,
                    Obx(
                      () => Row(
                        children: [
                          SizedBox(
                            width: AppSpacing.s24,
                            height: AppSpacing.s24,
                            child: Checkbox(
                              value: controller.stayAuthenticated.value,
                              onChanged: (value) =>
                                  controller.toggleStayAuthenticated(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.s6,
                                ),
                              ),
                              side: BorderSide(
                                color: AppColors.borderLightGray,
                                width: 1.5,
                              ),
                              activeColor: AppColors.primaryBrand,
                            ),
                          ),
                          AppSpacing.h12,
                          Text(
                            AppStrings.stayAuthenticated,
                            style: AppTextStyles.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blueSapphire,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.v32,
                    Obx(
                      () => AppButton(
                        label: AppStrings.signInButton,
                        onPressed: _handleLogin,
                        isLoading: controller.isLoading.value,
                        backgroundColor: AppColors.primaryBrand,
                        foregroundColor: AppColors.white,
                        borderRadius: AppSpacing.s24,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s18,
                        ),
                        fontSize: 16,
                        fullWidth: true,
                      ),
                    ),
                  ],
                ),
              ),
              if (_selectedRole == 'INSTITUTE') ...[
                AppSpacing.v32,
                Padding(
                  padding: AppSpacing.x24,
                  child: Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: AppSpacing.x16,
                        child: Text(
                          'OR EXPAND YOUR REACH',
                          style: AppTextStyles.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.brandAppBarColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
                AppSpacing.v32,
                Padding(
                  padding: AppSpacing.x24,
                  child: AppButton(
                    label: 'Institute Registration',
                    onPressed: () => Get.toNamed(AppRoutes.instituteSignup),
                    icon: Icons.storefront_outlined,
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primaryBrand,
                    borderColor: AppColors.borderGrey,
                    borderRadius: AppSpacing.s16,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.s18,
                    ),
                    fontSize: 16,
                    fullWidth: true,
                  ),
                ),
              ],
              AppSpacing.v32,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paleSilver,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.outfit(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.outfit(
            fontSize: 14,
            color: AppColors.blueSapphire,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.blueSapphire,
            size: AppSpacing.s20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }
}
