import 'package:flutter/material.dart';
import 'package:cpm_parking/services/api_service.dart';
import 'package:cpm_parking/screens/checkin_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<dynamic> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final userId = await ApiService.getUserId();
    if (userId != null) {
      final bookings = await ApiService.getMyBookings(userId);
      setState(() {
        _bookings = bookings;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  String _statusText(String status) {
    switch (status) {
      case 'pending_dp': return 'Menunggu DP';
      case 'active': return 'Aktif (Belum Check-in)';
      case 'checked_in': return 'Sedang Parkir';
      case 'completed': return 'Selesai';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Booking Saya')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? const Center(child: Text('Belum ada booking'))
              : ListView.builder(
                  itemCount: _bookings.length,
                  itemBuilder: (ctx, i) {
                    final b = _bookings[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text('Kode: ${b['booking_code']}'),
                        subtitle: Text('Slot: ${b['slot']['kode_slot']} | Status: ${_statusText(b['status'])}'),
                        trailing: b['status'] == 'active'
                            ? ElevatedButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CheckinScreen(bookingCode: b['booking_code']))),
                                child: const Text('Check-in'),
                              )
                            : null,
                      ),
                    );
                  },
                ),
    );
  }
}