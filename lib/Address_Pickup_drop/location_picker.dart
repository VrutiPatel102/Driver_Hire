import 'package:driver_hire/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as coordinates;
import 'package:geocoding/geocoding.dart';

class LocationPicker extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final double zoomLevel;
  final bool displayOnly;
  final Color appBarColor;
  final Color markerColor;
  final Color appBarTextColor;
  final String appBarTitle;

  const LocationPicker({
    super.key,
    this.initialLatitude = 23.0387,
    this.initialLongitude = 72.6308,
    this.zoomLevel = 13.0,
    this.displayOnly = false,
    this.appBarColor = Colors.blueAccent,
    this.appBarTextColor = Colors.white,
    this.appBarTitle = "Select Location",
    this.markerColor = Colors.blueAccent,
  });

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late SimpleLocationResult _selectedLocation;
  String? address = '';

  Future<void> _updateAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _selectedLocation.latitude,
        _selectedLocation.longitude,
      );
      Placemark place = placemarks.first;
      setState(() {
        address =
        "${place.name}, ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      address = "Failed to get address";
    }
  }

  void getLocation() {
    Navigator.of(context).pop({
      'lat': _selectedLocation.latitude,
      'lng': _selectedLocation.longitude,
      'address': address,
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedLocation =
        SimpleLocationResult(widget.initialLatitude, widget.initialLongitude);
    _updateAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AColor().White,
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        backgroundColor: AColor().White,
      ),
      body: Column(
        children: [
          if (address != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Address: $address",
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
              ),
            ),
          Expanded(child: _osmWidget()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AColor().Black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            onPressed: getLocation,
            child:  Text('Select this Location',style: TextStyle(color: AColor().White),),
          ),
        ],
      ),
    );
  }

  Widget _osmWidget() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: _selectedLocation.getLatLng(),
        initialZoom: widget.zoomLevel,
        onTap: (tapPos, position) {
          if (!widget.displayOnly) {
            setState(() {
              _selectedLocation =
                  SimpleLocationResult(position.latitude, position.longitude);
            });
            _updateAddress();
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(markers: [
          Marker(
            width: 80.0,
            height: 80.0,
            point: _selectedLocation.getLatLng(),
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),
        ])
      ],
    );
  }
}

class SimpleLocationResult {
  final double latitude;
  final double longitude;
  SimpleLocationResult(this.latitude, this.longitude);
  coordinates.LatLng getLatLng() => coordinates.LatLng(latitude, longitude);
}
