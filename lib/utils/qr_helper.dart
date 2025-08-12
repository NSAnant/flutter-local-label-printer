// qr_helper.dart

import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class QRHelper {
  static Widget generateQR(String data, {double size = 60}) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      gapless: true,
      backgroundColor: Colors.white,
    );
  }
}
