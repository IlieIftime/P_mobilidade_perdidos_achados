import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/login_screen.dart';
import 'screens/homepage_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'utils/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

      // ✅ Começa sempre no login
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
      },

      // ✅ /home recebe um bool (isGuest) nos arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final bool isGuest = (settings.arguments as bool?) ?? false;

          return MaterialPageRoute(
            builder: (_) => HomepageScreen(isGuest: isGuest),
          );
        }
        return null;
      },
    );
  }
}

