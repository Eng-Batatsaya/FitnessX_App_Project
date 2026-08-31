import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_text_styles.dart';
import 'package:fitness_app/features/auth/controllers/complete_profile_cubit.dart';
import 'package:fitness_app/features/auth/controllers/complete_profile_state.dart';
import 'package:fitness_app/features/auth/widgets/auth_text_field.dart';
import 'package:fitness_app/features/auth/widgets/gradient_button.dart';
import 'package:fitness_app/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void dispose() {
    _genderController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _showGenderPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Gender',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Male'),
                onTap: () {
                  _genderController.text = 'Male';
                  context.read<CompleteProfileCubit>().genderChanged('Male');
                  Navigator.pop(bottomSheetContext);
                },
              ),
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  _genderController.text = 'Female';
                  context.read<CompleteProfileCubit>().genderChanged('Female');
                  Navigator.pop(bottomSheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final cubit = context.read<CompleteProfileCubit>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF92A3FD),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      _dobController.text = formattedDate;
      cubit.dateOfBirthChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompleteProfileCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<CompleteProfileCubit, CompleteProfileState>(
          listener: (context, state) {
            if (state.status == CompleteProfileStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile Completed!')),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (state.status == CompleteProfileStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Error occurred'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Top Illustration
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // We use a placeholder since the exact asset was not found
                        // In a real scenario, this would be assets/images/auth/complete_profile.png
                        Image.asset(
                          'lib/features/auth/assets/images/Vector-Section.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                             return const Icon(Icons.person_pin, size: 200, color: Color(0xFF92A3FD));
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const Text(
                          'Let’s complete your profile',
                          style: AppTextStyles.heading1,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'It will help us to know more about you!',
                          style: TextStyle(color: AppColors.gray2, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),

                        // Gender Field
                        AuthTextField(
                          controller: _genderController,
                          hintText: 'Choose Gender',
                          prefixIcon: Icons.people_outline,
                          readOnly: true,
                          onTap: () => _showGenderPicker(context),
                          suffixIcon: const Icon(Icons.keyboard_arrow_down, color: AppColors.gray2),
                        ),
                        const SizedBox(height: 15),

                        // Date of Birth Field
                        AuthTextField(
                          controller: _dobController,
                          hintText: 'Date of Birth',
                          prefixIcon: Icons.calendar_today_outlined,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 15),

                        // Weight Field
                        Row(
                          children: [
                            Expanded(
                              child: AuthTextField(
                                controller: _weightController,
                                hintText: 'Your Weight',
                                prefixIcon: Icons.monitor_weight_outlined,
                                keyboardType: TextInputType.number,
                                onChanged: (val) => context.read<CompleteProfileCubit>().weightChanged(val),
                              ),
                            ),
                            const SizedBox(width: 15),
                            _buildUnitButton('KG'),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Height Field
                        Row(
                          children: [
                            Expanded(
                              child: AuthTextField(
                                controller: _heightController,
                                hintText: 'Your Height',
                                prefixIcon: Icons.height,
                                keyboardType: TextInputType.number,
                                onChanged: (val) => context.read<CompleteProfileCubit>().heightChanged(val),
                              ),
                            ),
                            const SizedBox(width: 15),
                            _buildUnitButton('CM'),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Next Button
                        GradientButton(
                          text: 'Next',
                          icon: Icons.chevron_right,
                          isIconRight: true,
                          isLoading: state.status == CompleteProfileStatus.loading,
                          onPressed: () {
                            context.read<CompleteProfileCubit>().submit();
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUnitButton(String unit) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFC58BF2),
            Color(0xFFEEA4CE),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        unit,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
