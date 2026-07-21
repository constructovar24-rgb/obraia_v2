import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import 'app_theme.dart';

class ObraIAApp extends StatelessWidget {
  const ObraIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OBRA IA',
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}