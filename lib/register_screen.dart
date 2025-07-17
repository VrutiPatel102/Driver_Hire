import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: AColor().White,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios, size: 16),
        padding: const EdgeInsets.all(13),
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AColor().Black),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _logo(),
            SizedBox(height: 20),
            _welcomeText(),
            SizedBox(height: 15),
            _usernameField(),
            SizedBox(height: 14),
            _emailField(),
            SizedBox(height: 14),
            _passwordField(),
            SizedBox(height: 14),
            _confirmPasswordField(),
            SizedBox(height: 20),
            _registerBtn(),
            Spacer(),
            _loginLink(),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.black12,
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        child: Image.asset("assets/appIcon.png"),
      ),
    );
  }

  Widget _welcomeText() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Hello!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AColor().green,
            ),
          ),
          TextSpan(
            text: ' Register to get started',
            style: TextStyle(fontSize: 28, color: AColor().Black),
          ),
        ],
      ),
    );
  }

  Widget _usernameField() {
    return TextFormField(
      controller: _nameController,
      decoration: _inputDecoration('User name'),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Username is required';
        }
        return null;
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: _inputDecoration('Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: _inputDecoration(
        'Enter your password',
        suffix: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: _inputDecoration(
        'Confirm password',
        suffix: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _registerBtn() {
    return SizedBox(
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
          if (_formKey.currentState!.validate()) {
            Navigator.pushNamed(context, AppRoute.chooseScreen);
          }
        },
        child: Text(
          'Register',
          style: TextStyle(color: AColor().White, fontSize: 18),
        ),
      ),
    );
  }

  Widget _loginLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Have an account? ',
                style: TextStyle(color: AColor().Black),
              ),
              TextSpan(
                text: 'Login Now',
                style: TextStyle(
                  color: AColor().green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AColor().grey100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AColor().green),
      ),
      suffixIcon: suffix,
    );
  }
}
