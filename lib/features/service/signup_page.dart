import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const SignupPage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  Future<void> signup() async {
    setState(() => loading = true);

    final userEmail = email.text.trim().toLowerCase();
    final userPassword = password.text.trim();

    if (userEmail.isEmpty || userPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password required")),
      );
      setState(() => loading = false);
      return;
    }

    try {
      print("Signup Email: $userEmail");
      print("Signup Password: $userPassword");

      final res = await Supabase.instance.client.auth.signUp(
        email: userEmail,
        password: userPassword,
      );

      if (res.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created! Please login.")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup failed. Try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Signup failed: $e")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : signup,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
