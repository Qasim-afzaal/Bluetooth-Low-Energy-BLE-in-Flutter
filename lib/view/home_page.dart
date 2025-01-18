import 'package:flutter/material.dart';
import 'package:flutter_ble/controller/ble_controller.dart';
import 'package:get/get.dart';
  final BLEController controller = Get.put(BLEController());

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Controller'),
        actions: [
          IconButton(
            icon: Obx(() => Icon(controller.isScanning.value ? Icons.stop : Icons.refresh)),
            onPressed: controller.startScan,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isScanning.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.scanResults.length,
          itemBuilder: (context, index) {
            final result = controller.scanResults[index];
            return ListTile(
              title: Text(result.device.name.isNotEmpty ? result.device.name : 'Unknown Device'),
              subtitle: Text(result.device.id.toString()),
              trailing: ElevatedButton(
                onPressed: () => controller.connectToDevice(result.device),
                child: Text('Connect'),
              ),
            );
          },
        );
      }),
    );
  }
}
