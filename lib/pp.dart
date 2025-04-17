import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetooth Scanner',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: BluetoothScannerPage(),
    );
  }
}

class BluetoothScannerPage extends StatefulWidget {
  @override
  _BluetoothScannerPageState createState() => _BluetoothScannerPageState();
}

class _BluetoothScannerPageState extends State<BluetoothScannerPage> {
  List<ScanResult> devices = [];
  String deviceId = "Unknown";
  String macAddress = "Unavailable";

  @override
  void initState() {
    super.initState();
    requestPermissions();
    fetchDeviceInfo();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
      Permission.phone
    ].request();
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

  void startScan() {
    devices.clear();
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        devices = results;
      });
    });
  }

  Widget buildDeviceTile(ScanResult result) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
            result.device.name.isEmpty ? "Unknown Device" : result.device.name),
        subtitle: Text(result.device.id.id),
        trailing: Text("RSSI: ${result.rssi}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Scanner'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Device ID: $deviceId", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text("MAC Address: $macAddress",
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: startScan,
            icon: Icon(Icons.bluetooth_searching),
            label: Text("Scan for Devices"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: devices.isEmpty
                ? Center(child: Text("No devices found"))
                : ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) =>
                        buildDeviceTile(devices[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
