# Flutter BLE Scanner and Device Manager

This Flutter project demonstrates a Bluetooth Low Energy (BLE) scanner and device manager. It uses the `flutter_blue` package for BLE operations, `get` for state management, and `dio` for potential API interactions.  

## Features

- Scan for nearby BLE devices.
- Connect to a BLE device.
- Discover services and subscribe to characteristics.
- Receive notifications from characteristics that support it.

---

## Dependencies

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_blue: ^0.8.0
  get: ^4.6.5
  dio: ^5.1.1
```

---

## Getting Started

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

---

## Functions Overview

Below are the key functions used in this project, extracted from the `BLEController` class.

### **1. Start BLE Scan**

This function starts or stops scanning for BLE devices. Results are stored in the `scanResults` list.

```dart
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
```

### **2. Connect to a Device**

This function connects to a selected BLE device, discovers its services, and subscribes to notifications for characteristics.

```dart
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
```

### **3. Disconnect from a Device**

This function disconnects from the currently connected BLE device and clears any associated data.

```dart
Future<void> disconnectDevice() async {
  if (connectedDevice.value != null) {
    await connectedDevice.value!.disconnect();
    connectedDevice.value = null;
    services.clear();
    receivedData.clear();
  }
}
```

### **4. Subscribe to Characteristic Notifications**

This function subscribes to notifications for all characteristics that support it in the connected BLE device.

```dart
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
```

---

## Example Usage

Here’s how to use these functions in your app:

### **Scan for Devices**

```dart
controller.startScan();
```

### **Connect to a Device**

```dart
controller.connectToDevice(selectedDevice);
```

### **Disconnect a Device**

```dart
controller.disconnectDevice();
```

### **Receive Notifications**

Subscribed notifications from characteristics are stored in the `receivedData` map:
```dart
controller.receivedData.forEach((uuid, data) {
  print('Characteristic $uuid: $data');
});
```
---

## Contributing

1. Fork the repository.
2. Create your feature branch: `git checkout -b feature-name`.
3. Commit your changes: `git commit -m 'Add feature'`.
4. Push to the branch: `git push origin feature-name`.
5. Submit a pull request.

---

## License

This project is licensed under the [MIT License](LICENSE).
