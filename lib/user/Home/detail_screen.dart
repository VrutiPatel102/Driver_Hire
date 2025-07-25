// import 'package:driver_hire/bottom_bar.dart';
// import 'package:driver_hire/color.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
//
// class UserRideDetailScreen extends StatefulWidget {
//   final String pickupAddress;
//   final String dropAddress;
//   final String date;
//   final String time;
//   final String carType;
//   final String rideType;
//
//   const UserRideDetailScreen({
//     Key? key,
//     required this.pickupAddress,
//     required this.dropAddress,
//     required this.date,
//     required this.time,
//     required this.carType,
//     required this.rideType,
//   }) : super(key: key);
//
//   @override
//   State<UserRideDetailScreen> createState() => _UserRideDetailScreenState();
// }
//
// class _UserRideDetailScreenState extends State<UserRideDetailScreen> {
//   final MapController _mapController = MapController();
//   double _currentZoom = 13.0;
//
//   final LatLng startPoint = LatLng(23.0225, 72.5714); // Ahmedabad
//   final LatLng endPoint = LatLng(23.0325, 72.5800); // Nearby
//
//   void _zoomIn() {
//     setState(() {
//       _currentZoom += 1;
//       _mapController.move(_mapController.camera.center, _currentZoom);
//     });
//   }
//
//   void _zoomOut() {
//     setState(() {
//       _currentZoom -= 1;
//       _mapController.move(_mapController.camera.center, _currentZoom);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AColor().White,
//       appBar: AppBar(
//         title: const Text('Ride Details'),
//         backgroundColor: AColor().White,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _map(),
//             _detailBox(),
//             const SizedBox(height: 24),
//             _cancelBtn(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _map() {
//     return Stack(
//       children: [
//         SizedBox(
//           height: 380,
//           child: FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               initialCenter: startPoint,
//               initialZoom: _currentZoom,
//               maxZoom: 18,
//               minZoom: 4,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 userAgentPackageName: 'com.example.yourapp',
//               ),
//               MarkerLayer(
//                 markers: [
//                   Marker(
//                     point: startPoint,
//                     width: 40,
//                     height: 40,
//                     child: Icon(
//                       Icons.location_on,
//                       color: AColor().green,
//                       size: 40,
//                     ),
//                   ),
//                   Marker(
//                     point: endPoint,
//                     width: 40,
//                     height: 40,
//                     child: Icon(
//                       Icons.location_on,
//                       color: AColor().Red,
//                       size: 40,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         _ZoomBtn(),
//       ],
//     );
//   }
//
//   Widget _detailBox() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16, right: 16, top: 37),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: AColor().White,
//           border: Border.all(color: AColor().grey300),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _DetailText(label: "Pickup Address:", value: widget.pickupAddress),
//             _DetailText(label: "Drop Address:", value: widget.dropAddress),
//             _DetailText(label: "Date:", value: widget.date),
//             _DetailText(label: "Time:", value: widget.time),
//             _DetailText(label: "Car Type:", value: widget.carType),
//             _DetailText(label: "Ride Type:", value: widget.rideType),
//             _DetailText(label: "Estimate:", value: "₹250"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _ZoomBtn() {
//     return Positioned(
//       right: 10,
//       top: 10,
//       child: Column(
//         children: [
//           FloatingActionButton(
//             heroTag: "zoomIn",
//             mini: true,
//             onPressed: _zoomIn,
//             backgroundColor: AColor().Black,
//             child: Icon(Icons.add, color: AColor().White),
//           ),
//           FloatingActionButton(
//             heroTag: "zoomOut",
//             mini: true,
//             onPressed: _zoomOut,
//             backgroundColor: AColor().Black,
//             child: Icon(Icons.remove, color: AColor().White),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _cancelBtn() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: SizedBox(
//         width: double.infinity,
//         height: 60,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AColor().Black,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => BottomBarScreen(initialIndex: 0), // Home tab
//               ),
//                   (route) => false,
//             );
//           },
//           child: Text('Cancel Ride', style: TextStyle(color: AColor().White)),
//         ),
//       ),
//     );
//   }
// }
//
// class _DetailText extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _DetailText({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: RichText(
//         text: TextSpan(
//           style: TextStyle(fontSize: 15, color: Colors.black),
//           children: [
//             TextSpan(
//               text: "$label ",
//               style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
//             ),
//             TextSpan(text: value),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_hire/bottom_bar.dart';
import 'package:driver_hire/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserRideDetailScreen extends StatefulWidget {
  final String pickupAddress;
  final String dropAddress;
  final String date;
  final String time;
  final String carType;
  final String rideType;
  final String userEmail;
  final String bookingId;

  const UserRideDetailScreen({
    Key? key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.date,
    required this.time,
    required this.carType,
    required this.rideType,
    required this.userEmail,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<UserRideDetailScreen> createState() => _UserRideDetailScreenState();
}

class _UserRideDetailScreenState extends State<UserRideDetailScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 13.0;

  final LatLng startPoint = LatLng(23.0225, 72.5714); // Ahmedabad
  final LatLng endPoint = LatLng(23.0325, 72.5800);   // Nearby

  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: AppBar(
        title: const Text('Ride Details'),
        backgroundColor: AColor().White,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _map(),
            _detailBox(),
            const SizedBox(height: 24),
            _cancelBtn(),
          ],
        ),
      ),
    );
  }

  Widget _map() {
    return Stack(
      children: [
        SizedBox(
          height: 380,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: startPoint,
              initialZoom: _currentZoom,
              maxZoom: 18,
              minZoom: 4,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.yourapp',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: startPoint,
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_on, color: AColor().green, size: 40),
                  ),
                  Marker(
                    point: endPoint,
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_on, color: AColor().Red, size: 40),
                  ),
                ],
              ),
            ],
          ),
        ),
        _ZoomBtn(),
      ],
    );
  }

  Widget _detailBox() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final bookingData = snapshot.data!.data() as Map<String, dynamic>?;
          final driverEmail = bookingData?['driver_email'] ?? '';

          if (driverEmail.isEmpty) {
            return _buildDetailContainer('Driver not assigned yet');
          }

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('drivers')
                .doc(driverEmail)
                .snapshots(),
            builder: (context, driverSnapshot) {
              if (driverSnapshot.connectionState == ConnectionState.waiting) {
                return _buildDetailContainer('Loading driver...');
              }

              if (driverSnapshot.hasData && driverSnapshot.data!.exists) {
                final driverData =
                driverSnapshot.data!.data() as Map<String, dynamic>?;
                final driverName = driverData?['name'] ?? 'Unknown';
                return _buildDetailContainer(driverName);
              }

              return _buildDetailContainer('Driver not found');
            },
          );
        }

        return _buildDetailContainer('Driver not assigned yet');
      },
    );
  }

  Widget _buildDetailContainer(String driverName) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 37),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AColor().White,
          border: Border.all(color: AColor().grey300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailText(label: "Driver Name:", value: driverName),
            _DetailText(label: "Pickup Address:", value: widget.pickupAddress),
            _DetailText(label: "Drop Address:", value: widget.dropAddress),
            _DetailText(label: "Date:", value: widget.date),
            _DetailText(label: "Time:", value: widget.time),
            _DetailText(label: "Car Type:", value: widget.carType),
            _DetailText(label: "Ride Type:", value: widget.rideType),
            _DetailText(label: "Estimate:", value: "₹250"),
          ],
        ),
      ),
    );
  }

  Widget _ZoomBtn() {
    return Positioned(
      right: 10,
      top: 10,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: "zoomIn",
            mini: true,
            onPressed: _zoomIn,
            backgroundColor: AColor().Black,
            child: Icon(Icons.add, color: AColor().White),
          ),
          FloatingActionButton(
            heroTag: "zoomOut",
            mini: true,
            onPressed: _zoomOut,
            backgroundColor: AColor().Black,
            child: Icon(Icons.remove, color: AColor().White),
          ),
        ],
      ),
    );
  }

  Widget _cancelBtn() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AColor().Black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            try {
              final query = await FirebaseFirestore.instance
                  .collection('bookings')
                  .where('pickupAddress', isEqualTo: widget.pickupAddress)
                  .where('dropAddress', isEqualTo: widget.dropAddress)
                  .where('date', isEqualTo: widget.date)
                  .where('time', isEqualTo: widget.time)
                  .where('user_email', isEqualTo: widget.userEmail)
                  .limit(1)
                  .get();

              if (query.docs.isNotEmpty) {
                await query.docs.first.reference.update({'status': 'cancelled'});

                // ✅ Show custom toast
                _showCustomToast("Ride cancelled");

                // Delay before navigating back to allow toast visibility
                await Future.delayed(Duration(milliseconds: 1500));

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BottomBarScreen(initialIndex: 0),
                  ),
                      (route) => false,
                );
              } else {
                _showCustomToast("No matching ride found");
              }
            } catch (e) {
              print('Error cancelling booking: $e');
              _showCustomToast("Failed to cancel ride");
            }
          },
          child: Text('Cancel Ride', style: TextStyle(color: AColor().White)),
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


}

class _DetailText extends StatelessWidget {
  final String label;
  final String value;

  const _DetailText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, color: Colors.black),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
