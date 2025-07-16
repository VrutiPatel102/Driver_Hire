import 'package:driver_hire/color.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          _logo(),
          SizedBox(height: 40),
          _welcomeText(),
          SizedBox(height: 20),
          _email(),
          SizedBox(height: 16),
          _pwdfield(),
          SizedBox(height: 10),
          _forgotPwd(),
          _loginbtn(),
          Spacer(),
          _regField(),
        ],
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

  Widget _email() {
    return TextField(
      controller: _emailController,
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

  Widget _pwdfield() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: 'Enter your password',
        filled: true,
        fillColor: AColor().grey100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AColor().green, width: 2),
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
          Navigator.pushNamed(context, AppRoute.forgotpassword);
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: AColor().Black),
        ),
      ),
    );
  }

  Widget _loginbtn() {
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
          Navigator.pushNamed(context, AppRoute.bottombar);
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
          Navigator.pushNamed(context, AppRoute.register);
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

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: AColor().White,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios, size: 16),
        padding: const EdgeInsets.only(
          left: 16,
          top: 13,
          right: 13,
          bottom: 13,
        ),
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
