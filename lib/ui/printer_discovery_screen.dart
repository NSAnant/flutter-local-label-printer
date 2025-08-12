// printer_discovery_screen.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printapp/models/printer_model.dart';
import '../database/db_helper.dart';

class PrinterDiscoveryScreen extends StatefulWidget {
  const PrinterDiscoveryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PrinterDiscoveryScreenState createState() => _PrinterDiscoveryScreenState();
}

class _PrinterDiscoveryScreenState extends State<PrinterDiscoveryScreen> {
  List<PrinterModel> discoveredPrinters = [];
  List<PrinterModel> savedPrinters = [];
  bool isDiscovering = false;
  bool isTestConnectionSuccessful = false;
  TextEditingController manualIpController = TextEditingController();
  TextEditingController manualNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSavedPrinters();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await [Permission.location, Permission.locationWhenInUse].request();
  }

  Future<void> discoverPrinters() async {
    setState(() => isDiscovering = true);
    List<PrinterModel> tempList = [];

    for (int i = 255; i >= 1; i--) {
      final ip = '192.168.31.$i';
      try {
        final socket = await Socket.connect(
          ip,
          9100,
          timeout: Duration(milliseconds: 200),
        );
        final name = 'Unknown Printer';
        tempList.add(PrinterModel(name: name, ip: ip));
        socket.destroy();
      } catch (_) {
        // skip unreachable
      }
    }
    setState(() {
      discoveredPrinters = tempList;
      isDiscovering = false;
    });
  }

  Future<bool> testConnection(String ip) async {
    bool isConnected = false;
    try {
      final socket = await Socket.connect(
        ip,
        9100,
        timeout: Duration(milliseconds: 200),
      );
      socket.destroy();
      isConnected = true;
    } catch (_) {
      // skip unreachable
    }
    return isConnected;
  }

  void savePrinter(PrinterModel printer) async {
    await DBHelper.savePrinter(printer.name, printer.ip);
    Navigator.pop(context, printer);
  }

  void getSavedPrinters() async {
    final printers = await DBHelper.getSavedPrinter();
    setState(() {
      if (printers.isNotEmpty) {
        savedPrinters = printers;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Printer'),
        actions: [
          IconButton(
            onPressed: _discoverPrinters,
            icon: Icon(Icons.network_check_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isDiscovering) LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: manualNameController,
                  decoration: InputDecoration(labelText: 'Printer Name'),
                ),
                TextField(
                  controller: manualIpController,
                  decoration: InputDecoration(labelText: 'Manual IP'),
                ),
                ElevatedButton(
                  onPressed: _onTestConnectionManualPrinter,
                  child: Text("Test Connection'"),
                ),
                ElevatedButton(
                  onPressed: _onSaveManualPrinterButton,
                  child: Text('Save Manual Printer'),
                ),
              ],
            ),
          ),
          if (discoveredPrinters.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: discoveredPrinters.length,
                itemBuilder: (context, index) {
                  final printer = discoveredPrinters[index];
                  return ListTile(
                    title: Text(printer.name ?? ''),
                    subtitle: Text(printer.ip ?? ''),
                    trailing: Icon(Icons.print),
                    onTap: () => savePrinter(printer),
                  );
                },
              ),
            ),
          if (savedPrinters.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: savedPrinters.length,
                itemBuilder: (context, index) {
                  final printer = savedPrinters[index];
                  return ListTile(
                    title: Text(printer.name ?? ''),
                    subtitle: Text(printer.ip ?? ''),
                    trailing: Icon(Icons.print),
                    onTap: () => Navigator.pop(context, printer),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _onTestConnectionManualPrinter() async {
    if (manualIpController.text.isNotEmpty) {
      testConnection(manualIpController.text).then((isConnected) {
        if (isConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Connection successful to ${manualIpController.text}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to connect to ${manualIpController.text}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the IP address of printer to test.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onSaveManualPrinterButton() {
    if (manualIpController.text.isNotEmpty) {
      testConnection(manualIpController.text).then((isConnected) {
        if (isConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Connection successful to ${manualIpController.text}',
              ),
              backgroundColor: Colors.green,
            ),
          );
          savePrinter(
            PrinterModel(
              name:
                  manualNameController.text.isNotEmpty
                      ? manualNameController.text
                      : 'Manual Printer',
              ip: manualIpController.text,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to connect to ${manualIpController.text}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the IP address of printer to save.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _discoverPrinters() {
    if (!isDiscovering) {
      discoverPrinters();
    }
  }
}
