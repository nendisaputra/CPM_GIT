import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cpm_parking/services/api_service.dart';
import 'package:cpm_parking/screens/payment_screen.dart';

class ScanBookingScreen extends StatefulWidget {
  final bool isCheckout;
  const ScanBookingScreen({super.key, required this.isCheckout});

  @override
  State<ScanBookingScreen> createState() => _ScanBookingScreenState();
}

class _ScanBookingScreenState extends State<ScanBookingScreen> {
  MobileScannerController scannerController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(String code) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      if (widget.isCheckout) {
        final result = await ApiService.processCheckout(code);
        if (result['success'] == true) {
          if (!mounted) return;
          final paymentResult = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentScreen(
                bookingCode: code,
                totalPayment: result['total_payment'],
                sisaBayar: result['sisa_bayar'],
                paymentId: result['payment_id'],
              ),
            ),
          );
          if (paymentResult == true) {
            Navigator.pop(context, true);
          }
        } else {
          _showError(result['message'] ?? 'Check-out gagal');
        }
      } else {
        final result = await ApiService.checkIn(code);
        if (result['success'] == true) {
          _showSuccess('✅ Check-in berhasil! Portal terbuka.');
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context, true);
          });
        } else {
          _showError(result['message'] ?? 'Check-in gagal');
        }
      }
    } catch (e) {
      _showError('Terjadi kesalahan: $e');
    } finally {
      setState(() => _isProcessing = false);
      // 🔥 Mulai ulang kamera agar siap scan berikutnya
      scannerController.start();
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
    setState(() => _isProcessing = false);
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCheckout ? 'Scan Barcode Check-out' : 'Scan Barcode Check-in'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => scannerController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: () => scannerController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 4,
                child: MobileScanner(
                  controller: scannerController,
                  onDetect: (capture) {
                    final barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        _handleBarcode(barcode.rawValue!);
                        scannerController.stop(); // stop sementara saat proses
                        break;
                      }
                    }
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.isCheckout
                            ? 'Arahkan kamera ke QR Code booking'
                            : 'Scan QR Code booking untuk check-in',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _showManualInputDialog,
                        icon: const Icon(Icons.keyboard),
                        label: const Text('Masukkan Kode Manual'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // 🔥 Overlay loading
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  void _showManualInputDialog() {
    final codeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.isCheckout ? 'Masukkan Kode Booking' : 'Masukkan Kode Booking'),
        content: TextField(
          controller: codeCtrl,
          decoration: const InputDecoration(hintText: 'Contoh: BK-XXXXXXX'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleBarcode(codeCtrl.text.trim());
            },
            child: const Text('Proses'),
          ),
        ],
      ),
    );
  }
}