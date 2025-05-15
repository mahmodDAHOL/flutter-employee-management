import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../form/form_controller.dart';


class UploadImageController extends GetxController {
  final picker = ImagePicker();
  final RxString image = ''.obs;

  void setImage(dynamic file) {
    image.value = file;
  }

  void clearImage() {
    image.value = '';
  }

  void pickImage(FormController controller) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image.value = pickedFile.path;
      controller.formValues['image'] = image.value;
      controller.formValues.refresh();
    }
  }

  Widget buildUploadField(controller) {
    // return Obx(() {
    return InkWell(
      onTap: () => pickImage(controller),
      child: Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[300],

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text('Tap to Upload Image', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
    // });
  }

  Widget buildImageWithChangeOption(controller) {
    return Obx(
      () => Stack(
        alignment: Alignment.center,
        children: [
          Image.file(
            File(image.value!),
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
          Positioned(
            bottom: 10,
            child: ElevatedButton.icon(
              onPressed: () => pickImage(controller),
              icon: const Icon(Icons.edit),
              label: const Text("تغيير الصورة"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.6),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
