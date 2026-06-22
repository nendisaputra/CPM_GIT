import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cpm_parking/services/api_service.dart';
import 'package:cpm_parking/models/parking_slot.dart';
import 'package:cpm_parking/screens/booking_screen.dart';
import 'package:cpm_parking/screens/checkin_screen.dart';
import 'package:cpm_parking/screens/scan_booking_screen.dart';

class FloorDetailScreen extends StatefulWidget {
  final int floorId;
  final String floorName;
  const FloorDetailScreen(
      {super.key, required this.floorId, required this.floorName});

  @override
  State<FloorDetailScreen> createState() => _FloorDetailScreenState();
}

class _FloorDetailScreenState extends State<FloorDetailScreen> {
  List<ParkingSlot> _slots = [];
  bool _loading = true;
  List<dynamic> _myBookings = [];
  Timer? _timer; // <-- Timer untuk cek expired otomatis

  @override
  void initState() {
    super.initState();
    _loadData();
    // Jalankan _loadData setiap 30 detik untuk cek booking expired
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hentikan timer saat widget dihapus
    super.dispose();
  }

  Future<void> _loadData() async {
    final start = DateTime.now();
    print('⏳ _loadData mulai di FloorDetailScreen');
    if (!mounted) return;
    setState(() => _loading = true);

    try {
      final userId = await ApiService.getUserId();
      print('🆔 userId: $userId');
      bool needReload = false;

      if (userId != null) {
        try {
          _myBookings = await ApiService.getMyBookings(userId);
          print('📦 Jumlah booking: ${_myBookings.length}');

          for (var booking in _myBookings) {
            // Cek booking dengan status 'active' atau 'pending_dp' (belum check-in)
            if (booking['status'] == 'active' ||
                booking['status'] == 'pending_dp') {
              DateTime? createdAt;
              try {
                createdAt = DateTime.parse(booking['created_at']);
              } catch (e) {
                createdAt =
                    DateTime.tryParse(booking['created_at']?.toString() ?? '');
              }
              // Jika sudah lebih dari 1 menit, batalkan
              if (createdAt != null &&
                  DateTime.now().difference(createdAt).inMinutes > 1) {
                print('⏰ Booking ${booking['id']} expired, batalkan...');
                try {
                  final result = await ApiService.cancelBooking(booking['id']);
                  if (result['success'] == true)
                    needReload = true;
                  else
                    print('⚠️ Gagal batalkan: ${result['message']}');
                } catch (e) {
                  print('⚠️ Exception saat cancel: $e');
                }
              }
            }
          }

          if (needReload) {
            _myBookings = await ApiService.getMyBookings(userId);
          }
        } catch (e) {
          _myBookings = [];
          print('❌ Gagal ambil booking: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal ambil booking: $e')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Sesi tidak ditemukan, silakan login ulang')),
          );
        }
      }

      // Ambil data slot
      print('⏳ Mengambil data slot untuk floorId: ${widget.floorId}');
      final data = await ApiService.getSlotsByFloor(widget.floorId);
      print('📦 Data slot diterima: ${data.length} slot');

      if (mounted) {
        setState(() {
          _slots = data.map((json) => ParkingSlot.fromJson(json)).toList();
          _loading = false;
        });
        // DEBUG: Cetak status slot
        print('📌 Status slot setelah load:');
        for (var s in _slots) {
          print('  ${s.kodeSlot} → ${s.status}');
        }
      }

      final end = DateTime.now();
      print(
          '✅ _loadData selesai dalam ${end.difference(start).inMilliseconds} ms');
    } catch (e, stack) {
      print('❌ Error di _loadData: $e');
      print(stack);
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data lantai: $e')),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'booked':
        return Colors.blue;
      case 'occupied':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'available':
        return 'Tersedia';
      case 'booked':
        return 'Dipesan';
      case 'occupied':
        return 'Terisi';
      default:
        return status;
    }
  }

  String? _getActiveBookingCode(int slotId) {
    try {
      final booking = _myBookings.firstWhere(
        (b) => b['slot_id'] == slotId && b['status'] == 'active',
        orElse: () => null,
      );
      return booking?['booking_code'] as String?;
    } catch (e) {
      return null;
    }
  }

  String? _getCheckedInBookingCode(int slotId) {
    try {
      final booking = _myBookings.firstWhere(
        (b) => b['slot_id'] == slotId && b['status'] == 'checked_in',
        orElse: () => null,
      );
      return booking?['booking_code'] as String?;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.floorName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _slots.isEmpty
                ? const Center(child: Text('Tidak ada slot di lantai ini'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _slots.length,
                    itemBuilder: (context, i) {
                      final slot = _slots[i];
                      final color = _getStatusColor(slot.status);
                      final isAvailable = slot.status == 'available';
                      final isBooked = slot.status == 'booked';
                      final isOccupied = slot.status == 'occupied';

                      final activeCode = _getActiveBookingCode(slot.id);
                      final checkedInCode = _getCheckedInBookingCode(slot.id);

                      final isMyBooked = isBooked && activeCode != null;
                      final isMyOccupied = isOccupied && checkedInCode != null;

                      return Card(
                        color: color.withOpacity(0.1),
                        child: InkWell(
                          onTap: () async {
                            if (isAvailable) {
                              final userId = await ApiService.getUserId();
                              if (userId != null) {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookingScreen(
                                      slotId: slot.id,
                                      slotCode: slot.kodeSlot,
                                    ),
                                  ),
                                );
                                if (result == true) _loadData();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Silakan login ulang')),
                                );
                              }
                            } else if (isMyBooked) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CheckinScreen(bookingCode: activeCode!),
                                ),
                              );
                              if (result == true) _loadData();
                            } else if (isMyOccupied) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ScanBookingScreen(isCheckout: true),
                                ),
                              );
                              if (result == true) _loadData();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Slot sedang ${_getStatusLabel(slot.status)}'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.local_parking, color: color, size: 40),
                              const SizedBox(height: 8),
                              Text(slot.kodeSlot,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  _getStatusLabel(slot.status).toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                              if (isAvailable)
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Ketuk untuk booking',
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.green),
                                  ),
                                ),
                              if (isMyBooked)
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Ketuk untuk check-in',
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.blue),
                                  ),
                                ),
                              if (isMyOccupied)
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Ketuk untuk keluar & bayar',
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.red),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
