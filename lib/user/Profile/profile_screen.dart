import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Confirm Logout',style: TextStyle(fontSize: 17),),
        content:  Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AColor().Black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AColor().green,
            ),
            onPressed: () {
              Navigator.pop(context);

            },
            child:  Text('Logout', style: TextStyle(color: AColor().White)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Delete Account'),
        content:  Text(
          'This action cannot be undone.\nAre you sure you want to delete your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AColor().Black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AColor().Red,
            ),
            onPressed: () {
              Navigator.pop(context);
              // TODO: Add your actual delete logic here.
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: AppBar(
        backgroundColor: AColor().White,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.person_outline, color: AColor().Black),
            const SizedBox(width: 8),
            Text(
              'Profile',
              style: TextStyle(
                color: AColor().Black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _showLogoutDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AColor().green100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: AColor().Red,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 40, top: 40, bottom: 90),
              decoration: BoxDecoration(
                color: AColor().green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                  )
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name :', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 30),
                  Text('Mobile No :', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 30),
                  Text('Email :', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => _showDeleteDialog(context),
                  child: Row(
                    children: [
                      Text(
                        'Delete Account ',
                        style: TextStyle(
                          color: AColor().Red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.delete_outline, color: AColor().Red),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
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
                  // Update action
                },
                child: Text(
                  'Update',
                  style: TextStyle(
                    color: AColor().White,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
