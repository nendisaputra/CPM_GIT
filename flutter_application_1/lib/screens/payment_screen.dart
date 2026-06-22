import 'package:flutter/material.dart';
import 'package:cpm_parking/services/api_service.dart';

class PaymentScreen extends StatefulWidget {
  final String bookingCode;
  final int totalPayment;
  final int sisaBayar;
  final int paymentId;

  const PaymentScreen({
    super.key,
    required this.bookingCode,
    required this.totalPayment,
    required this.sisaBayar,
    required this.paymentId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;

  Future<void> _confirmPayment() async {
    setState(() => _isProcessing = true);
    final result = await ApiService.confirmFinalPayment(widget.paymentId);
    setState(() => _isProcessing = false);
    if (result['success'] == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('✅ Pembayaran Berhasil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text('Total bayar: Rp ${widget.totalPayment}'),
              Text('(DP Rp 5.000 + sisa Rp ${widget.sisaBayar})'),
              const SizedBox(height: 16),
              const Text('Portal terbuka. Silakan keluar.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Kembali ke floor detail dengan sinyal sukses
                Navigator.pop(context, true);
              },
              child: const Text('Selesai'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Pembayaran gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran Sisa')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Text('Booking: ${widget.bookingCode}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text('Total tagihan: Rp ${widget.totalPayment}', style: const TextStyle(fontSize: 18)),
                  Text('DP sudah dibayar: Rp 5.000', style: const TextStyle(color: Colors.green)),
                  Text('Sisa yang harus dibayar: Rp ${widget.sisaBayar}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 24),
                  const Text('Scan QRIS di bawah untuk membayar', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Icon(Icons.qr_code_scanner, size: 120, color: Colors.black54)),
                  ),
                  const SizedBox(height: 16),
                  const Text('(Simulasi QRIS - klik tombol di bawah)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _confirmPayment,
                    icon: _isProcessing
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.payment),
                    label: const Text('Konfirmasi Pembayaran'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}