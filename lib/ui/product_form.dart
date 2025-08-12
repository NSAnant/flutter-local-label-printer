import 'package:flutter/material.dart';
import '../models/products.dart';
import '../database/db_helper.dart';

class ProductForm extends StatefulWidget {
  final VoidCallback onProductAdded;

  const ProductForm({super.key, required this.onProductAdded});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _productIdController = TextEditingController();

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        name: _nameController.text.trim(),
        unit: _unitController.text.trim(),
        price: _priceController.text.trim(),
        productId: _productIdController.text.trim(),
        isSelected: false,
      );

      await DBHelper.insertProduct(product);
      widget.onProductAdded();

      _nameController.clear();
      _unitController.clear();
      _priceController.clear();
      _productIdController.clear();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Product Name'),
            validator:
                (value) => value == null || value.isEmpty ? 'Enter name' : null,
          ),
          TextFormField(
            controller: _unitController,
            decoration: const InputDecoration(
              labelText: 'Unit (e.g. box, pic)',
            ),
            validator:
                (value) => value == null || value.isEmpty ? 'Enter unit' : null,
          ),
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Price'),
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Enter price' : null,
          ),
          TextFormField(
            controller: _productIdController,
            decoration: const InputDecoration(labelText: 'Product ID'),
            validator:
                (value) => value == null || value.isEmpty ? 'Enter ID' : null,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _saveProduct,
            icon: const Icon(Icons.save),
            label: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}
