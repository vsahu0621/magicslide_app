import 'package:flutter/material.dart';
import 'package:magicslide_app/features/home/home_page.dart';
import 'package:magicslide_app/features/service/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const AuthGate({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      return HomePage(
        isDark: isDark,
        onToggleTheme: onToggleTheme,
      );
    }

    return LoginPage(
      isDark: isDark,
      onToggleTheme: onToggleTheme,
    );
  }
}
