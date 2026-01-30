import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/lead_response.dart';
import '../services/autoCall-services.dart';

class AutoCallController extends GetxController {
  final AutoCallService service = Get.find();

  final Rx<LeadsResponse?> leads = Rx<LeadsResponse?>(null);
  final RxList<Map<String, dynamic>> numbers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLeads();
  }

  Future<void> loadLeads() async {
    leads.value = await service.fetchDashboard();

    if (leads.value == null) return;

    final results = leads.value!.results ?? [];

    numbers.value = results.map<Map<String, dynamic>>((item) {
      return {
        'id': item['id'], // ✅ correct
        'number': item['call']?.toString() ?? '',
        'name': item['name'] ?? 'Unknown',
        'isInterested': false,
      };
    }).toList();
  }

  Future<bool> updateLead({
  required int leadId,
  required bool isInterested,
  }) async {

  String status = isInterested ? "Interested" : "Not Interested";

  bool result = await service.updateLeadStatus(
  leadId: leadId,
  status: status,
  );

  return result;
  }
  }


