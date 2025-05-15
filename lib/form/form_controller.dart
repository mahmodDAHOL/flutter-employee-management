import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

import '../controllers/sharedpreferences_controlelr.dart';
import '../helper.dart';
import '../image_upload/image_upload_controller.dart';
import '../models/form_field_model.dart';

class FormController extends GetxController {
  final sharedPreferencesController = Get.put(SharedPreferencesController());
  UploadImageController uploadImageController = Get.put(
    UploadImageController(),
  );
  RxMap formValues = {}.obs;

  Future<List<FormFieldData>> loadFieldsFromAsset(bool forEditing) async {
    String jsonString = await rootBundle.loadString('assets/fields.json');

    List<dynamic> parsedJson = jsonDecode(jsonString);
    List<FormFieldData> fields =
        parsedJson
            .map((item) => FormFieldData.fromJson(item as Map<String, dynamic>))
            .toList();

    if (forEditing) {
      fields.removeAt(0);
    }

    return fields;
  }

  Future<void> submit(BuildContext context) async {
    final prefs = await sharedPreferencesController.prefs;

    String formValuesencoded = jsonEncode(formValues);
    prefs.setString("${formValues['id']}", formValuesencoded);
    await showAutoDismissDialog(context, "Your Information Saved");
  }
}
