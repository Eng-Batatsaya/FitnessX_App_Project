import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_text_styles.dart';
import 'package:fitness_app/features/auth/controllers/login_cubit.dart';
import 'package:fitness_app/features/auth/controllers/login_state.dart';
import 'package:fitness_app/features/auth/widgets/auth_text_field.dart';
import 'package:fitness_app/features/auth/widgets/gradient_button.dart';
import 'package:fitness_app/features/auth/widgets/social_button.dart';
import 'package:fitness_app/features/auth/screens/forgot_password_screen.dart';
import 'package:fitness_app/features/auth/screens/register_screen.dart';
import 'package:fitness_app/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Login Successful!'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                );
                // Navigate to home screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              } else if (state is LoginFailure) {
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Header Section
                          const Text(
                            'Hey there,',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Welcome Back',
                            style: AppTextStyles.heading1,
                          ),
                          const SizedBox(height: 30),

                          // Input Fields
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
                              context.read<LoginCubit>().togglePasswordVisibility();
                            },
                          ),

                          const SizedBox(height: 10),
                          // Forgot Password
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot your password?',
                                style: TextStyle(
                                  color: AppColors.gray2,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Container pinned to bottom
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Login Button
                        GradientButton(
                          text: 'Login',
                          icon: Icons.login,
                          isLoading: state is LoginLoading,
                          onPressed: () {
                            context.read<LoginCubit>().login(
                                  _emailController.text,
                                  _passwordController.text,
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
                        // Social Login Buttons
                        Row(
                          children: [
                            SocialButton(
                              text: 'Facebook',
                              iconPath: '', // Handled by icon inside
                              onPressed: () => context.read<LoginCubit>().socialLogin('Facebook'),
                            ),
                            const SizedBox(width: 15),
                            SocialButton(
                              text: 'Google',
                              iconPath: '', // Handled by icon inside
                              isGoogle: true,
                              onPressed: () => context.read<LoginCubit>().socialLogin('Google'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                        // Footer Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account yet? ",
                              style: TextStyle(color: Colors.white),
                            ),
                            GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register',
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
