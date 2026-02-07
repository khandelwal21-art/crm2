
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {

  static final WebSocketService _instance=WebSocketService._internal();

  factory WebSocketService(){
    return _instance;
  }

  // ✅ Private named constructor
  WebSocketService._internal();

  WebSocketChannel? _channel;
  Timer? _pingTimer;

  final _projectController=StreamController<Map<String,dynamic>>.broadcast();
  final _tasksController =StreamController<Map<String,dynamic>>.broadcast();
  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();


  Stream<Map<String,dynamic>> get projectStream =>_projectController.stream;
  Stream<Map<String,dynamic>> get tasksStream=>_tasksController.stream;
  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;

  void connect(){
    if(_channel !=null) return;
    final token = GetStorage().read('token');

    _channel=WebSocketChannel.connect(
        Uri.parse('ws://18.138.124.3/ws/notifications/?token=$token')
    );

    debugPrint("WebSocket connected! $_channel");

    _channel!.stream.listen((message){
      debugPrint("WS Message: $message");
      final data =jsonDecode(message);

      if (data['type'] == 'connection') {
        debugPrint("WS Connected Message: ${data['message']}");
        return;
      }
      if (data['notification_type'] == "project") {
        debugPrint("Project Data: ${data['project']}");
        _projectController.add(Map<String, dynamic>.from(data));
      }
      else if(data['notification_type'] =="task"){
        debugPrint("task Data: ${data['project']}");
        _tasksController.add(Map<String,dynamic>.from(data));

      }

      if (data['action'] != null && data['message'] != null) {
        _notificationController.add(Map<String, dynamic>.from(data));
      }



    },
    onError: (error){
      debugPrint("WS Error: $error");
      reconnect();

    },
        onDone: () {
          debugPrint("WS closed");
          reconnect();
        }
    );
    // 🔥 Keep alive ping
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(Duration(seconds: 25), (_) {
      if (_channel != null) {
        _channel!.sink.add(jsonEncode({"type": "ping"}));
      }
    });
  }

  void reconnect() async {
    disconnect();
    await Future.delayed(Duration(seconds: 2));
    connect();
  }
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

}