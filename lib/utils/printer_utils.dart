import 'dart:convert';
import 'dart:io';

class PrinterUtils {
  static Future<void> sendToPrinter({
    required String printerIp,
    required int port,
    required String tsplCode,
  }) async {
    try {
      final socket = await Socket.connect(
        printerIp,
        port,
        timeout: const Duration(seconds: 5),
      );
      socket.add(utf8.encode(tsplCode));
      await socket.flush();
      await socket.close();
      print('✅ Sent to printer: $printerIp:$port');
    } catch (e) {
      print('❌ Printer error: $e');
      rethrow;
    }
  }
}
