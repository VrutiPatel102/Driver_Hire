import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_hire/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DriverPersonalDataScreen extends StatefulWidget {
  const DriverPersonalDataScreen({super.key});

  @override
  State<DriverPersonalDataScreen> createState() => _DriverPersonalDataScreenState();
}

class _DriverPersonalDataScreenState extends State<DriverPersonalDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _genderList = ['Male', 'Female', 'Other'];
  String _selectedGender = 'Male';
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final RegExp _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  @override
  void initState() {
    super.initState();
    _loadDriverData();
  }

  void _loadDriverData() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) return;

    final doc = await FirebaseFirestore.instance.collection('drivers').doc(userEmail).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _selectedGender = data['gender'] ?? 'Male';
          _phoneController.text = data['phone'] ?? '';
        });
      }
    }
  }

  void _showCustomToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final textWidth = (message.length * 8.0).clamp(
      100.0,
      MediaQuery.of(context).size.width * 0.8,
    );

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 150,
        left: (MediaQuery.of(context).size.width - textWidth) / 2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AColor().grey300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(color: AColor().Black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      try {
        String formattedDate = DateFormat('dd-MM-yyyy – hh:mm a').format(DateTime.now());
        final userEmail = FirebaseAuth.instance.currentUser?.email;

        if (userEmail != null) {
          await FirebaseFirestore.instance.collection('drivers').doc(userEmail).update({
            'name': _nameController.text.trim(),
            'gender': _selectedGender,
            'phone': _phoneController.text.trim(),
            'email': _emailController.text.trim(),
            'saved_at': formattedDate,
          });

          _showCustomToast(context, "Data saved successfully");
        }
      } catch (e) {
        _showCustomToast(context, "Error: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: AppBar(
        backgroundColor: AColor().White,
        elevation: 0,
        title: const Text("Personal Data"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AColor().Black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: IconThemeData(color: AColor().Black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Name", "Enter Name", _nameController, (value) {
                if (value == null || value.isEmpty) return "Name is required.";
                return null;
              }),
              const SizedBox(height: 16),
              _buildTextField("Email", "Enter Email", _emailController, (value) {
                if (value == null || value.isEmpty) return "Email is required.";
                if (!_emailRegex.hasMatch(value)) return "Enter a valid email address.";
                return null;
              }),
              const SizedBox(height: 16),
              _buildGenderDropdown(),
              const SizedBox(height: 16),
              _buildTextField("Phone", "Enter Phone Number", _phoneController, (value) {
                if (value == null || value.isEmpty) return "Phone number is required.";
                if (value.length != 10) return "Phone number must be 10 digits.";
                return null;
              }),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AColor().green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller,
      String? Function(String?) validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: AColor().grey300,
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AColor().green, width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gender"),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          items: _genderList.map((gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AColor().grey300,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AColor().green, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
