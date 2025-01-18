Here’s a sample `README.md` file tailored for your project. It includes information about the packages used, setup instructions, and a description of the `BLEController` functionality:

```markdown
# Flutter BLE Scanner and Device Connector

This Flutter project demonstrates the use of Bluetooth Low Energy (BLE) to scan for devices, connect to them, and subscribe to their characteristics using the following packages:

- [flutter_blue](https://pub.dev/packages/flutter_blue): A Flutter plugin for BLE communication.
- [get](https://pub.dev/packages/get): A state management solution for reactive programming.
- [dio](https://pub.dev/packages/dio): A powerful HTTP client for API requests.

## Features

- Scan for nearby BLE devices.
- Connect to a selected BLE device.
- Discover services and characteristics of a connected device.
- Subscribe to characteristic notifications to receive data.

## Dependencies

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_blue: ^0.8.0
  get: ^4.6.5
  dio: ^5.1.1
```

## BLEController

The `BLEController` class manages the BLE operations using `flutter_blue` and reactive state management from `get`.

### Key Features

- **Scan for Devices**: Start or stop scanning for BLE devices.
- **Connect to a Device**: Connect to a selected device and discover its services.
- **Disconnect**: Disconnect from the connected device.
- **Subscribe to Notifications**: Listen for data from characteristics that support notifications.

### Code Snippet

Here’s the implementation of the `BLEController`:

```dart
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

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      connectedDevice.value = device;
      services.assignAll(await device.discoverServices());
      subscribeToCharacteristics();
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect: $e');
    }
  }

  Future<void> disconnectDevice() async {
    if (connectedDevice.value != null) {
      await connectedDevice.value!.disconnect();
      connectedDevice.value = null;
      services.clear();
      receivedData.clear();
    }
  }

  void subscribeToCharacteristics() {
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          characteristic.value.listen((value) {
            receivedData[characteristic.uuid] = value;
          });
          characteristic.setNotifyValue(true);
        }
      }
    }
  }
}
```

## Getting Started

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. **Install Dependencies**:
   Run the following command to install required packages:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   Use the following command to run the app on your device:
   ```bash
   flutter run
   ```

## Usage

1. Tap on "Scan" to discover nearby BLE devices.
2. Select a device from the scan results to connect.
3. View the discovered services and characteristics of the connected device.
4. Receive and display notifications from characteristics.

## License

This project is licensed under the [MIT License](LICENSE).

---

Feel free to update the `README.md` to reflect additional features or changes to the project.
```
