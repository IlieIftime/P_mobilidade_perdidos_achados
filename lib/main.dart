import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'utils/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOS Perdidos e Achados',
      debugShowCheckedModeBanner: false,
      theme: AppStyles.lightTheme,
      home: const LoginScreen(),
    );
  }
}
