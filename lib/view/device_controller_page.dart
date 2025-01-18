import 'package:flutter/material.dart';
import 'package:flutter_ble/controller/ble_controller.dart';
import 'package:get/get.dart';
  final BLEController controller = Get.find();

class DeviceControlPage extends StatelessWidget {
  const DeviceControlPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device Control')),
      body: Obx(() {
        if (controller.connectedDevice.value == null) {
          return Center(child: Text('No device connected'));
        }
        return ListView(
          children: controller.services.expand((service) => service.characteristics).map((characteristic) {
            return ListTile(
              title: Text('Characteristic: ${characteristic.uuid}'),
              subtitle: Text(
                controller.receivedData.containsKey(characteristic.uuid)
                    ? 'Received: ${controller.receivedData[characteristic.uuid]}'
                    : 'No data received yet',
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
