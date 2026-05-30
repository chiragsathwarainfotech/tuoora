import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_images.dart';
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
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppSpacing.v32,
                    Image.asset(AppImages.logoWithName, height: AppSpacing.s48),
                    AppSpacing.v12,
                    Text(
                      AppStrings.tagLine,
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
                      margin: AppSpacing.x16,
                      padding: AppSpacing.cardPadding,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.cardRadius,
                        ),
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
                            'Email Address',
                            style: AppTextStyles.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.fieldLabel,
                              letterSpacing: 1.0,
                            ),
                          ),
                          AppSpacing.v8,
                          _buildTextField(
                            controller: controller.emailController,
                            hint: 'Enter email',
                            prefixIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          AppSpacing.v24,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Password',
                                style: AppTextStyles.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.fieldLabel,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_selectedRole == 'INSTITUTE') {
                                    Get.toNamed(
                                      AppRoutes.instituteForgotPassword,
                                    );
                                  } else {
                                    AppSnackBar.warning(
                                      'Recovery for this role will be available soon.',
                                      title: 'Coming Soon',
                                    );
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: AppTextStyles.outfit(
                                    fontSize: 12,
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
                                  AppStrings.rememberMe,
                                  style: AppTextStyles.outfit(
                                    fontSize: 14,
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
                              borderRadius: AppSpacing.cardRadius,
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
                        padding: AppSpacing.x16,
                        child: AppButton(
                          label: 'Institute Registration',
                          onPressed: () =>
                              Get.toNamed(AppRoutes.instituteSignup),
                          icon: Icons.storefront_outlined,
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.primaryBrand,
                          borderColor: AppColors.borderGrey,
                          borderRadius: AppSpacing.cardRadius,
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
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.fieldBorder),
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
            color: AppColors.fieldLabel,
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
