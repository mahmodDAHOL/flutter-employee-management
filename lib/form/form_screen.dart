
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_screen.dart';
import '../image_upload/image_upload_controller.dart';
import '../models/field_type_model.dart';
import '../models/form_field_model.dart';
import '../qr_code/qr_code.controller.dart' show QRCodeController;
import '../qr_code/qr_code_screen.dart';
import 'form_controller.dart';

class DynamicForm extends StatelessWidget {
  final FormController controller = Get.put(FormController());
  UploadImageController uploadImageController = Get.put(
    UploadImageController(),
  );
  final QRCodeController qrCodeController = Get.put(QRCodeController());

  final bool forEditing;
  final Map<String, dynamic>? data;

  DynamicForm({super.key, required this.forEditing, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<FormFieldData>>(
        future: controller.loadFieldsFromAsset(forEditing),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}\n\n${snapshot.stackTrace}"),
            );
          } else if (snapshot.hasData) {
            List<FormFieldData> fields = snapshot.data!;
            return ListView(
              children: [
                ...fields.map((field) {
                  return _buildFieldWidget(field, controller, context, data);
                }),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller
                          .submit(context)
                          .then((_) {
                            if(forEditing){
                            Get.offAll(() => HomeScreen());
                            }else{
                            Get.offAll(() => QRCodeScreen(qRCodeController: qrCodeController,));
                            }

                          });
                    },
                    child: Text("حفظ"),
                  ),
                ),
              ],
            );
          }
          return Text("There is no fields to show");
        },
      ),
    );
  }

  Widget _buildFieldWidget(
    FormFieldData field,
    FormController controller,
    BuildContext context,
    Map? data,
  ) {
    if (data != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.formValues.value = data;
        controller.formValues.refresh();
      });
    }

    switch (field.type) {
      case FieldType.id:
        final fieldValue = controller.formValues[field.fieldName]?.toString();
        final uuidValue = qrCodeController.currentUuid.value;

        if (fieldValue == null) {
          controller.formValues[field.fieldName] = uuidValue;
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            readOnly: true,
            controller: TextEditingController(text: uuidValue),
            decoration: InputDecoration(labelText: field.label),
          ),
        );

      case FieldType.text:
        return Obx(
          () => Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: TextEditingController(
                text: controller.formValues[field.fieldName]?.toString() ?? '',
              ),
              decoration: InputDecoration(labelText: field.label),
              onChanged: (value) {
                controller.formValues[field.fieldName] = value.toString();
              },
            ),
          ),
        );

      case FieldType.select:
        return Obx(() {
          return ListTile(
            title: Text(field.label ?? field.fieldName),
            subtitle: Text(
              controller.formValues[field.fieldName]?.toString() ??
                  "Select Option",
            ),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    children:
                        (field.options ?? [])
                            .map<Widget>(
                              (option) => ListTile(
                                title: Text(option),
                                onTap: () {
                                  controller.formValues[field.fieldName] =
                                      option.toString();
                                  Get.back();
                                },
                              ),
                            )
                            .toList(),
                  );
                },
              );
            },
          );
        });

      case FieldType.date:
        return Obx(() {
          return ListTile(
            title: Text(field.label ?? field.fieldName),
            subtitle: Text(
              controller.formValues[field.fieldName]?.toString() ??
                  "Select Date",
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.parse(
                  controller.formValues[field.fieldName] ??
                      DateTime.now().toIso8601String(),
                ),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                controller.formValues[field.fieldName] = picked.toString();
              }
            },
          );
        });

      case FieldType.check:
        return Obx(() {
          return ListTile(
            title: Text(field.label ?? field.fieldName),
            trailing: Checkbox(
              value:
                  controller.formValues[field.fieldName] == 1 ||
                  controller.formValues[field.fieldName] == true,
              onChanged: (value) {
                controller.formValues[field.fieldName] = value;
                controller.formValues.refresh();
              },
            ),
          );
        });
      case FieldType.image:
        return getImageField();
      case FieldType.hidden:
        return SizedBox(height: 1);
      default:
        return Text(field.fieldName, style: TextStyle(color: Colors.red));
    }
  }

  Widget getImageField() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            uploadImageController.image.value == ''
                ? uploadImageController.buildUploadField(controller)
                : uploadImageController.buildImageWithChangeOption(controller),
      );
    });
  }
}
