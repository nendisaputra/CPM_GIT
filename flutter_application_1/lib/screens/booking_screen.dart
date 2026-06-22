import 'package:flutter/material.dart';
import 'package:cpm_parking/services/api_service.dart';
import 'package:cpm_parking/screens/dp_payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final int slotId;
  final String slotCode;
  const BookingScreen({super.key, required this.slotId, required this.slotCode});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _platCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _createBooking() async {
    if (_platCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan plat nomor')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final userId = await ApiService.getUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session habis, silakan login ulang')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final result = await ApiService.createBooking(userId, widget.slotId, 5000);
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      final bookingId = result['booking']['id'];
      final bookingCode = result['booking']['booking_code'];

      final success = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DpPaymentScreen(
            bookingId: bookingId,
            bookingCode: bookingCode,
            amount: 5000,
          ),
        ),
      );

      if (success == true) {
        Navigator.pop(context, true); // Kembali ke floor detail dengan refresh
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal booking'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Slot ${widget.slotCode}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _platCtrl,
              decoration: const InputDecoration(
                labelText: 'Plat Nomor',
                prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Booking Sekarang (DP 5000)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}