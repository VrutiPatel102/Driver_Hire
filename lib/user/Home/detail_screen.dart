import 'package:driver_hire/bottom_bar.dart';
import 'package:driver_hire/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserRideDetailScreen extends StatefulWidget {
  const UserRideDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserRideDetailScreen> createState() => _UserRideDetailScreenState();
}

class _UserRideDetailScreenState extends State<UserRideDetailScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 13.0;

  final LatLng startPoint = LatLng(23.0225, 72.5714); // Ahmedabad
  final LatLng endPoint = LatLng(23.0325, 72.5800); // Nearby

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
        backgroundColor: Colors.white,
      ),
      body: Column(children: [_map(), _detailBox(), Spacer(), _cancelBtn()]),
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
        _ZoomBtn(),
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
          children: const [
            _DetailText(label: "Pickup Address:", value: "123 Main Street, Ahmedabad"),
            SizedBox(height: 15),
            _DetailText(label: "Date:", value: "17 July 2025"),
            SizedBox(height: 15),
            _DetailText(label: "Time:", value: "10:00 AM"),
            SizedBox(height: 15),
            _DetailText(label: "Car Type:", value: "Sedan"),
            SizedBox(height: 15),
            _DetailText(label: "Ride Type:", value: "One Way"),
            SizedBox(height: 15),
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
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AColor().Black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    BottomBarScreen(initialIndex: 0), // Home tab
              ),
                  (route) => false,
            );
          },
          child: Text('Cancel Ride', style: TextStyle(color: AColor().White)),
        ),
      ),
    );
  }
}


class _DetailText extends StatelessWidget {
  final String label;
  final String value;

  const _DetailText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: "$label ",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: value,
          ),
        ],
      ),
    );
  }
}

