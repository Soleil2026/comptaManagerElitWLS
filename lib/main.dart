import 'package:flutter/material.dart';
import 'package:compta_manager/core/theme/app_theme.dart';
import 'package:compta_manager/data/database/database_helper.dart';
import 'package:compta_manager/features/auth/screens/login_screen.dart';
import 'package:compta_manager/features/documents/screens/documents_screen.dart';
import 'package:compta_manager/features/clients/screens/clients_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await DatabaseHelper.instance.database;
    print('Database initialized successfully');
  } catch (e) {
    print('Database initialization error: $e');
  }
  
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
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/documents':
            return MaterialPageRoute(builder: (_) => const DocumentsScreen());
          case '/clients':
            return MaterialPageRoute(builder: (_) => const ClientsScreen());
          default:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
      },
    );
  }
}