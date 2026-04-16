import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedRole = 'STUDENT';
  bool _obscureText = true;
  bool _stayAuthenticated = false;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      _selectedRole = Get.arguments;
    }
  }

  void _handleLogin() {
    if (_selectedRole == 'PARENT') {
      Get.offAllNamed(AppRoutes.parentDashboard);
    } else if (_selectedRole == 'INSTITUTE') {
      Get.offAllNamed(AppRoutes.instituteDashboard);
    } else {
      Get.offAllNamed(AppRoutes.studentDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBg,
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
                    decoration: const BoxDecoration(
                      color: AppColors.iconBgLightBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.school,
                        color: AppColors.primaryBlue,
                        size: AppSpacing.s24,
                      ),
                    ),
                  ),
                  AppSpacing.h12,
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              AppSpacing.v32,
              Text(
                AppStrings.loginHeader,
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                  letterSpacing: 1.5,
                ),
              ),
              AppSpacing.v8,
              Text(
                AppStrings.loginWelcome,
                style: AppTextStyles.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v8,
              Text(
                AppStrings.loginSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                  height: 1.5,
                ),
              ),
              AppSpacing.v32,

              // Main Authentication Card
              Container(
                margin: AppSpacing.x24,
                padding: const EdgeInsets.all(AppSpacing.s28),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
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
                    // Identifier Field
                    Text(
                      'IDENTIFIER',
                      style: AppTextStyles.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDarkGrey,
                        letterSpacing: 1.0,
                      ),
                    ),
                    AppSpacing.v8,
                    _buildTextField(
                      hint: 'Phone or Institutional Email',
                      prefixIcon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    AppSpacing.v24,

                    // Access Key Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ACCESS KEY',
                          style: AppTextStyles.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDarkGrey,
                            letterSpacing: 1.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'RECOVER?',
                            style: AppTextStyles.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBlue,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.v8,
                    _buildTextField(
                      hint: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textMuted,
                          size: AppSpacing.s20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),

                    AppSpacing.v24,

                    // Checkbox
                    Row(
                      children: [
                        SizedBox(
                          width: AppSpacing.s24,
                          height: AppSpacing.s24,
                          child: Checkbox(
                            value: _stayAuthenticated,
                            onChanged: (value) {
                              setState(() {
                                _stayAuthenticated = value ?? false;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.s6,
                              ),
                            ),
                            side: BorderSide(
                              color: AppColors.borderLightGray,
                              width: 1.5,
                            ),
                            activeColor: AppColors.primaryBlue,
                          ),
                        ),
                        AppSpacing.h12,
                        Text(
                          AppStrings.stayAuthenticated,
                          style: AppTextStyles.lexend(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    AppSpacing.v32,

                    // Login Button using common AppButton
                    AppButton(
                      label: AppStrings.signInButton,
                      onPressed: _handleLogin,
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      borderRadius: AppSpacing.s24,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.s18,
                      ),
                      fontSize: 16,
                      fullWidth: true,
                    ),
                  ],
                ),
              ),

              AppSpacing.v32,

              // Bottom Footer
              RichText(
                text: TextSpan(
                  text: AppStrings.enrolmentText,
                  style: AppTextStyles.lexend(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: AppStrings.enrolmentLink,
                      style: AppTextStyles.lexend(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.v24,

              // Support & Security Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBottomCard(Icons.help_outline, 'SUPPORT'),
                  AppSpacing.h16,
                  _buildBottomCard(Icons.security, 'SECURITY'),
                ],
              ),

              AppSpacing.v32,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
      ),
      child: TextField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.lexend(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.lexend(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.textMuted,
            size: AppSpacing.s20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }

  Widget _buildBottomCard(IconData icon, String title) {
    return Container(
      width: AppSpacing.s140,
      padding: AppSpacing.y16,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: AppSpacing.s10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: AppSpacing.s20),
          AppSpacing.v8,
          Text(
            title,
            style: AppTextStyles.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
