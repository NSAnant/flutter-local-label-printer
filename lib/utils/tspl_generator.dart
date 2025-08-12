import '../models/products.dart';

class TSPLGenerator {
  static String generateTSPL(Product product, {int quantity = 1}) {
    final buffer = StringBuffer();

    for (int i = 0; i < quantity; i++) {
      buffer.writeln('SIZE 38 mm,15 mm');
      buffer.writeln('GAP 1 mm,0');
      buffer.writeln('DENSITY 8');
      buffer.writeln('SPEED 4');
      buffer.writeln('DIRECTION 1');
      buffer.writeln('CLS');

      // Product name (max 2 lines)
      final productName =
          product.name.length > 20
              ? '${product.name.substring(0, 20)}...'
              : product.name;
      buffer.writeln('TEXT 20,20,"0",0,1,1,"$productName"');

      // Price (bold)
      buffer.writeln('TEXT 20,55,"0",0,2,2,"Rs. ${product.price}"');

      // Unit (smaller)
      buffer.writeln('TEXT 250,60,"0",0,1,1,"${product.unit}"');

      // QR Code
      buffer.writeln('QRCODE 250,10,L,5,A,0,"${product.productId}"');

      buffer.writeln('PRINT 1');
    }

    return buffer.toString();
  }
}
