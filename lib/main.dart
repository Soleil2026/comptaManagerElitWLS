import 'package:flutter/material.dart';
import 'package:compta_manager/core/theme/app_theme.dart';
import 'package:compta_manager/features/auth/screens/login_screen.dart';
import 'package:compta_manager/features/documents/screens/documents_screen.dart';

void main() {
  runApp(const ComptaManagerApp());
}

class ComptaManagerApp extends StatelessWidget {
  const ComptaManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'comptaManagerDZ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      routes: {
        '/documents': (context) => const DocumentsScreen(),
      },
    );
  }
}