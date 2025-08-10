import 'dart:io';
import 'package:printapp/models/printer_model.dart';

import '../models/products.dart';

class TSCPrinter {
  static Future<bool> printProductLabel(Product product, int qty) async {
    try {
      final socket = await Socket.connect(
        "192.168.31.254",
        9100,
        timeout: const Duration(seconds: 5),
      );
      String tspl = '''
SIZE 35 mm,15 mm
GAP 3 mm,0
DIRECTION 0
CLS
TEXT 210,15,"1",0,2,1,1,"NCM"
TEXT 5,10,"1",0,2,1,0,"${product.productId}"
BLOCK 5,30,200,30,"2",0,1,1,"${product.name}"
TEXT 5,80,"2",0,1,1,0,"Rs."
BLOCK 50,80,200,30,"3",0,1,1,"${product.price}"
TEXT 230,100,"1",0,1,1,0,"${product.unit}"
QRCODE 225,40,H,2,A,0,"${product.productId}"
PRINT 1,$qty
''';

      socket.write(tspl);
      await socket.flush();
      await socket.close();

      return true;
    } catch (_) {
      return false;
    }
  }
}

//TEXT 50,75,"3",0,1,1,0,"${product.price}/-"
//TEXT 10,25,"2",0,1,1,0,"${product.productId}.${product.name}"
// TEXT 10,110,"0",0,12,12,"FONT 0"
// TEXT 10,160,"1",0,1,1,"FONT 1"
// TEXT 10,210,"2",0,1,1,"FONT 2"
// TEXT 10,260,"3",0,1,1,0,"FONT 3"
// TEXT 10,310,"4",0,1,1,0,"FONT 4"
// TEXT 10,360,"5",0,1,1,0,"FONT 5"
// TEXT 10,410,"6",0,1,1,1,"FONT 6"
// TEXT 10,460,"7",0,1,1,1,"FONT 7"
// TEXT 10,510,"8",0,1,1,1,"FONT 8"
