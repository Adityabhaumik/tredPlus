import 'dart:async';

import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/firebase_model.dart';
import '../../utils/locators/setup_locators.dart';

part 'listen_location.g.dart';

enum ListenLocationState { listening, notListening, loading }

@riverpod
class ListenLocation extends _$ListenLocation {
  ListenLocationState isListening = ListenLocationState.notListening;
  Stream<LatLng>? stream;
  @override
  ListenLocationState build() {
    ref.onDispose(() {
      stopListening();
    });
    return isListening;
  }

  void startListening(String key) {
    isListening = ListenLocationState.loading;
    state = isListening;
    stream = locator<AppFirebase>().listenToCollection(key).asBroadcastStream();
    stream!.listen((event) {
      isListening = ListenLocationState.listening;
      state = isListening;
    }, onError: (error) {
      stream = null;
      isListening = ListenLocationState.notListening;
      state = isListening;
    });
  }

  void stopListening() {
    stream = null;
    locator<AppFirebase>().stopListning();
    isListening = ListenLocationState.notListening;
    state = isListening;
  }
}
