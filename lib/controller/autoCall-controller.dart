import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/services/autoCall-services.dart';
import 'package:permission_handler/permission_handler.dart';

class AutoCallController extends GetxController {

  final AutoCallService autoCallService = Get.find();
  final RxList<Map<String, dynamic>> numbers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNumbers();
  }

  Future<void> fetchNumbers() async {
    try {
      final result = await autoCallService.fetchNumbersFromApi();
      numbers.value = result;
      print(numbers);
    } catch (error) {
      print(error);
    }
  }
}