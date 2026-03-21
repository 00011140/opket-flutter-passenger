import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPreviewMap extends StatelessWidget {
  final LatLng location;

  const LocationPreviewMap({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 270,
        width: double.infinity,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: location, zoom: 15),
          markers: {
            Marker(markerId: const MarkerId('location'), position: location),
          },
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          liteModeEnabled: true, // Android: makes it preview-like
          gestureRecognizers: {}, // disables interaction (optional)
        ),
      ),
    );
  }
}
