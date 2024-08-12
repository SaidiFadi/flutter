import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'home_screen.dart';

class ScanScreen extends StatefulWidget {
  final Order order;
  final Function(Order) onStatusChange;

  ScanScreen({required this.order, required this.onStatusChange});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedCode = '';
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR/Barcode')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: isScanning
                ? QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  )
                : Center(child: Text('Scanned Code: $scannedCode')),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _toggleScanning,
                  child: Text(isScanning ? 'Stop Scanning' : 'Start Scanning'),
                ),
                ElevatedButton(
                  onPressed: _changeStatus,
                  child: Text('Change Status'),
                ),
                ElevatedButton(
                  onPressed: _showManualEntryDialog,
                  child: Text('Enter Code Manually'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedCode = scanData.code!;
        isScanning = false;
      });
    });
  }

  void _toggleScanning() {
    setState(() {
      isScanning = !isScanning;
      if (isScanning) {
        scannedCode = '';
        controller?.resumeCamera();
      } else {
        controller?.pauseCamera();
      }
    });
  }

  void _changeStatus() {
    if (scannedCode.isNotEmpty) {
      OrderStatus newStatus;
      if (widget.order.status == OrderStatus.waitingPickup) {
        newStatus = OrderStatus.inProgress;
      } else if (widget.order.status == OrderStatus.inProgress) {
        newStatus = OrderStatus.delivered;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order is already delivered')),
        );
        return;
      }

      Order updatedOrder = Order(
        id: widget.order.id,
        status: newStatus,
        customerName: widget.order.customerName,
        address: widget.order.address,
        latitude: widget.order.latitude,
        longitude: widget.order.longitude,
        distance: widget.order.distance,
        placedTime: widget.order.placedTime,
      );

      widget.onStatusChange(updatedOrder);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please scan a code first')),
      );
    }
  }

  void _showManualEntryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String manualCode = '';
        return AlertDialog(
          title: Text('Enter Code Manually'),
          content: TextField(
            onChanged: (value) {
              manualCode = value;
            },
            decoration: InputDecoration(hintText: 'Enter code'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  scannedCode = manualCode;
                  isScanning = false;
                });
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}