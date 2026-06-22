import 'package:flutter/material.dart';
import 'package:cpm_parking/services/api_service.dart';

class CheckoutScreen extends StatefulWidget {
  final String bookingCode;
  const CheckoutScreen({super.key, required this.bookingCode});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _loading = false;
  int _totalPayment = 0;
  bool _checkedOut = false;

  Future<void> _checkOut() async {
    setState(() => _loading = true);
    final result = await ApiService.checkOut(widget.bookingCode);
    setState(() => _loading = false);
    if (result['success'] == true) {
      setState(() {
        _totalPayment = result['total_payment'];
        _checkedOut = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Gagal'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-out')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Booking Code: ${widget.bookingCode}'),
          const SizedBox(height: 20),
          if (!_checkedOut)
            ElevatedButton(
              onPressed: _loading ? null : _checkOut,
              child: _loading ? const CircularProgressIndicator() : const Text('Hitung & Check-out'),
            )
          else
            Column(children: [
              Text('Total Pembayaran: Rp $_totalPayment', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Simulasi QRIS / pembayaran
                  showDialog(context: context, builder: (_) => AlertDialog(
                    title: const Text('Pembayaran QRIS'),
                    content: const Text('Silakan scan QRIS untuk membayar'),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))],
                  ));
                },
                icon: const Icon(Icons.qr_code),
                label: const Text('Bayar via QRIS'),
              ),
            ]),
        ]),
      ),
    );
  }
}