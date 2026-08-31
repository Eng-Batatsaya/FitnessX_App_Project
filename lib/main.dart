import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/screens/welcome_screen.dart';
import 'core/controllers/theme_cubit.dart';
import 'core/controllers/theme_state.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ThemeCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'FitnessX',
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}