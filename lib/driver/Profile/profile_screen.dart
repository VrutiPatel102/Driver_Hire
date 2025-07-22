import 'package:driver_hire/choose_driverORuser.dart';
import 'package:driver_hire/color.dart';
import 'package:driver_hire/login_screen.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:driver_hire/register_screen.dart';
import 'package:flutter/material.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          "Profile Setting",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        _buildProfileAvatar(),
        SizedBox(height: 10),
        Text(
          "Albert Stevano Bajefski",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 30),
        _buildSectionTitle("Profile"),
        _buildMenuItem(Icons.person, "Personal Data", () {
          Navigator.pushNamed(context, AppRoute.personalData);
        }),
        _buildMenuItem(Icons.settings, "Settings", () {
          Navigator.pushNamed(context, AppRoute.setting);
        }),
        SizedBox(height: 20),
        _buildSectionTitle("Support"),
        _buildMenuItem(Icons.delete_outline, "Request Account Deletion", () {
          showDialog(
            context: context,
            builder: (context) => _buildDeleteAccountDialog(context),
          );
        }),

        Spacer(),
        _buildSignOutButton(context),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return CircleAvatar(
      radius: 45,
      backgroundColor: Color(0xFFF5F5F5),
      child: Icon(Icons.person, size: 40, color:AColor().Grey),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AColor().green100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AColor().green),
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => _buildSignOutDialog(context),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AColor().Black,
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          height: 55,
          child:  Center(
            child: Text(
              "Sign Out",
              style: TextStyle(fontSize: 20, color:AColor().White),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: AColor().Black),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text("Do you want to Sign Out?"),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: AColor().Black),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChooseDriverUser(),
                        ),
                            (Route<dynamic> route) => false,
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AColor().green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Sign Out",
                      style: TextStyle(color: AColor().White),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccountDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Request Account Deletion",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: AColor().Black),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text("Are you sure you want to delete your account?"),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: AColor().Black),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const RegisterScreen(role: "user"), // adjust role
                        ),
                            (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AColor().Red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(color: AColor().White),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
