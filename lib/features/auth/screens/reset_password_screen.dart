import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/auth/controllers/reset_password_cubit.dart';
import 'package:fitness_app/features/auth/controllers/reset_password_state.dart';
import 'package:fitness_app/features/auth/widgets/gradient_button.dart';
import 'package:fitness_app/features/auth/screens/reset_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
            listener: (context, state) {
              if (state.status == ResetPasswordStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Password reset successfully!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
                // Navigate to success screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ResetSuccessScreen()),
                );
              } else if (state.status == ResetPasswordStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'An error occurred'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(30, 60, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          // Title
                          const Text(
                            'Reset your\npassword here',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Subtitle
                          Text(
                            'Select which contact details should\nwe use to reset your password',
                            style: TextStyle(
                              color: Colors.white.withAlpha(200),
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 60),

                          // Input Fields
                          _buildTextField(
                            controller: _newPasswordController,
                            hintText: 'New Password',
                            obscureText: !state.isNewPasswordVisible,
                            onToggleVisibility: () =>
                                context.read<ResetPasswordCubit>().toggleNewPasswordVisibility(),
                            onChanged: (value) =>
                                context.read<ResetPasswordCubit>().onNewPasswordChanged(value),
                            isVisible: state.isNewPasswordVisible,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            obscureText: !state.isConfirmPasswordVisible,
                            onToggleVisibility: () =>
                                context.read<ResetPasswordCubit>().toggleConfirmPasswordVisibility(),
                            onChanged: (value) =>
                                context.read<ResetPasswordCubit>().onConfirmPasswordChanged(value),
                            isVisible: state.isConfirmPasswordVisible,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Next Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 60),
                    child: GradientButton(
                      text: 'Next',
                      isLoading: state.status == ResetPasswordStatus.loading,
                      onPressed: () {
                        context.read<ResetPasswordCubit>().resetPassword();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required Function(String) onChanged,
    required bool isVisible,
  }) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFF1D1B20), // Darker gray for fields
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF49454F), fontSize: 18),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: isVisible ? const Color(0xFF4CAF50) : const Color(0xFF49454F), // Green eye if visible
              size: 28,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }
}
