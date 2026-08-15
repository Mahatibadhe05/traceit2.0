import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../models/device_model.dart';


class DeviceService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;


  final FirebaseAuth _auth =
      FirebaseAuth.instance;


  String _getCurrentUid() {
    final user = _auth.currentUser;


    if (user == null) {
      throw Exception('No authenticated user found.');
    }


    return user.uid;
  }


  CollectionReference<Map<String, dynamic>> get _devicesCollection {
    final uid = _getCurrentUid();


    return _firestore
        .collection('users')
        .doc(uid)
        .collection('devices');
  }


  // Add a new device.
  Future<void> addDevice(DeviceModel device) async {
    await _devicesCollection
        .doc(device.id)
        .set(device.toJson());
  }


  // Get all devices belonging to the current user.
  Future<List<DeviceModel>> getDevices() async {
    final snapshot = await _devicesCollection.get();


    return snapshot.docs.map((document) {
      return DeviceModel.fromJson(document.data());
    }).toList();
  }


  // Listen to devices in real time.
  Stream<List<DeviceModel>> watchDevices() {
    return _devicesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        return DeviceModel.fromJson(document.data());
      }).toList();
    });
  }


  // Get one device.
  Future<DeviceModel?> getDevice(String deviceId) async {
    final document =
        await _devicesCollection.doc(deviceId).get();


    if (!document.exists || document.data() == null) {
      return null;
    }


    return DeviceModel.fromJson(document.data()!);
  }


  // Update an existing device.
  Future<void> updateDevice(DeviceModel device) async {
    await _devicesCollection
        .doc(device.id)
        .update(device.toJson());
  }


  // Delete a device.
  Future<void> deleteDevice(String deviceId) async {
    await _devicesCollection
        .doc(deviceId)
        .delete();
  }
}
