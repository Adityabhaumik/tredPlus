import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../utils/location_marker.dart';
import '../../viewModel/listen_location/listen_location.dart';

class ViewSharedLocationScreen extends ConsumerWidget {
  static const String id = 'view_shared_location_screen';

  final TextEditingController _passKeyController = TextEditingController();
  final MapController _mapController = MapController();
  final LatLng _delhiCoordinates = const LatLng(28.7041, 77.1025);

  ViewSharedLocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listenLocationState = ref.watch(listenLocationProvider);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              listenLocationState == ListenLocationState.listening
                  ? false
                  : true,
          title: const Text(
            'View Shared Location',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            if (listenLocationState == ListenLocationState.listening)
              IconButton(
                icon: const Icon(
                  Icons.stop,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  ref.read(listenLocationProvider.notifier).stopListening();
                },
              ),
          ],
        ),
        body: Builder(builder: (context) {
          if (listenLocationState == ListenLocationState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (listenLocationState == ListenLocationState.notListening) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _passKeyController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Pass Key',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(listenLocationProvider.notifier).startListening(
                            _passKeyController.text,
                          );
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          }
          final listenLocationStateNotifier =
              ref.read(listenLocationProvider.notifier);
          return StreamBuilder<LatLng>(
              stream: listenLocationStateNotifier.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("newData: ${snapshot.data}");
                  return FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(initialCenter: snapshot.data!),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'dev.fleaflet.flutter_map.example',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 20.0,
                            height: 20.0,
                            point: snapshot.data!,
                            child: CustomPaint(
                              painter: GlowingCirclePainter(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return const SizedBox();
              });
        }));
  }
}
