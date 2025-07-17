import 'package:driver_hire/color.dart';
import 'package:driver_hire/user/Booking/Booking_Screen.dart';
import 'package:driver_hire/user/Home/home_screen.dart';
import 'package:driver_hire/user/Profile/profile_screen.dart';
import 'package:flutter/material.dart';


class BottomBarScreen extends StatefulWidget {

  final int initialIndex;
  const BottomBarScreen({super.key, this.initialIndex = 0});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

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
