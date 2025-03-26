import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class AppFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamController<LatLng>? controller;
  StreamSubscription? subscription;
  Future<void> sendData(
      {required String key, required Map<String, dynamic> data}) async {
    //collection path is key
    final String collectionPath = key;
    try {
      final docRef =
          _firestore.collection(collectionPath).doc('most_recent_location');
      await docRef.update(data).catchError((error) async {
        if (error is FirebaseException && error.code == 'not-found') {
          await docRef.set(data);
        } else {
          throw error;
        }
      });
      await docRef.set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to send data: $e');
    }
  }

  Stream<LatLng> listenToCollection(String collectionPath) {
    controller = StreamController();
    subscription =
        _firestore.collection(collectionPath).snapshots().listen((snapshot) {
      final Map<String, dynamic> updatedData = snapshot.docs
          .firstWhere((doc) => doc.id == 'most_recent_location')
          .data();
      LatLng newLocation =
          LatLng(updatedData['lat'] as double, updatedData['long'] as double);
      controller?.add(newLocation);
    }, onError: (error) {
      controller?.addError(error);
    }, onDone: () {
      controller?.close();
    });
    return controller!.stream;
  }

  void stopListning() {
    controller?.close();
    subscription?.cancel();
  }
}
