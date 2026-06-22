import 'package:flutter/material.dart';
import 'package:cpm_parking/services/api_service.dart';

class CheckinScreen extends StatefulWidget {
  final String bookingCode;
  const CheckinScreen({super.key, required this.bookingCode});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  bool _loading = false;

  Future<void> _checkIn() async {
    setState(() => _loading = true);
    final result = await ApiService.checkIn(widget.bookingCode);
    setState(() => _loading = false);
    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Check-in berhasil, portal terbuka. Silakan parkir.')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['message'] ?? 'Gagal check-in'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-in')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Booking Code: ${widget.bookingCode}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _checkIn,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Konfirmasi Check-in'),
            ),
          ],
        ),
      ),
    );
  }
}