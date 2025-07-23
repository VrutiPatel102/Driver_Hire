import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoginScreen extends StatefulWidget {
  final String loginAs;

  const LoginScreen({super.key, required this.loginAs});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: _buildAppbar(),
      body: _buildBody(),
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
            SizedBox(height: 40),
            _logo(),
            SizedBox(height: 40),
            _welcomeText(),
            SizedBox(height: 20),
            _emailField(),
            SizedBox(height: 16),
            _passwordField(),
            SizedBox(height: 10),
            _forgotPwd(),
            _loginButton(),
            Spacer(),
            _regField(),
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
            text: 'Welcome back!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AColor().green,
            ),
          ),
          TextSpan(
            text: ' Glad to see you, Again!',
            style: TextStyle(fontSize: 28, color: AColor().Black),
          ),
        ],
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }
        final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Enter your email',
        filled: true,
        fillColor: AColor().grey100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AColor().green),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }

        final passwordRegex = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~%^()_+={}\[\]:;<>,.?/-]).{8,}$',
        );

        if (!passwordRegex.hasMatch(value)) {
          return 'Password must contain uppercase, lowercase, number, and special character';
        }
        return null;
      },
      decoration: InputDecoration(
        errorMaxLines: 3,
        hintText: 'Password',
        filled: true,
        fillColor: AColor().grey100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AColor().green),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  Widget _forgotPwd() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.forgotPassword);
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: AColor().Black),
        ),
      ),
    );
  }

  Widget _loginButton() {
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
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );

              final user = userCredential.user;

              if (user != null) {
                final String selectedRole = widget.loginAs;
                final String correctCollection = selectedRole == 'driver' ? 'drivers' : 'users';

                final DocumentSnapshot userDoc = await FirebaseFirestore.instance
                    .collection(correctCollection)
                    .doc(user.email!.trim())
                    .get();

                if (!userDoc.exists) {
                  await FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'You are not registered as a $selectedRole. Please login with the correct role.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final formattedLoginTime =
                DateFormat('dd-MM-yyyy – hh:mm a').format(DateTime.now());

                await FirebaseFirestore.instance
                    .collection(correctCollection)
                    .doc(_emailController.text.trim())
                    .set({
                  'email': user.email,
                  'uid': user.uid,
                  'loginAt': formattedLoginTime,
                }, SetOptions(merge: true));

                _showCustomToast("Login successful");

                Navigator.pushNamed(
                  context,
                  selectedRole == 'user' ? AppRoute.bottombar : AppRoute.driverBottombar,
                );
              }
            } on FirebaseAuthException catch (e) {
              _showCustomToast(e.message ?? 'Login failed');
            }
          }
        },
        child: Text(
          'Login',
          style: TextStyle(color: AColor().White, fontSize: 18),
        ),
      ),
    );
  }

  Widget _regField() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoute.register,
            arguments: widget.loginAs,
          );
        },
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Don’t have an account? ',
                style: TextStyle(color: AColor().Black),
              ),
              TextSpan(
                text: 'Register Now',
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
  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: AColor().White,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios, size: 16),
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
}
