import 'package:driver_hire/Address_Pickup_drop/location_picker.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class BookDriverScreen extends StatefulWidget {
  const BookDriverScreen({super.key});

  @override
  State<BookDriverScreen> createState() => _BookDriverScreenState();
}

class _BookDriverScreenState extends State<BookDriverScreen> {
  TextEditingController pickUpController = TextEditingController();
  TextEditingController reachController = TextEditingController();

  GeoPoint? point1;
  GeoPoint? point2;
  String selectedTripType = 'Round trip';
  String selectedCarType = 'SUV';

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String pickupAddress = '';
  String reachPlace = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: _buildAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Book a driver',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            const Text(
              'Please Select your Trip type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _tripTypeButton('One way'),
                const SizedBox(width: 16),
                _tripTypeButton('Round trip'),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Select Car Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _carTypeOption('Sedan', 'assets/image 1.png'),
                _carTypeOption('EV', 'assets/image 2.png'),
                _carTypeOption('SUV', 'assets/image 3.png'),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              "Pickup & Destination",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      var result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LocationPicker(
                            initialLatitude: 23.0273,
                            initialLongitude: 72.5607,
                          ),
                        ),
                      );

                      if (result != null && result is Map) {
                        point1 = GeoPoint(
                          latitude: result['lat'],
                          longitude: result['lng'],
                        );
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
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      var result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LocationPicker(
                            initialLatitude: 23.0273,
                            initialLongitude: 72.5607,
                          ),
                        ),
                      );

                      if (result != null && result is Map) {
                        point2 = GeoPoint(
                          latitude: result['lat'],
                          longitude: result['lng'],
                        );
                        reachController.text = result['address'] ?? '';
                        setState(() {});
                      }

                    },
                    child: TextField(
                      enabled: false,
                      controller: reachController,
                      decoration: InputDecoration(
                        hintText: "Reach Place",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Date & Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _iconInputField(
                    Icons.calendar_today,
                    _getDateText(),
                    _selectDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _iconInputField(
                    Icons.access_time,
                    _getTimeText(),
                    _selectTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AColor().Black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoute.waitingDriver,
                    arguments: {
                      'pickupAddress': pickUpController.text,
                      'dropAddress': reachController.text,
                      'date': _getDateText(),
                      'time': _getTimeText(),
                      'carType': selectedCarType,
                      'rideType': selectedTripType,
                    },
                  );
                },
                child: Text(
                  'Next',
                  style: TextStyle(color: AColor().White, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// === Trip Type ===
  Widget _tripTypeButton(String type) {
    bool isSelected = selectedTripType == type;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTripType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AColor().Black : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                color: isSelected ? AColor().White : AColor().Black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// === Car Type ===
  Widget _carTypeOption(String type, String iconPath) {
    bool isSelected = selectedCarType == type;
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(iconPath),
        ),
        Row(
          children: [
            Checkbox(
              activeColor: AColor().White,
              checkColor: AColor().green,
              value: isSelected,
              onChanged: (val) {
                setState(() {
                  selectedCarType = type;
                });
              },
            ),
            Text(type),
          ],
        ),
      ],
    );
  }

  /// === Date Picker ===
  Widget _iconInputField(IconData icon, String hint, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(hint, style: const TextStyle(fontSize: 16))),
          ],
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AColor().green,
              onPrimary: Colors.white,
              onSurface: AColor().Black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AColor().green),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AColor().green,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AColor().Black,
              secondary: AColor().green,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AColor().green),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  /// === AppBar ===
  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: AColor().White,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios, size: 16),
        padding: const EdgeInsets.only(
          top: 13,
          bottom: 13,
          left: 16,
          right: 12,
        ),
        style: IconButton.styleFrom(
          backgroundColor: AColor().green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
