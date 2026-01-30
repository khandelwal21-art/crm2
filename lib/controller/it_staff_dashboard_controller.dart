import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/models/task_model.dart';
import 'package:nexuscrm/services/it_staff_dashboard_service.dart';

import '../models/project_model.dart';

class ItStaffDashboardController extends GetxController{
  ItStaffDashboardController() {
    debugPrint("🔥 Controller constructor called");
  }
  final List<Map<String, dynamic>> cardItems = [
    {'icon': Icons.show_chart_rounded, 'color': Color(0xFF9C27B0), 'title': "Total Projects"},
    {'icon': Icons.people_alt_rounded, 'color': Color(0xFF2196F3), 'title': "Total Tasks"},
    {'icon': Icons.public_rounded, 'color': Color(0xFFFF9800), 'title': "Total Completed Tasks"},
    {'icon': Icons.work_outline_rounded, 'color': Color(0xFFF44336), 'title': "Total Pending tasks"},
  ];

  final ItStaffDashboardService service=Get.find();
  var isLoading = false.obs;
  var projects = <Project>[].obs;
  var recentProjects = <Project>[].obs;

  var tasks=<Task>[].obs;
  var pendingTasks=<Task>[].obs;
  var completedTasks=<Task>[].obs;

  // Observable stats
  var totalProjects = 0.obs;
  var totalTasks = 0.obs;
  var completedTasksCount = 0.obs;
  var pendingTasksCount = 0.obs;

  @override
  void onInit(){
    super.onInit();
    debugPrint("on Init called");
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    await getAssignedProject();
    await getAllTasks();
  }
  Future<void> getAssignedProject()async{
    try{
      isLoading.value=true;
      ProjectModel result =await service.getProjectsAssigned();
      totalProjects.value=result.count;
      projects.assignAll(result.results);
      //getting recent projects
      final list = projects.toList();
      list.sort((a, b) => b.startDate.compareTo(a.startDate));
      recentProjects.value= list.take(5).toList();
    }catch(e){
       Fluttertoast.showToast(msg: e.toString());
    }finally{
      isLoading.value=false;
    }


  }

  Future<void> getAllTasks()async{
    try{
      isLoading.value=true;
      TaskModel result =await service.getAllAssignedTasks();
      totalTasks.value=result.count;
      //get all the tasks
      tasks.assignAll(result.results);
      //fetch pending tasks
      pendingTasks.value= result.results.where((task)=>task.status.toUpperCase()=='IN_PROGRESS').toList();
      pendingTasksCount.value=pendingTasks.length;
      //completed tasks
      completedTasks.value=result.results.where((task)=>task.status.toUpperCase()=="DONE").toList();
      completedTasksCount.value=completedTasks.length;
    }catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }finally{
      isLoading.value=false;
    }

  }

  List<Project> getProjectList() => projects;
  List<Task> getTaskList() => tasks;
  List<Task> getPendingTaskList() => pendingTasks;
  List<Task> getCompletedTaskList() => completedTasks;

}