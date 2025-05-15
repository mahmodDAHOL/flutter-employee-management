import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../form/form_screen.dart';
import 'qr_code.controller.dart';

class QRCodeScreen extends StatelessWidget {
  QRCodeController qRCodeController;

  QRCodeScreen({super.key, required this.qRCodeController});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Code to Image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: qRCodeController.globalKey,
              child: QrImageView(
                data: qRCodeController.currentUuid.value,
                size: 200,
                gapless: true,
              ),
            ),
            const SizedBox(height: 20),
            Text("UUID: ${qRCodeController.currentUuid}"),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Get.to(() => DynamicForm(forEditing: false));
              },
              icon: const Icon(Icons.add),
              label: const Text("اضف اسم اخر"),
            ),
          ],
        ),
      ),
    );
  }
}
