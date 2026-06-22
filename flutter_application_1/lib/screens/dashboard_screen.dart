import 'package:flutter/material.dart';
import 'package:cpm_parking/services/api_service.dart';
import 'package:cpm_parking/screens/floor_detail_screen.dart';
import 'package:cpm_parking/screens/my_bookings_screen.dart';
import 'package:cpm_parking/screens/scan_booking_screen.dart'; // <-- import screen scan
import 'package:cpm_parking/screens/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> _floors = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFloors();
  }

  Future<void> _loadFloors() async {
    final floors = await ApiService.getFloors();
    setState(() {
      _floors = floors;
      _loading = false;
    });
  }

  void _logout() async {
  await ApiService.clearSession();
  if (mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}

  void _showScanOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.login, color: Colors.green),
              title: const Text('Check-in (Buka Portal)'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ScanBookingScreen(isCheckout: false),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Check-out & Bayar'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ScanBookingScreen(isCheckout: true),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CPM Dashboard'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      drawer: Drawer(
        child: ListView(children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Text('CPM Parking',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.local_parking),
            title: const Text('Semua Lantai'),
            onTap: () => Navigator.pop(context),
          ),
          ..._floors.map((floor) => ListTile(
                title: Text(floor['name']),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FloorDetailScreen(
                          floorId: floor['id'], floorName: floor['name']),
                    ),
                  );
                },
              )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Riwayat Booking'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
              );
            },
          ),
        ]),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _floors.length,
              itemBuilder: (context, i) {
                final floor = _floors[i];
                final totalSlots = floor['slots'].length;
                final available = floor['slots']
                    .where((s) => s['status'] == 'available')
                    .length;
                return Card(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FloorDetailScreen(
                            floorId: floor['id'], floorName: floor['name']),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(floor['name'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            'Tersedia: $available / $totalSlots',
                            style: TextStyle(
                                color: available > 0 ? Colors.green : Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      // TAMBAHKAN FLOATING ACTION BUTTON UNTUK SCAN QR
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showScanOptions,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan QR'),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}