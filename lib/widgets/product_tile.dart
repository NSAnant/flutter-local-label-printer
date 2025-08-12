import 'package:flutter/material.dart';
import 'package:printapp/ui/preview_screen.dart';
import '../models/products.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        product.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Rs. ${product.price} • ${product.unit}'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PreviewScreen(product: product, qty: 1),
          ),
        );
      },
    );
  }
}
