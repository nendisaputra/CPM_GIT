import 'package:flutter/material.dart';
import 'package:cpm_parking/services/api_service.dart';
import 'package:cpm_parking/screens/register_screen.dart';
import 'package:cpm_parking/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  List<String> _suggestedEmails = [];

  @override
  void initState() {
    super.initState();
    _loadLastEmail();
  }

  Future<void> _loadLastEmail() async {
    final lastEmail = await ApiService.getLastEmail();
    if (lastEmail != null) {
      _emailCtrl.text = lastEmail;
      // Ambil daftar email dari SharedPreferences (opsional)
      // Untuk demo, kita simpan satu email terakhir
    }
  }

  void _login() async {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email dan password wajib diisi')));
      return;
    }
    setState(() => _isLoading = true);
    final result = await ApiService.login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    setState(() => _isLoading = false);
    if (result['success'] == true) {
      await ApiService.saveUserId(result['user']['id']);
      await ApiService.saveUserData(result['user']);
      await ApiService.saveLastEmail(_emailCtrl.text.trim()); // Simpan email
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Login gagal'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3F51B5)])),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const SizedBox(height: 40),
              const Icon(Icons.local_parking, size: 60, color: Colors.white),
              const SizedBox(height: 12),
              const Text('CPM', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const Text('Car Parking Monitoring', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 40),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(children: [
                    TextField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      // Tampilkan suggestion jika ada email tersimpan
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscure = !_obscure)
                        )
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51B5),
                          padding: const EdgeInsets.symmetric(vertical: 14)
                        ),
                        child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Masuk', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      child: const Text('Belum punya akun? Daftar'),
                    ),
                  ]),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}