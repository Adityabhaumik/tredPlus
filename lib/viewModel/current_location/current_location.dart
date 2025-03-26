import 'package:example/model/current_location_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/locators/setup_locators.dart';

part 'current_location.g.dart';

@riverpod
class CurrentLocation extends _$CurrentLocation {
  LatLng currentLocation = const LatLng(0, 0);
  @override
  FutureOr<LatLng> build() async {
    await getCurrentLocation();
    return currentLocation;
  }

  Future<void> getCurrentLocation() async {
    try {
      final currentLocationModel = locator<CurrentLocationModel>();
      if (currentLocationModel.currentLocation != null) {
        currentLocation = currentLocationModel.currentLocation!;
        state = AsyncData(currentLocation);
      } else {
        await currentLocationModel.getCurrentLocation();
        currentLocation = currentLocationModel.currentLocation!;
        state = AsyncData(currentLocation);
      }
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }
}
