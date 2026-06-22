import 'package:flutter/material.dart';
import 'package:cpm_parking/services/api_service.dart';
import 'package:cpm_parking/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;

  void _register() async {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty || _passCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua field wajib diisi')));
      return;
    }
    setState(() => _isLoading = true);
    final result = await ApiService.register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
      _phoneCtrl.text.trim(),
      _plateCtrl.text.trim(),
    );
    setState(() => _isLoading = false);
    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil, silakan login')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Gagal'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nama Lengkap', prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 12),
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
            const SizedBox(height: 12),
            TextField(controller: _passCtrl, obscureText: _obscure, decoration: InputDecoration(
              labelText: 'Password', prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscure = !_obscure))
            )),
            const SizedBox(height: 12),
            TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'No. HP', prefixIcon: Icon(Icons.phone))),
            const SizedBox(height: 12),
            TextField(controller: _plateCtrl, decoration: const InputDecoration(labelText: 'Plat Nomor', prefixIcon: Icon(Icons.credit_card))),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: _isLoading ? null : _register,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Daftar'),
            )),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kembali ke Login')),
          ]),
        ),
      ),
    );
  }
}