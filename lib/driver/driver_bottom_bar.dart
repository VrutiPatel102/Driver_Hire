import 'package:driver_hire/color.dart';
import 'package:driver_hire/driver/Bookings/driver_booking_screen.dart';
import 'package:driver_hire/driver/Home/driver_home_screen.dart';
import 'package:driver_hire/driver/Profile/driver_profile_screen.dart';
import 'package:flutter/material.dart';


class DriverBottomBarScreen extends StatefulWidget {
  const DriverBottomBarScreen({super.key});

  @override
  State<DriverBottomBarScreen> createState() => _DriverBottomBarScreenState();
}

class _DriverBottomBarScreenState extends State<DriverBottomBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DriverHomeScreen(),
    const DriverBookingScreen(),
    const DriverProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AColor().Black,
        unselectedItemColor: AColor().Grey,
        showUnselectedLabels: true,
        backgroundColor: AColor().White,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
