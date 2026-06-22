import 'package:flutter/material.dart';
import 'package:cpm_parking/screens/login_screen.dart';
import 'package:cpm_parking/screens/dashboard_screen.dart';
import 'package:cpm_parking/screens/register_screen.dart';
import 'package:cpm_parking/screens/floor_detail_screen.dart';
import 'package:cpm_parking/screens/booking_screen.dart';
import 'package:cpm_parking/screens/my_bookings_screen.dart';
import 'package:cpm_parking/screens/checkin_screen.dart';
import 'package:cpm_parking/screens/checkout_screen.dart';
import 'package:cpm_parking/services/api_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CPM Parking',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: FutureBuilder<int?>(
        future: ApiService.getUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.data != null) {
            return const DashboardScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/register': (context) => const RegisterScreen(),
        '/floor': (context) => FloorDetailScreen(
          floorId: ModalRoute.of(context)!.settings.arguments as int,
          floorName: '',
        ),
        '/booking': (context) => BookingScreen(
          slotId: ModalRoute.of(context)!.settings.arguments as int,
          slotCode: '',
        ),
        '/mybookings': (context) => const MyBookingsScreen(),
        '/checkin': (context) => CheckinScreen(
          bookingCode: ModalRoute.of(context)!.settings.arguments as String,
        ),
        '/checkout': (context) => CheckoutScreen(
          bookingCode: ModalRoute.of(context)!.settings.arguments as String,
        ),
      },
    );
  }
}