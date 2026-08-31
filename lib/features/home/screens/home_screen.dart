import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/bmi_card.dart';
import '../widgets/today_target_card.dart';
import '../widgets/activity_status_section.dart';
import '../widgets/workout_progress_card.dart';
import '../widgets/latest_workout_list.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../controllers/home_cubit.dart';
import '../controllers/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    // Mock user data for calculation
    const double userHeight = 180.0; // cm
    const double userWeight = 65.0; // kg

    return Scaffold(
      backgroundColor: colors.bgColor,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeLoaded) {
              final data = state.data;
              return RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().refreshData(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeader(),
                      const SizedBox(height: 30),
                      BMICard(
                        height: userHeight,
                        weight: userWeight,
                        data: data,
                      ),
                      const SizedBox(height: 30),
                      TodayTargetCard(
                        data: data,
                        onCheck: () => context.read<HomeCubit>().checkTodayTarget(),
                      ),
                      const SizedBox(height: 30),
                      ActivityStatusSection(
                        data: data,
                        onAddWater: (amount) => context.read<HomeCubit>().addWater(amount),
                        onHeartRateUpdate: () => context.read<HomeCubit>().updateHeartRate(),
                      ),
                      const SizedBox(height: 30),
                      const WorkoutProgressCard(),
                      const SizedBox(height: 30),
                      const LatestWorkoutList(),
                      const SizedBox(height: 100), // Space for bottom nav
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
