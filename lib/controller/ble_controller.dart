import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class BLEController extends GetxController {
  var isScanning = false.obs;
  var scanResults = <ScanResult>[].obs;
  var connectedDevice = Rx<BluetoothDevice?>(null);
  var services = <BluetoothService>[].obs;
  var receivedData = <Guid, List<int>>{}.obs;

  final FlutterBlue flutterBlue = FlutterBlue.instance;

  void startScan() {
    if (isScanning.value) {
      flutterBlue.stopScan();
      isScanning.value = false;
    } else {
      scanResults.clear();
      isScanning.value = true;

      flutterBlue.startScan(timeout: Duration(seconds: 5));
      flutterBlue.scanResults.listen((results) {
        scanResults.assignAll(results);
      }).onDone(() {
        isScanning.value = false;
      });
    }
  }

 
}
