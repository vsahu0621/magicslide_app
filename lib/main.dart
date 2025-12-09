import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'features/service/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const ProviderScope(child: MagicSlideApp()));
}

class MagicSlideApp extends StatefulWidget {
  const MagicSlideApp({super.key});

  @override
  State<MagicSlideApp> createState() => _MagicSlideAppState();
}

class _MagicSlideAppState extends State<MagicSlideApp> {
  bool dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MagicSlides",
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),

      home: AuthGate(
        isDark: dark,
        onToggleTheme: () {
          setState(() {
            dark = !dark;
          });
        },
      ),
    );
  }
}
