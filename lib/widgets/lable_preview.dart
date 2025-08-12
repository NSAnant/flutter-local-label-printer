import 'package:flutter/material.dart';
import '../models/products.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LabelPreview extends StatelessWidget {
  final Product product;

  const LabelPreview({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 35 / 15,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        'Rs. ${product.price}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(product.unit, style: const TextStyle(fontSize: 9)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.grey.shade300,
                child: Center(
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.qr_code, size: 28),
                        Text(
                          product.productId,
                          style: const TextStyle(fontSize: 6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TsplLabelPreview extends StatelessWidget {
  final double labelWidthMm = 35;
  final double labelHeightMm = 15;
  final double dpi = 200; // typical TSPL printer DPI

  final Product product;
  final int qty;

  const TsplLabelPreview({super.key, required this.product, required this.qty});

  double mmToPx(double mm) {
    return mm * (dpi / 25.4);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8),
      child: Container(
        width: mmToPx(labelWidthMm),
        height: mmToPx(labelHeightMm),
        color: Colors.white,
        child: Stack(
          children: [
            // NCM (TEXT 210,15)
            Positioned(
              left: 210,
              top: 15,
              child: Text(
                "NCM",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            // Product ID (TEXT 5,10)
            Positioned(
              left: 5,
              top: 10,
              child: Text(product.productId, style: TextStyle(fontSize: 14)),
            ),
            // Product Name (BLOCK 5,30,200,30)
            Positioned(
              left: 5,
              top: 30,
              width: 200,
              height: 30,
              child: Text(
                product.name,
                style: TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Rs. (TEXT 5,80)
            Positioned(
              left: 5,
              top: 80,
              child: Text("Rs.", style: TextStyle(fontSize: 12)),
            ),
            // Price (BLOCK 50,80,200,30)
            Positioned(
              left: 50,
              top: 80,
              width: 200,
              height: 30,
              child: Text(
                product.price,
                style: TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Unit (TEXT 230,100)
            Positioned(
              left: 230,
              top: 100,
              child: Text(product.unit, style: TextStyle(fontSize: 10)),
            ),
            // QR Code (QRCODE 225,40)
            Positioned(
              left: 225,
              top: 40,
              width: 40,
              height: 40,
              child: Center(
                child: QrImageView(
                  data: product.productId,
                  size: 100,
                  version: QrVersions.auto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
