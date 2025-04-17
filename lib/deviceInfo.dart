import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfopage extends StatefulWidget {
  const DeviceInfopage({super.key});

  @override
  State<DeviceInfopage> createState() => _DeviceInfopageState();
}

class _DeviceInfopageState extends State<DeviceInfopage> {
  String deviceId = "Unknown";
  String macAddress = "Unavailable";

  @override
  void initState() {
    super.initState();
    fetchDeviceInfo();
  }

  Future<void> fetchDeviceInfo() async {
    try {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      setState(() {
        deviceId = deviceInfo.hardware ?? "Unavailable";
        macAddress = deviceInfo.id ??
            "Unavailable"; // limited due to Android restrictions
      });
    } catch (e) {
      setState(() {
        deviceId = "Permission denied or not available";
        macAddress = "Unavailable";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INFO '),
      ),
      body: Column(
        children: [
          Text('The device mac address is : $macAddress'),
          SizedBox(
            height: 10,
          ),
          Text('The device Id is :$deviceId')
        ],
      ),
    );
  }
}
