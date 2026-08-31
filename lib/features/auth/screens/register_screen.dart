import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_text_styles.dart';
import 'package:fitness_app/features/auth/controllers/register_cubit.dart';
import 'package:fitness_app/features/auth/controllers/register_state.dart';
import 'package:fitness_app/features/auth/widgets/auth_text_field.dart';
import 'package:fitness_app/features/auth/widgets/gradient_button.dart';
import 'package:fitness_app/features/auth/widgets/social_button.dart';
import 'package:fitness_app/features/auth/screens/login_screen.dart';
import 'package:fitness_app/features/auth/screens/complete_profile_screen.dart';
import 'package:fitness_app/features/home/screens/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Registration Successful!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                );
                // If it's social registration, go to Home. Otherwise, go to Complete Profile.
                if (state.isSocial) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CompleteProfileScreen()),
                  );
                }
              } else if (state is RegisterFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                      child: Column(
                        children: [
                          const Text(
                            'Hey there,',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Create an Account',
                            style: AppTextStyles.heading1,
                          ),
                          const SizedBox(height: 30),
                          
                          // Input Fields
                          AuthTextField(
                            controller: _firstNameController,
                            hintText: 'First Name',
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 15),
                          AuthTextField(
                            controller: _lastNameController,
                            hintText: 'Last Name',
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 15),
                          AuthTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            prefixIcon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 15),
                          AuthTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: !state.isPasswordVisible,
                            onToggleVisibility: () {
                              context.read<RegisterCubit>().togglePasswordVisibility();
                            },
                          ),
                          const SizedBox(height: 15),
                          
                          // Terms and Conditions
                          Row(
                            children: [
                              Checkbox(
                                value: state.isTermsAccepted,
                                onChanged: (value) {
                                  context.read<RegisterCubit>().toggleTerms(value ?? false);
                                },
                                activeColor: const Color(0xFF92A3FD),
                                side: const BorderSide(color: AppColors.gray2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'By creating an account, you agree to our ',
                                    style: const TextStyle(color: AppColors.gray2, fontSize: 12),
                                    children: [
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // Handle Privacy Policy tap
                                          },
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Term of Use',
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // Handle Term of Use tap
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Bottom Section - Fixed in place
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Register Button
                        GradientButton(
                          text: 'Register',
                          isLoading: state is RegisterLoading,
                          onPressed: () {
                            context.read<RegisterCubit>().register(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              termsAccepted: state.isTermsAccepted,
                            );
                          },
                        ),
                        
                        const SizedBox(height: 30),
                        // Divider Section
                        Row(
                          children: [
                            const Expanded(child: Divider(color: AppColors.gray3)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Or Continue With',
                                style: TextStyle(color: AppColors.gray1, fontSize: 12),
                              ),
                            ),
                            const Expanded(child: Divider(color: AppColors.gray3)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Social Buttons
                        Row(
                          children: [
                            SocialButton(
                              text: 'Facebook',
                              iconPath: '',
                              onPressed: () => context.read<RegisterCubit>().socialRegister('Facebook'),
                            ),
                            const SizedBox(width: 15),
                            SocialButton(
                              text: 'Google',
                              iconPath: '',
                              isGoogle: true,
                              onPressed: () => context.read<RegisterCubit>().socialRegister('Google'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        
                        // Login navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xFFC58BF2),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
