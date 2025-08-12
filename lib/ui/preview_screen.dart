import 'package:flutter/material.dart';
import 'package:printapp/widgets/lable_preview.dart';
import 'package:printapp/widgets/printer_status_widget.dart';
import '../models/products.dart';
import '../print/tsc_printer.dart';

class PreviewScreen extends StatelessWidget {
  final Product product;
  final int qty;
  const PreviewScreen({super.key, required this.product, required this.qty});

  void _printLabel(BuildContext context) async {
    final success = await TSCPrinter.printProductLabel(product, qty);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Print sent successfully!' : 'Failed to print'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Label'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printLabel(context),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: TsplLabelPreview(product: product, qty: 1)),
          PrinterStatusWidget(status: "connected"),
        ],
      ),
    );
  }
}
