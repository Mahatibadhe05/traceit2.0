import 'dart:async';


import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';


class BleService {
  StreamSubscription<List<ScanResult>>? _scanSubscription;


  Future<bool> requestPermissions() async {
    final bluetoothScan = await Permission.bluetoothScan.request();
    final bluetoothConnect = await Permission.bluetoothConnect.request();


    if (!bluetoothScan.isGranted || !bluetoothConnect.isGranted) {
      return false;
    }


    return true;
  }


  Stream<List<ScanResult>> scanForDevices({
    Duration timeout = const Duration(seconds: 8),
  }) {
    final controller = StreamController<List<ScanResult>>();


    final results = <String, ScanResult>{};


    _scanSubscription?.cancel();


    _scanSubscription = FlutterBluePlus.onScanResults.listen(
      (scanResults) {
        for (final result in scanResults) {
          final deviceId = result.device.remoteId.str;
          results[deviceId] = result;
        }


        controller.add(results.values.toList());
      },
      onError: controller.addError,
    );


    FlutterBluePlus.startScan(
      timeout: timeout,
    ).catchError(controller.addError);


    Future.delayed(timeout, () async {
      await _scanSubscription?.cancel();
      _scanSubscription = null;


      if (!controller.isClosed) {
        await controller.close();
      }
    });


    return controller.stream;
  }


  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();


    await _scanSubscription?.cancel();
    _scanSubscription = null;
  }


  Future<void> dispose() async {
    await stopScan();
  }
}