import 'package:example/viewModel/share_location/share_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class ShareLocationScreen extends ConsumerWidget {
  static const String id = 'share_location_screen';

  const ShareLocationScreen({super.key});

  void _copyToClipboard(String key) {
    Clipboard.setData(ClipboardData(text: key));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shareLocationState = ref.watch(shareLocationProvider);
    final shareLocationStateNotifier = ref.read(shareLocationProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text("Share Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (shareLocationState)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Passkey : ${shareLocationStateNotifier.key} ",
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      _copyToClipboard(shareLocationStateNotifier.key!);
                    },
                    icon: const Icon(Icons.copy),
                  )
                ],
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    shareLocationState ? Colors.red : Colors.greenAccent,
              ),
              onPressed: () {
                if (shareLocationState) {
                  shareLocationStateNotifier.stopSharing();
                } else {
                  shareLocationStateNotifier.startSharing();
                }
              },
              child: Text(
                shareLocationState ? "Stop Sharing" : "Share Location",
                style: TextStyle(
                    color: shareLocationState ? Colors.white : Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
