import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_hire/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DriverPersonalDataScreen extends StatefulWidget {
  const DriverPersonalDataScreen({super.key});

  @override
  State<DriverPersonalDataScreen> createState() => _DriverPersonalDataScreenState();
}

class _DriverPersonalDataScreenState extends State<DriverPersonalDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _selectedGender = 'Male';

  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp _phoneRegex = RegExp(r'^[0-9]{10}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildForm(),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Personal Data", style: TextStyle(color: AColor().Black)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AColor().Black),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
        // bottom padding for button spacing
        children: [
          _buildProfileAvatar(),
          SizedBox(height: 24),
          _buildTextField("Full Name", "Enter Name", _nameController, (value) {
            if (value == null || value.isEmpty) return "Name is required.";
            return null;
          }),
          SizedBox(height: 16),
          _buildGenderDropdown(),
          SizedBox(height: 16),
          _buildTextField(
            "Phone number",
            "Enter Mobile Number",
            _phoneController,
                (value) {
              if (value == null || value.isEmpty)
                return "Mobile Number is required.";
              if (!_phoneRegex.hasMatch(value))
                return "Enter a valid 10-digit number.";
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildTextField("Email", "Enter Email", _emailController, (value) {
            if (value == null || value.isEmpty) return "Email is required.";
            if (!_emailRegex.hasMatch(value))
              return "Enter a valid email address.";
            return null;
          }),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFFF5F5F5),
            child: Icon(Icons.person, size: 40, color: Colors.grey),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AColor().green,
              child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      TextEditingController controller,
      String? Function(String?) validator,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: AColor().grey300,
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none, // default border
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AColor().green,
                width: 2,
              ), // green when focused
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
        Text("Gender"),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          items: ['Male', 'Female', 'Other']
              .map(
                (gender) =>
                DropdownMenuItem(value: gender, child: Text(gender)),
          )
              .toList(),
          onChanged: (value) => setState(() => _selectedGender = value!),
          decoration: InputDecoration(
            filled: true,
            fillColor: AColor().grey300,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none
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

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 50),
      color: AColor().White,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AColor().Black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Save",
            style: TextStyle(fontSize: 20, color: AColor().White),
          ),
        ),
      ),
    );
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      try {
        String formattedDate = DateFormat('dd-MM-yyyy – hh:mm a').format(DateTime.now());

        await FirebaseFirestore.instance.collection('drivers').add({
          'name': _nameController.text.trim(),
          'gender': _selectedGender,
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'saved_at': formattedDate,
        });

        _showCustomToast("Data saved successfully");
      } catch (e) {
        _showCustomToast("Error: ${e.toString()}");
      }
    }
  }

  void _showCustomToast(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 150,
        left: MediaQuery.of(context).size.width * 0.5 - (message.length * 4.0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AColor().grey300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(message, style: TextStyle(color: AColor().Black)),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 2)).then((_) => overlayEntry.remove());
  }
}
