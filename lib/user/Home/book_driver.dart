import 'package:driver_hire/Address_Pickup_drop/location_picker.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;
import 'package:intl/intl.dart';

class BookDriverScreen extends StatefulWidget {
  const BookDriverScreen({super.key});

  @override
  State<BookDriverScreen> createState() => _BookDriverScreenState();
}

class _BookDriverScreenState extends State<BookDriverScreen> {
  TextEditingController pickUpController = TextEditingController();
  TextEditingController reachController = TextEditingController();

  osm.GeoPoint? point1;
  osm.GeoPoint? point2;

  String selectedTripType = 'Round trip';
  String selectedCarType = 'SUV';

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  double estimatedFare = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: _buildAppbar(),
      body: _builBody(),
    );
  }

  Widget _builBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book a driver', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 25),
            Text('Please Select your Trip type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(children: [_tripTypeButton('One way'), SizedBox(width: 16), _tripTypeButton('Round trip')]),
            SizedBox(height: 40),
            Text('Select Car Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _carTypeOption('Sedan', 'assets/image 1.png'),
              _carTypeOption('EV', 'assets/image 2.png'),
              _carTypeOption('SUV', 'assets/image 3.png'),
            ]),
            SizedBox(height: 40),
            Text("Pickup & Destination", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(children: [_pickupAddress(), SizedBox(width: 20), _dropAddress()]),
            SizedBox(height: 20),
            Text("Date & Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(children: [
              Expanded(child: _iconInputField(Icons.calendar_today, _getDateText(), _selectDate)),
              SizedBox(width: 12),
              Expanded(child: _iconInputField(Icons.access_time, _getTimeText(), _selectTime)),
            ]),
            SizedBox(height: 20),
            _nextBtn(),
          ],
        ),
      ),
    );
  }

  Widget _nextBtn() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AColor().Black,
          padding: EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () async {
          if (pickUpController.text.isEmpty ||
              reachController.text.isEmpty ||
              selectedDate == null ||
              selectedTime == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all required fields")));
            return;
          }

          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not logged in")));
              return;
            }

            final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate!);
            final formattedTime = _getTimeText();
            final userEmail = user.email!;
            final timestamp = firestore.Timestamp.now();

            final bookingData = {
              'pickupAddress': pickUpController.text,
              'dropAddress': reachController.text,
              'date': formattedDate,
              'time': formattedTime,
              'carType': selectedCarType,
              'rideType': selectedTripType,
              'saved_at': timestamp,
              'fare': estimatedFare,
              'status': 'pending',
              'user_email': userEmail,
            };

            final bookingRef = await firestore.FirebaseFirestore.instance
                .collection('bookings')
                .add(bookingData);

            await firestore.FirebaseFirestore.instance
                .collection('users')
                .doc(userEmail)
                .collection('bookings')
                .doc(bookingRef.id)
                .set(bookingData);


            Navigator.pushNamed(
              context,
              AppRoute.waitingDriver,
              arguments: {
                ...bookingData,
                'bookingId': bookingRef.id,
              },
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to book: $e")));
          }
        },
        child: Text('Next', style: TextStyle(color: AColor().White, fontSize: 18)),
      ),
    );
  }

  Widget _dropAddress() {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LocationPicker(initialLatitude: 23.0273, initialLongitude: 72.5607),
          ));
          if (result is Map) {
            point2 = osm.GeoPoint(latitude: result['lat'], longitude: result['lng']);
            reachController.text = result['address'] ?? '';
            setState(() {});
          }
        },
        child: TextField(
          enabled: false,
          controller: reachController,
          decoration: InputDecoration(
            hintText: "Drop Address",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          ),
        ),
      ),
    );
  }

  Widget _pickupAddress() {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LocationPicker(initialLatitude: 23.0273, initialLongitude: 72.5607),
          ));
          if (result is Map) {
            point1 = osm.GeoPoint(latitude: result['lat'], longitude: result['lng']);
            pickUpController.text = result['address'] ?? '';
            setState(() {});
          }
        },
        child: TextField(
          enabled: false,
          controller: pickUpController,
          decoration: InputDecoration(
            hintText: "PickUp Address",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          ),
        ),
      ),
    );
  }

  Widget _tripTypeButton(String type) {
    final isSelected = selectedTripType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedTripType = type),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AColor().Black : AColor().grey200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(type, style: TextStyle(color: isSelected ? AColor().White : AColor().Black, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _carTypeOption(String type, String iconPath) {
    final isSelected = selectedCarType == type;
    return Column(
      children: [
        CircleAvatar(radius: 30, backgroundColor: Colors.transparent, backgroundImage: AssetImage(iconPath)),
        Row(
          children: [
            Checkbox(
              activeColor: AColor().White,
              checkColor: AColor().green,
              value: isSelected,
              onChanged: (_) => setState(() => selectedCarType = type),
            ),
            Text(type),
          ],
        ),
      ],
    );
  }

  Widget _iconInputField(IconData icon, String hint, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [Icon(icon, size: 18), SizedBox(width: 8), Expanded(child: Text(hint, style: TextStyle(fontSize: 16)))],
        ),
      ),
    );
  }

  String _getDateText() {
    if (selectedDate == null) return 'Select Date';
    return '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
  }

  String _getTimeText() {
    if (selectedTime == null) return 'Select Time';
    final hour = selectedTime!.hour.toString().padLeft(2, '0');
    final minute = selectedTime!.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: AColor().green, onPrimary: Colors.white, onSurface: AColor().Black),
          textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AColor().green)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: AColor().green, onPrimary: Colors.white, onSurface: AColor().Black),
          textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AColor().green)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: AColor().White,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: 16),
        padding: EdgeInsets.only(top: 13, bottom: 13, left: 16, right: 12),
        style: IconButton.styleFrom(
          backgroundColor: AColor().green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.transparent)),
        ),
      ),
    );
  }
}
