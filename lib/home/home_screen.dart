import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/sharedpreferences_controlelr.dart';
import '../form/form_screen.dart';
import '../image_upload/image_upload_controller.dart';
import '../qr_view_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("E-Card App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.person_add),
              label: Text("اضف اسم جديد"),
              onPressed: () {
                Get.to(() => DynamicForm(forEditing: false));
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.search),
              label: Text("ابحث عن اسم"),
              onPressed: () {
                Get.to(QRViewScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeSearchDelegate extends SearchDelegate<Map<String, dynamic>> {
  final sharedPreferencesController = Get.put(SharedPreferencesController());
  final uploadImageController = Get.put(UploadImageController());

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, {});
      },
    );
  }

  Future<Map<String, dynamic>?> getFormValuesFromSharedPreferences(
    String key,
  ) async {
    final prefs = await sharedPreferencesController.prefs;
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      Map<String, dynamic> dataDecoded = jsonDecode(jsonString);
      if (dataDecoded['image'] != '') {
        uploadImageController.setImage(dataDecoded['image']);
      }
      return dataDecoded;
    }
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    final futureFormValues = getFormValuesFromSharedPreferences(query);

    return FutureBuilder<Map<String, dynamic>?>(
      future: futureFormValues,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!;
          return DynamicForm(forEditing: true, data: data);
        } else {
          return Center(child: Text("غير موجود في قاعدة البيانات"));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox(height: 1);
  }
}
