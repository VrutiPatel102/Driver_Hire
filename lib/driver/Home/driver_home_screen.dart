// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:driver_hire/navigation/appRoute.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:driver_hire/color.dart';
//
// class DriverHomeScreen extends StatefulWidget {
//   const DriverHomeScreen({super.key});
//
//   @override
//   State<DriverHomeScreen> createState() => _DriverHomeScreenState();
// }
//
// class _DriverHomeScreenState extends State<DriverHomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AColor().White,
//       appBar: _buildAppBar(),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('bookings')
//             .where('status', isEqualTo: 'pending')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final docs = snapshot.data?.docs ?? [];
//
//           if (docs.isEmpty) {
//             return const Center(child: Text("No pending rides"));
//           }
//
//           return ListView.separated(
//             padding: const EdgeInsets.all(20),
//             itemCount: docs.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 16),
//             itemBuilder: (context, index) {
//               final doc = docs[index];
//               final data = doc.data() as Map<String, dynamic>;
//               final rideId = doc.id;
//               final userEmail = data['user_email'];
//
//               return FutureBuilder<DocumentSnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(userEmail)
//                     .get(),
//                 builder: (context, userSnapshot) {
//                   final userName = userSnapshot.data?.get('name') ?? 'Unknown';
//
//                   final rideData = {
//                     ...data,
//                     'name': userName,
//                     'rideId': rideId,
//                     'pickup': data['pickupAddress'] ?? '',
//                     'dropoff': data['dropAddress'] ?? '',
//                     'amount': data['fare']?.toString() ?? '',
//                   };
//
//                   return _buildRequestCard(rideData, context);
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: AColor().White,
//       elevation: 0,
//       centerTitle: true,
//       title: Text(
//         'Ride Requests',
//         style: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.w600,
//           color: AColor().Black,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRequestCard(Map<String, dynamic> data, BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(
//           context,
//           AppRoute.rideRequestDetailScreen,
//           arguments: data,
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: AColor().green.withAlpha(26),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(data),
//             const SizedBox(height: 12),
//             Divider(color: AColor().green.withAlpha(102)),
//             const SizedBox(height: 12),
//             _buildAddress(label: 'Pickup', address: data['pickup'] ?? ''),
//             const SizedBox(height: 10),
//             _buildAddress(label: 'Dropoff', address: data['dropoff'] ?? ''),
//             const SizedBox(height: 20),
//             _buildAcceptButton(context, data),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(Map<String, dynamic> data) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               data['name'] ?? '',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '${data['date'] ?? ''}  -  ${data['time'] ?? ''}',
//               style: TextStyle(color: AColor().grey700),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             const Text("₹", style: TextStyle(fontSize: 20)),
//             const SizedBox(width: 5),
//             Text(
//               data['amount'] ?? '',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAddress({required String label, required String address}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(color: AColor().grey700, fontSize: 14)),
//         const SizedBox(height: 4),
//         Text(
//           address,
//           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAcceptButton(
//       BuildContext context,
//       Map<String, dynamic> rideData,
//       ) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AColor().Black,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         onPressed: () async {
//           try {
//             final currentUser = FirebaseAuth.instance.currentUser;
//             if (currentUser == null) {
//               _showCustomToast(context, "Driver not logged in");
//               return;
//             }
//
//             final rideId = rideData['rideId'];
//
//             await FirebaseFirestore.instance
//                 .collection('bookings')
//                 .doc(rideId)
//                 .update({'status': 'accepted', 'driverId': currentUser.uid});
//
//             _showCustomToast(context, "Ride accepted");
//
//             Navigator.pushNamed(
//               context,
//               AppRoute.driverRideDetailScreen,
//               arguments: {
//                 'pickupAddress': rideData['pickupAddress'] ?? '',
//                 'dropAddress': rideData['dropoff'] ?? '',
//                 'date': rideData['date'] ?? '',
//                 'time': rideData['time'] ?? '',
//                 'carType': rideData['carType'] ?? '',
//                 'rideType': rideData['rideType'] ?? '',
//                 'rideId': rideId,
//                 'userEmail': rideData['user_email'] ?? '',
//                 'amount': rideData['fare']?.toString() ?? '',
//               },
//             );
//           } catch (e) {
//             print("Error accepting ride: $e");
//             _showCustomToast(context, "Failed to accept ride");
//           }
//         },
//         child: Text('Accept', style: TextStyle(color: AColor().White)),
//       ),
//     );
//   }
//
//   void _showCustomToast(BuildContext context, String message) {
//     final overlay = Overlay.of(context);
//     final textWidth = (message.length * 8.0).clamp(
//       100.0,
//       MediaQuery.of(context).size.width * 0.8,
//     );
//
//     final overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         bottom: 150,
//         left: (MediaQuery.of(context).size.width - textWidth) / 2,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: AColor().grey300,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               message,
//               style: TextStyle(color: AColor().Black),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ),
//     );
//
//     overlay.insert(overlayEntry);
//     Future.delayed(const Duration(seconds: 2)).then((_) => overlayEntry.remove());
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_hire/navigation/appRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:driver_hire/color.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isAccepting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: _buildAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text("No pending rides"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final rideId = doc.id;
              final userEmail = data['user_email'];

              // Fetch user details
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userEmail)
                    .get(),
                builder: (context, userSnapshot) {
                  final userName = userSnapshot.data?.get('name') ?? 'Unknown';

                  final rideData = {
                    ...data,
                    'name': userName,
                    'rideId': rideId,
                    'pickup': data['pickupAddress'] ?? '',
                    'dropoff': data['dropAddress'] ?? '',
                    'amount': data['fare']?.toString() ?? '',
                  };

                  return _buildRequestCard(rideData, context);
                },
              );
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AColor().White,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Ride Requests',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AColor().Black,
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> data, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // You can keep this if you want the card tap to also show ride details before accepting.
        Navigator.pushNamed(
          context,
          AppRoute.rideRequestDetailScreen,
          arguments: data,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AColor().green.withAlpha(26),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(data),
            const SizedBox(height: 12),
            Divider(color: AColor().green.withAlpha(102)),
            const SizedBox(height: 12),
            _buildAddress(label: 'Pickup', address: data['pickup'] ?? ''),
            const SizedBox(height: 10),
            _buildAddress(label: 'Dropoff', address: data['dropoff'] ?? ''),
            const SizedBox(height: 20),
            _buildAcceptButton(context, data),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['name'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '${data['date'] ?? ''}  -  ${data['time'] ?? ''}',
              style: TextStyle(color: AColor().grey700),
            ),
          ],
        ),
        Row(
          children: [
            const Text("₹", style: TextStyle(fontSize: 20)),
            const SizedBox(width: 5),
            Text(
              data['amount'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddress({required String label, required String address}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AColor().grey700, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          address,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildAcceptButton(BuildContext context, Map<String, dynamic> rideData) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AColor().Black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: _isAccepting
            ? null
            : () async {
          setState(() {
            _isAccepting = true;
          });
          try {
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser == null) {
              _showCustomToast(context, "Driver not logged in");
              setState(() {
                _isAccepting = false;
              });
              return;
            }

            final rideId = rideData['rideId'];
            // Prevent race condition: check status is 'pending' before accepting
            await FirebaseFirestore.instance.runTransaction((transaction) async {
              final docRef = FirebaseFirestore.instance.collection('bookings').doc(rideId);
              final docSnapshot = await transaction.get(docRef);
              if (!docSnapshot.exists) {
                throw Exception('Booking does not exist');
              }
              if (docSnapshot['status'] != 'pending') {
                throw Exception('Ride already accepted');
              }
              transaction.update(docRef, {
                'status': 'accepted',
                'driverId': currentUser.uid,
              });
            });

            _showCustomToast(context, "Ride accepted");

            Navigator.pushNamed(
              context,
              AppRoute.driverRideDetailScreen,
              arguments: {
                // Use the correct field names, or just ...rideData if you want
                'pickupAddress': rideData['pickup'] ?? '',
                'dropAddress': rideData['dropoff'] ?? '',
                'date': rideData['date'] ?? '',
                'time': rideData['time'] ?? '',
                'carType': rideData['carType'] ?? '',
                'rideType': rideData['rideType'] ?? '',
                'rideId': rideData['rideId'],
                'userEmail': rideData['user_email'] ?? '',
                'amount': rideData['amount'] ?? '',
              },
            );
          } catch (e) {
            print("Error accepting ride: $e");
            _showCustomToast(context, e.toString().contains('Ride already accepted') ? "This ride was already accepted!" : "Failed to accept ride");
          }
          setState(() {
            _isAccepting = false;
          });
        },
        child: _isAccepting
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: AColor().White,
            strokeWidth: 2,
          ),
        )
            : Text('Accept', style: TextStyle(color: AColor().White)),
      ),
    );
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
    Future.delayed(const Duration(seconds: 2)).then((_) => overlayEntry.remove());
  }
}
