import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ObraIAApp());
}

class ObraIAApp extends StatelessWidget {
  const ObraIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OBRA IA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}