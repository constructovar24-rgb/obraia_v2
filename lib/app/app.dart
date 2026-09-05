import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../features/environment/presentation/widgets/environment_controls.dart';
import 'app_theme.dart';

class ObraIAApp extends StatelessWidget {
  const ObraIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OBRA IA',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      builder: (context, child) => Column(
        children: [
          const SafeArea(bottom: false, child: EnvironmentIndicator()),
          Expanded(child: child!),
        ],
      ),
      home: const HomeScreen(),
    );
  }
}
