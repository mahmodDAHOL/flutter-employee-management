import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import 'controllers/sharedpreferences_controlelr.dart';
import 'form/form_screen.dart';
import 'image_upload/image_upload_controller.dart';

class QRViewScreen extends StatefulWidget {
  const QRViewScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRVieScreenState();
}

class _QRVieScreenState extends State<QRViewScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final sharedPreferencesController = Get.put(SharedPreferencesController());
  final uploadImageController = Get.put(UploadImageController());

  Future<Map<String, dynamic>?> getFormValuesFromSharedPreferences(
    String key,
  ) async {
    final prefs = await sharedPreferencesController.prefs;
    String? jsonString = prefs.getString(key);

    if (jsonString != null) {
      Map<String, dynamic> dataDecoded = jsonDecode(jsonString);
      if (dataDecoded['image'] != null) {
        uploadImageController.setImage(dataDecoded['image']);
      }
      return dataDecoded;
    }
    return {'id': null};
  }

  Widget buildResults(BuildContext context) {
    final futureFormValues = getFormValuesFromSharedPreferences(result!.code!);

    return FutureBuilder<Map<String, dynamic>?>(
      future: futureFormValues,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!;
          if (data['id'] != null) {
            // ✅ Safe navigation after frame completes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.to(DynamicForm(forEditing: true, data: data));
            });

            // Show nothing or a placeholder
            return SizedBox.shrink();
          } else {
            controller?.pauseCamera();
            return Column(
              children: [
                SizedBox(height: 20),
                Text("غير موجود في قاعدة البيانات"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await controller?.resumeCamera();
                  },
                  child: const Text(
                    'Scan Again',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          }
        } else {
          return SizedBox(height: 0, width: 0);
        }
      },
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            child: Center(
              child:
                  result != null ? buildResults(context) : Text("امسح رمز QR"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 150.0
            : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('لا يوجد اذن في الوصول')));
    }
  }
}
