import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerProvider extends ChangeNotifier {
  Barcode? result;
  QRViewController? controller;
  bool isLoading = false;
  String? urCode;
  String clientUrl = '';
  String? coCode;
  String urnNO = '';

  // Camera control
  Future<void> toggleFlash() async {
    await controller?.toggleFlash();
    notifyListeners();
  }

  Future<void> flipCamera() async {
    await controller?.flipCamera();
    notifyListeners();
  }

  Future<void> pauseCamera() async {
    await controller?.pauseCamera();
    notifyListeners();
  }

  Future<void> resumeCamera() async {
    await controller?.resumeCamera();
    notifyListeners();
  }

  void setController(QRViewController ctrl) {
    controller = ctrl;
    notifyListeners();
  }

  void setResult(Barcode barcode) {
    result = barcode;
    notifyListeners();
  }
}
