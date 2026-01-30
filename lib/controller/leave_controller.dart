import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/models/leave_model.dart';
import 'package:nexuscrm/services/leave_service.dart';

class LeaveController extends GetxController{
  final _service=LeaveService();
  var leave=<LeaveModel>[].obs;
  var isLoading=false.obs;
   final RxString selectedLeaveType="".obs;
  final formKey=GlobalKey<FormState>();
  final TextEditingController reasonController=TextEditingController();
  final TextEditingController startDateController=TextEditingController();
  final TextEditingController endDateController=TextEditingController();

  final List<String> leaveType=[
    'Birthday Leave',
    'Casual',
    'Compensatory off',
    'Earned Leave',
     'Elite Leave',
    'Leave Without Pay',
    'Paternity Leave',
    'Sick Leave'
  ];




  @override onInit(){
    super.onInit();
    getLeaves();
  }

  Future<void> getLeaves() async {
    isLoading.value=true;
    final result= await _service.getLeaveData();
    if (result.isNotEmpty) {
      leave.value = result;
    }
    else {
      leave.clear();
      Get.snackbar("Error", "No leaves found");
    }
    isLoading.value = false;
  }

  Future<void> addLeave()async{
    isLoading.value=true;
    final result=await _service.addLeave(selectedLeaveType.value,startDateController.text,endDateController.text,reasonController.text);
    if(result){
       Get.back();
       Fluttertoast.showToast(
         msg: 'leave added successfully',
         backgroundColor: Colors.green,
         textColor: Colors.white,);
       getLeaves();
    }else{
      Fluttertoast.showToast(msg: 'leave added successfully',
        backgroundColor: Colors.red,
        textColor: Colors.white,);
    }
    isLoading.value=false;
  }
}