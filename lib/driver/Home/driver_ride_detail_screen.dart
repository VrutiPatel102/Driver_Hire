// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:driver_hire/color.dart';
// import 'package:driver_hire/driver/driver_bottom_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
//
// class DriverRideDetailScreen extends StatefulWidget {
//   const DriverRideDetailScreen({Key? key}) : super(key: key);
//
//   @override
//   State<DriverRideDetailScreen> createState() => _DriverRideDetailScreenState();
// }
//
// class _DriverRideDetailScreenState extends State<DriverRideDetailScreen> {
//   final MapController _mapController = MapController();
//   double _currentZoom = 13.0;
//
//   late Map<String, dynamic> rideData;
//
//   final LatLng startPoint = LatLng(23.0225, 72.5714);
//   final LatLng endPoint = LatLng(23.0325, 72.5800);
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     rideData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//   }
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
//   Future<void> _completeRide() async {
//     try {
//       final currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser == null) {
//         _showCustomToast(context, "Driver not logged in");
//         return;
//       }
//
//       final rideId = rideData['rideId'];
//       if (rideId == null) {
//         _showCustomToast(context, "Missing ride ID");
//         return;
//       }
//
//       await FirebaseFirestore.instance.collection('bookings').doc(rideId).update({
//         'status': 'completed',
//         'driverId': currentUser.uid,
//       });
//
//       _showCustomToast(context, "Ride completed");
//
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => DriverBottomBarScreen(initialIndex: 0)),
//             (route) => false,
//       );
//     } catch (e) {
//       print("Error completing ride: $e");
//       _showCustomToast(context, "Failed to complete ride");
//     }
//   }
//
//   Future<void> _cancelRide() async {
//     try {
//       final currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser == null) {
//         _showCustomToast(context, "Driver not logged in");
//         return;
//       }
//
//       final rideId = rideData['rideId'];
//       if (rideId == null) {
//         _showCustomToast(context, "Missing ride ID");
//         return;
//       }
//
//       await FirebaseFirestore.instance.collection('bookings').doc(rideId).update({
//         'status': 'cancelled',
//         'driverId': currentUser.uid,
//       });
//
//       _showCustomToast(context, "Ride cancelled");
//
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => DriverBottomBarScreen(initialIndex: 0)),
//             (route) => false,
//       );
//     } catch (e) {
//       print("Error cancelling ride: $e");
//       _showCustomToast(context, "Failed to cancel ride");
//     }
//   }
//
//   void _showCustomToast(BuildContext context, String message) {
//     final overlay = Overlay.of(context);
//     final textWidth = (message.length * 8.0).clamp(100.0, MediaQuery.of(context).size.width * 0.8);
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
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
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
//             SizedBox(height: 14),
//             _completeBtn(),
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
//                     child: Icon(Icons.location_on, color: AColor().green, size: 40),
//                   ),
//                   Marker(
//                     point: endPoint,
//                     width: 40,
//                     height: 40,
//                     child: Icon(Icons.location_on, color: AColor().Red, size: 40),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         _zoomBtn(),
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
//           border: Border.all(color: AColor().grey400),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _DetailText(label: "Pickup Address:", value: rideData['pickupAddress'] ?? 'N/A'),
//             SizedBox(height: 15),
//             _DetailText(label: "Date:", value: rideData['date'] ?? 'N/A'),
//             SizedBox(height: 15),
//             _DetailText(label: "Time:", value: rideData['time'] ?? 'N/A'),
//             SizedBox(height: 15),
//             _DetailText(label: "Car Type:", value: rideData['carType'] ?? 'N/A'),
//             SizedBox(height: 15),
//             _DetailText(label: "Ride Type:", value: rideData['rideType'] ?? 'N/A'),
//             SizedBox(height: 15),
//             _DetailText(label: "Estimate:", value: "₹${rideData['amount'] ?? '0'}"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _zoomBtn() {
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
//   Widget _completeBtn() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
//       child: SizedBox(
//         width: double.infinity,
//         height: 54,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AColor().Black,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           onPressed: _completeRide,
//           child: Text('Complete Ride', style: TextStyle(color: AColor().White)),
//         ),
//       ),
//     );
//   }
//
//   Widget _cancelBtn() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: SizedBox(
//         width: double.infinity,
//         height: 54,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AColor().Black,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           onPressed: _cancelRide,
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
//     return RichText(
//       text: TextSpan(
//         style: TextStyle(fontSize: 15, color: AColor().Black),
//         children: [
//           TextSpan(
//             text: "$label ",
//             style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
//           ),
//           TextSpan(text: value),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_hire/color.dart';
import 'package:driver_hire/driver/driver_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DriverRideDetailScreen extends StatefulWidget {
  const DriverRideDetailScreen({Key? key}) : super(key: key);

  @override
  State<DriverRideDetailScreen> createState() => _DriverRideDetailScreenState();
}

class _DriverRideDetailScreenState extends State<DriverRideDetailScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 13.0;

  late Map<String, dynamic> rideData;

  final LatLng startPoint = LatLng(23.0225, 72.5714);
  final LatLng endPoint = LatLng(23.0325, 72.5800);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    rideData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  Future<void> _completeRide() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _showCustomToast(context, "Driver not logged in");
        return;
      }

      final rideId = rideData['rideId'];
      if (rideId == null) {
        _showCustomToast(context, "Missing ride ID");
        return;
      }

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(rideId)
          .update({'status': 'completed', 'driverId': currentUser.uid});

      _showCustomToast(context, "Ride completed");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => DriverBottomBarScreen(initialIndex: 1),
        ),
        // <-- Navigate to Bookings tab
        (route) => false,
      );
    } catch (e) {
      print("Error completing ride: $e");
      _showCustomToast(context, "Failed to complete ride");
    }
  }

  Future<void> _cancelRide() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _showCustomToast(context, "Driver not logged in");
        return;
      }

      final rideId = rideData['rideId'];
      if (rideId == null) {
        _showCustomToast(context, "Missing ride ID");
        return;
      }

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(rideId)
          .update({'status': 'cancelled', 'driverId': currentUser.uid});

      _showCustomToast(context, "Ride cancelled");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => DriverBottomBarScreen(initialIndex: 1),
        ),
        // <-- Navigate to Bookings tab
        (route) => false,
      );
    } catch (e) {
      print("Error cancelling ride: $e");
      _showCustomToast(context, "Failed to cancel ride");
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
    Future.delayed(
      const Duration(seconds: 2),
    ).then((_) => overlayEntry.remove());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(height: 14),
            _completeBtn(),
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
              center: startPoint,
              // corrected to center instead of initialCenter for newer flutter_map
              zoom: _currentZoom,
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
                    child: Icon(
                      Icons.location_on,
                      color: AColor().green,
                      size: 40,
                    ),
                  ),

                  Marker(
                    point: endPoint,
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.location_on,
                      color: AColor().Red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _zoomBtn(),
      ],
    );
  }

  Widget _detailBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 37),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AColor().grey400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailText(
              label: "Pickup Address:",
              value: rideData['pickupAddress'] ?? 'N/A',
            ),
            const SizedBox(height: 15),
            _DetailText(label: "Date:", value: rideData['date'] ?? 'N/A'),
            const SizedBox(height: 15),
            _DetailText(label: "Time:", value: rideData['time'] ?? 'N/A'),
            const SizedBox(height: 15),
            _DetailText(
              label: "Car Type:",
              value: rideData['carType'] ?? 'N/A',
            ),
            const SizedBox(height: 15),
            _DetailText(
              label: "Ride Type:",
              value: rideData['rideType'] ?? 'N/A',
            ),
            const SizedBox(height: 15),
            _DetailText(
              label: "Estimate:",
              value: "₹${rideData['amount'] ?? '0'}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _zoomBtn() {
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

  Widget _completeBtn() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AColor().Black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _completeRide,
          child: Text('Complete Ride', style: TextStyle(color: AColor().White)),
        ),
      ),
    );
  }

  Widget _cancelBtn() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AColor().Black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _cancelRide,
          child: Text('Cancel Ride', style: TextStyle(color: AColor().White)),
        ),
      ),
    );
  }
}

class _DetailText extends StatelessWidget {
  final String label;
  final String value;

  const _DetailText({required this.label, required this.value, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 15, color: AColor().Black),
        children: [
          TextSpan(
            text: "$label ",
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
