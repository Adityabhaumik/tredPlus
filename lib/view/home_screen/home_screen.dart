import 'package:example/view/view_shared_location/view_shared_location.dart';
import 'package:example/viewModel/current_location/current_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/location_marker.dart';
import '../share_location_screen/share_location_screen.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_screen';

  HomePage({super.key});

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentLocation = ref.watch(currentLocationProvider);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
            ),
            floatingActionButton:
                currentLocation.hasValue == true ? fab(context) : null,
            body: currentLocation.when(
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text(
                    'Error: $error',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
              data: (data) {
                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: data,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 20.0,
                          height: 20.0,
                          point: data,
                          child: CustomPaint(
                            painter: GlowingCirclePainter(),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ));
      },
    );
  }

  Column fab(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 50,
          width: 200,
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ShareLocationScreen.id);
              },
              child: const Text("Share Location")),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 50,
          width: 200,
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ViewSharedLocationScreen.id);
              },
              child: const Text("View Shared Location ")),
        ),
      ],
    );
  }
}
