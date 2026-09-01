import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/auth/widgets/gradient_button.dart';
import 'package:fitness_app/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Main Gradient Circle
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFC58BF2),
                                Color(0xFFEEA4CE),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFC58BF2).withAlpha(100),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                        // Decorative Dots (Approximate positions from reference)
                        // Positioned(
                        //   left: 10,
                        //   top: 100,
                        //   child: _buildDot(color: const Color(0xFF4CAF50), size: 12),
                        // ),
                        // Positioned(
                        //   right: 20,
                        //   bottom: 20,
                        //   child: _buildDot(color: const Color(0xFF4CAF50).withAlpha(150), size: 8),
                        // ),
                        // Positioned(
                        //   right: 30,
                        //   top: 80,
                        //   child: _buildDot(color: Colors.white.withAlpha(200), size: 4),
                        // ),
                        // Positioned(
                        //   left: 60,
                        //   bottom: 10,
                        //   child: _buildDot(color: Colors.white.withAlpha(150), size: 6),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Success Text
                    const Text(
                      'Congrats!',
                      style: TextStyle(
                        color: Color(0xFFC58BF2),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Password reset successful',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Done Button
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 60),
              child: GradientButton(
                text: 'Done',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({required Color color, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
