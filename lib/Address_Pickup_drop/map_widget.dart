import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapWidget extends StatefulWidget {
  final GeoPoint? point1;
  final GeoPoint? point2;

  const MapWidget({super.key, this.point1, this.point2});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapController controller;
  late GeoPoint point1;
  late GeoPoint point2;

  @override
  void initState() {
    super.initState();
    point1 = widget.point1 ??
        GeoPoint(
          latitude: 23.0387,
          longitude: 72.6308,
        );
    point2 = widget.point2 ??
        GeoPoint(
          latitude: 23.0500,
          longitude: 72.6700,
        );

    controller = MapController(initPosition: point1);

    Future.delayed(Duration(seconds: 1)).then((_) async {
      await controller.osmBaseController.addMarker(
        point1,
        markerIcon: MarkerIcon(
          icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
        ),
      );
      await controller.osmBaseController.addMarker(
        point2,
        markerIcon: MarkerIcon(
          icon: Icon(Icons.location_pin, color: Colors.blue, size: 48),
        ),
      );
      _setupMarkersAndZoom();
    });
  }

  Future<void> _setupMarkersAndZoom() async {
    BoundingBox box = BoundingBox(
      north: point1.latitude > point2.latitude ? point1.latitude : point2.latitude,
      south: point1.latitude < point2.latitude ? point1.latitude : point2.latitude,
      east: point1.longitude > point2.longitude ? point1.longitude : point2.longitude,
      west: point1.longitude < point2.longitude ? point1.longitude : point2.longitude,
    );
    await controller.zoomToBoundingBox(box, paddinInPixel: 60);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: controller,
      osmOption: OSMOption(
        enableRotationByGesture: false,
      ),
    );
  }
}
