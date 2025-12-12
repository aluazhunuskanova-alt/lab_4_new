import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});


  static const LatLng _kimep = LatLng(43.2350, 76.9096);

  @override
  Widget build(BuildContext context) {
    // On WEB: show placeholder to avoid JS error
    if (kIsWeb) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Google Map preview is not available in web mode.\n'
            'Please run the app on Android emulator or device to see the map.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // On Android / iOS / Windows: real Google Map
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: _kimep,
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('kimep'),
          position: _kimep,
          infoWindow: InfoWindow(title: 'KIMEP University'),
        ),
      },
    );
  }
}
