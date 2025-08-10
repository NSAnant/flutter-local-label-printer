// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:printapp/ui/preview_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/products.dart';
import '../models/printer_model.dart';
import '../database/db_helper.dart';
import 'product_list_screen.dart';
import 'printer_discovery_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Product? selectedProduct;
  PrinterModel? selectedPrinter;

  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(
    text: '1',
  );
  String selectedUnit = 'pcs';
  final List<String> units = ['pcs', 'box', 'pkg', 'dzn', 'set', 'pair', ''];

  @override
  void initState() {
    super.initState();
    //_loadSelections();
  }

  Future<void> _loadSelections() async {
    final product = await DBHelper.getSelectedProduct();
    final defaultPrinter = await DBHelper.getDefaultPrinter();
    final selectedPriner = await DBHelper.getSelectedPrinter();
    setState(() {
      if (product != null) {
        selectedProduct = product;
      }
      selectedPrinter = selectedPriner ?? defaultPrinter;
    });
  }

  void _navigateToProductList() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductListScreen()),
    );
    if (result != null && result is Product) {
      setState(() => selectedProduct = result);
    }
  }

  void _navigateToPrinterSelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PrinterDiscoveryScreen()),
    );
    if (result != null && result is PrinterModel) {
      setState(() => selectedPrinter = result);
    }
  }

  Widget _buildPrinterSection() {
    if (selectedPrinter != null) {
      return ListTile(
        leading: const Icon(Icons.print),
        title: Text("Printer: ${selectedPrinter!.name}"),
        subtitle: Text(selectedPrinter!.ip),
        trailing: IconButton(
          icon: const Icon(Icons.change_circle_outlined),
          onPressed: _navigateToPrinterSelection,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: _navigateToPrinterSelection,
        child: const Text("Select Printer"),
      );
    }
  }

  Widget _buildProductSection() {
    if (selectedProduct != null) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text("Product: ${selectedProduct!.name}"),
              subtitle: Text("Product ID: ${selectedProduct!.productId}"),
              trailing: IconButton(
                icon: const Icon(Icons.change_circle_outlined),
                onPressed: _navigateToProductList,
              ),
            ),
          ),
          Center(
            child: QrImageView(
              data: selectedProduct!.productId,
              size: 40,
              version: QrVersions.auto,
            ),
          ),
        ],
      );
    } else {
      return ElevatedButton(
        onPressed: _navigateToProductList,
        child: const Text("Select Product"),
      );
    }
  }

  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: priceController,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            labelText: 'Price (Rs.)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: selectedUnit,
          decoration: const InputDecoration(
            labelText: 'Unit',
            border: OutlineInputBorder(),
          ),
          items:
              units
                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                  .toList(),
          onChanged: (value) => setState(() => selectedUnit = value!),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Number of Prints',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Future<void> _onPrintPreview() async {
    if (selectedProduct == null || selectedPrinter == null) {
      _showError("Please select both product and printer.");
      return;
    }
    if (priceController.text.trim().isEmpty) {
      _showError("Please enter a valid price.");
      return;
    }
    if (quantityController.text.trim().isEmpty ||
        int.tryParse(quantityController.text.trim()) == null) {
      _showError("Please enter a valid quantity.");
      return;
    }

    final price = priceController.text.trim();
    final quantity = int.parse(quantityController.text.trim());

    // PrinterHelper.printLabel(
    //   product: selectedProduct!,
    //   printer: selectedPrinter!,
    //   price: price,
    //   unit: selectedUnit,
    //   quantity: quantity,
    // );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => PreviewScreen(
              product: Product(
                name: selectedProduct!.name,
                unit: selectedUnit,
                price: price,
                productId: selectedProduct!.productId,
              ),
              qty: quantity,
            ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NCM Label Printer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPrinterSection(),
              const Divider(height: 32),
              _buildProductSection(),
              const Divider(height: 32),
              _buildInputFields(),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.print),
                label: const Text("Print Preview"),
                onPressed: _onPrintPreview,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
