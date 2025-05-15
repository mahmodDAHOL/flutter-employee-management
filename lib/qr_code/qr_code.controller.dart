import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class QRCodeController extends GetxController {
  final uuid = Uuid();
  final GlobalKey globalKey = GlobalKey();

  late RxString currentUuid;

  @override
  void onInit() {
    super.onInit();
    currentUuid =  Uuid().v4().obs;
  }

}