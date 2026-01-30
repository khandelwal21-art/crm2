import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nexuscrm/models/project_model.dart';
import 'package:nexuscrm/models/task_model.dart';

class ItStaffDashboardService  extends GetxService{
final storage=GetStorage();
late final token =storage.read('token');


  Future<ProjectModel> getProjectsAssigned()async{

    try{
      final response=await http.get(
        Uri.parse("http://18.138.124.3/api/projects/projects/"),
          headers: {
          'Authorization':'Token $token',
            'Content-Type':"application/json"
          }
      );
      if(response.statusCode==200||response.statusCode==201){
        final Map<String,dynamic> projects=jsonDecode(response.body);
        return ProjectModel.fromJson(projects);
      }
      else{
        throw Exception('Failed to fetch projects');
      }

    }catch(e){
      throw Exception('Failed to fetch projects');


    }

  }

  Future<TaskModel> getAllAssignedTasks()async{
    try{
      final response=await http.get(Uri.parse("http://18.138.124.3/api/projects/tasks/"),
      headers: {
        'Authorization':"Token $token",
        'Content-Type':"application/json"
      });
      if(response.statusCode==200||response.statusCode==201){
        final Map<String,dynamic> tasks=jsonDecode(response.body);
        return TaskModel.fromJson(tasks);
      }else{
        throw Exception('Failed to fetch projects');
      }
    }catch(e){
      throw Exception('Failed to fetch projects');

    }
    
}







}