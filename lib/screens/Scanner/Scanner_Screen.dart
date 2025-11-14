import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../GlobalComponents/PreferenceManager.dart';
import '../Production/Production_Form/Production_Form_Screen.dart';
import 'Provider/Scanner_Provider.dart';

class Scanner_Screen extends StatefulWidget {
  const Scanner_Screen({Key? key}) : super(key: key);

  @override
  State<Scanner_Screen> createState() => _Scanner_ScreenState();
}

class _Scanner_ScreenState extends State<Scanner_Screen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    final provider = context.read<ScannerProvider>();
    if (Platform.isAndroid) {
      provider.controller?.pauseCamera();
    }
    provider.controller?.resumeCamera();
  }

  @override
  void initState() {
    super.initState();

    PreferenceManager preferenceManager = PreferenceManager.instance;

    preferenceManager.getStringValue("urCode").then((value) {
      context.read<ScannerProvider>().urCode = value;
    });

    preferenceManager.getStringValue("clientUrl").then((value) {
      context.read<ScannerProvider>().clientUrl = value;
    });

    preferenceManager.getStringValue("coCode").then((value) {
      context.read<ScannerProvider>().coCode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScannerProvider>();

    return Scaffold(
      body: Stack(
        children: [
          provider.isLoading
              ? Center(
                  child: Lottie.asset(
                    'images/loading.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                )
              : _buildQrView(context, provider),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildControlButton(
                  onPressed: provider.toggleFlash,
                  icon: const Icon(Icons.flash_on, color: Colors.white),
                  label: 'Flash',
                ),
                _buildControlButton(
                  onPressed: provider.flipCamera,
                  icon: const Icon(Icons.cameraswitch, color: Colors.white),
                  label: 'Rotate',
                ),
                _buildControlButton(
                  onPressed: provider.pauseCamera,
                  icon: const Icon(Icons.pause, color: Colors.white),
                  label: 'Pause',
                ),
                _buildControlButton(
                  onPressed: () async {
                    final provider = context.read<ScannerProvider>();
                    await provider.controller?.stopCamera();   // stop preview
                    provider.controller?.dispose();      // release resources

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Production_Form_Screen()),
                    );
                  },
                  icon: const Icon(Icons.play_circle, color: Colors.white),
                  label: 'Start',
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required Widget icon,
    required String label,
  }) {
    return Flexible(
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding:
                  EdgeInsets.zero, // important so gradient covers full area
              backgroundColor: Colors.transparent, // remove default bg
              shadowColor: Colors.transparent,
            ),
            onPressed: onPressed,
            child: Ink(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFA07A),
                    Color(0xFFFF4C4C)
                  ], // orange → red
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Container(
                width: 60, // set size of button
                height: 60,
                alignment: Alignment.center,
                child: icon,
              ),
            ),
          ),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context, ScannerProvider provider) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: (ctrl) => _onQRViewCreated(ctrl, provider),
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),

      onPermissionSet: (ctrl, p) {
        if (!p) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera Permission Denied')),
          );
        } else {
          ctrl.resumeCamera();
        }
      },
    );
  }


  void _onPermissionSet(BuildContext context, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller, ScannerProvider provider) {
    provider.setController(controller);
    controller.stopCamera();
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && scanData.code!.isNotEmpty) {
        provider.setResult(scanData);
        log("Barcode: ${scanData.code}");
        controller.stopCamera();
      }
    });
  }

  @override
  void dispose() {
    final provider = context.read<ScannerProvider>();
    provider.controller?.dispose();
    super.dispose();
  }

}
