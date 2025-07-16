import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _pickedLocation;

  static const LatLng _initialPosition = LatLng(28.6139, 77.2090); // Example: New Delhi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _initialPosition,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (position) {
              setState(() {
                _pickedLocation = position;
              });
            },
            markers: _pickedLocation != null
                ? {
              Marker(
                markerId: const MarkerId('selected'),
                position: _pickedLocation!,
              )
            }
                : {},
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                Navigator.pop(context, _pickedLocation);
              },
              child: const Text('Select this Location'),
            ),
          ),
        ],
      ),
    );
  }
}
