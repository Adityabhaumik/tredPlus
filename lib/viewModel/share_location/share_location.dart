import 'dart:async';

import 'package:example/model/firebase_model.dart';
import 'package:example/viewModel/current_location/current_location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../utils/locators/setup_locators.dart';
part 'share_location.g.dart';

@riverpod
class ShareLocation extends _$ShareLocation {
  bool isSharing = false;
  String? key;
  Timer? timer;
  @override
  bool build() {
    ref.onDispose(() {
      stopSharing();
    });
    return isSharing;
  }

  void startSharing() {
    isSharing = true;
    state = isSharing;
    final firebase = locator<AppFirebase>();
    const uuid = Uuid();
    key = uuid.v4();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      //send location to server
      await ref.read(currentLocationProvider.notifier).getCurrentLocation();
      double lat =
          ref.read(currentLocationProvider.notifier).currentLocation.latitude;
      double long =
          ref.read(currentLocationProvider.notifier).currentLocation.longitude;
      await firebase.sendData(
          key: key!, data: {'lat': lat, 'long': long, 'time': DateTime.now()});
    });
  }

  void stopSharing() {
    timer?.cancel();
    key = null;
    isSharing = false;
    state = isSharing;
  }
}
