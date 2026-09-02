import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/auth/controllers/forgot_password_cubit.dart';
import 'package:fitness_app/features/auth/controllers/forgot_password_state.dart';
import 'package:fitness_app/features/auth/widgets/auth_text_field.dart';
import 'package:fitness_app/features/auth/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _phoneController =
  TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocConsumer<
              ForgotPasswordCubit,
              ForgotPasswordState>(
            listener: (context, state) {
              if (state.status == ForgotPasswordStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Password reset link sent! Please check your email.',
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
                Navigator.pop(context);
              } else if (state.status ==
                  ForgotPasswordStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ??
                          'An error occurred',
                    ),
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
                      padding: const EdgeInsets.fromLTRB(
                        30,
                        20,
                        30,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          GestureDetector(
                            onTap: () =>
                                Navigator.pop(context),
                            child: Container(
                              padding:
                              const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.black,
                                borderRadius:
                                BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Color(0xFFE57C23),
                                size: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Title
                          const Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Subtitle
                          Text(
                            'Select which contact details should\n'
                                'we use to reset your password',
                            style: TextStyle(
                              color: Colors.white
                                  .withAlpha(178),
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 40),

                          // SMS Selection
                          _buildSelectionCard(
                            context: context,
                            title: 'Via sms:',
                            subtitle: state.selectedMethod ==
                                ForgotPasswordMethod.sms
                                ? (state.phoneNumber.isEmpty
                                ? 'Enter your number'
                                : state.phoneNumber)
                                : 'Use phone number',
                            icon: Icons.chat_bubble_rounded,
                            isSelected: state.selectedMethod ==
                                ForgotPasswordMethod.sms,
                            onTap: () {
                              context
                                  .read<ForgotPasswordCubit>()
                                  .selectMethod(
                                ForgotPasswordMethod.sms,
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          // Email Selection
                          _buildSelectionCard(
                            context: context,
                            title: 'Via email:',
                            subtitle: state.selectedMethod ==
                                ForgotPasswordMethod.email
                                ? (state.email.isEmpty
                                ? 'Enter your email'
                                : state.email)
                                : 'Use email address',
                            icon: Icons.email_rounded,
                            isSelected: state.selectedMethod ==
                                ForgotPasswordMethod.email,
                            onTap: () {
                              context
                                  .read<ForgotPasswordCubit>()
                                  .selectMethod(
                                ForgotPasswordMethod.email,
                              );
                            },
                          ),

                          const SizedBox(height: 30),

                          // Input Field
                          if (state.selectedMethod ==
                              ForgotPasswordMethod.sms)
                            AuthTextField(
                              controller: _phoneController,
                              hintText: 'Phone Number',
                              prefixIcon:
                              Icons.phone_android_rounded,
                              keyboardType:
                              TextInputType.phone,
                              backgroundColor: AppColors.black,
                              onChanged: (value) {
                                context
                                    .read<ForgotPasswordCubit>()
                                    .onPhoneChanged(value);
                              },
                            )
                          else
                            AuthTextField(
                              controller: _emailController,
                              hintText: 'Email Address',
                              prefixIcon:
                              Icons.email_outlined,
                              keyboardType:
                              TextInputType.emailAddress,
                              backgroundColor: AppColors.black,
                              onChanged: (value) {
                                context
                                    .read<ForgotPasswordCubit>()
                                    .onEmailChanged(value);
                              },
                            ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Next Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      30,
                      20,
                      30,
                      40,
                    ),
                    child: GradientButton(
                      text: 'Next',
                      isLoading: state.status ==
                          ForgotPasswordStatus.loading,
                      onPressed: () {
                        context
                            .read<ForgotPasswordCubit>()
                            .sendResetRequest();
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

  Widget _buildSelectionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF92A3FD)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF92A3FD)
                  .withAlpha(51),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFC5D3FF)
                    .withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF92A3FD),
                size: 30,
              ),
            ),

            const SizedBox(width: 20),

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withAlpha(127),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}