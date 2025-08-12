import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

import '../models/products.dart';
import '../database/db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];
  List<Product> filteredProducts = [];
  String searchQuery = "";
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await DBHelper.getProducts();
    setState(() {
      _products = products;
      filteredProducts = products; // Initialize filtered list with all products
    });
  }

  Future<void> _selectProduct(Product product) async {
    product.isSelected = true; // Mark product as selected
    await DBHelper.selectProduct(product);
    Navigator.pop(context, product); // Return selected product to HomeScreen
  }

  Future<void> _addNewProductDialog() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController idController = TextEditingController();

    final result = await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Add Product"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'Product ID'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final id = idController.text.trim();
                  if (name.isNotEmpty && id.isNotEmpty) {
                    final newProduct = Product(
                      name: name,
                      productId: id,
                      unit: 'pcs',
                      price: "0",
                      isSelected: false,
                    );
                    DBHelper.insertProduct(
                      newProduct,
                    ).then((_) => _loadProducts());
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  Future<void> _importFromCSV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.first.path!);
      final contents = await file.readAsString();

      final csvRows = const CsvToListConverter().convert(contents, eol: '\n');

      // Expecting CSV format: Product Name, Product ID
      for (var row in csvRows.skip(1)) {
        if (row.length >= 2) {
          final product = Product(
            name: row[1].toString(),
            productId: row[0].toString(),
            unit: 'pcs',
            price: '00',
            isSelected: false,
          );
          await DBHelper.insertProduct(product);
        }
      }

      _loadProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CSV imported successfully")),
      );
    }
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredProducts =
          _products.where((product) {
            return product.name.toLowerCase().contains(searchQuery) ||
                product.id.toString().contains(searchQuery);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: "Import CSV",
            onPressed: _importFromCSV,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Add Product",
            onPressed: _addNewProductDialog,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: "Search by Product Name or ID",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body:
          filteredProducts.isEmpty
              ? const Center(child: Text("No products available"))
              : ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text("ID: ${product.productId}"),
                    trailing:
                        product.isSelected
                            ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                            : null,
                    onTap: () => _selectProduct(product),
                  );
                },
              ),
    );
  }
}
