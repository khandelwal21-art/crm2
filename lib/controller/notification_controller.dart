import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../services/web_socket_service.dart';


class NotificationController extends GetxController {
  final WebSocketService ws = WebSocketService();

  var notifications = <NotificationModel>[].obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();

    ws.connect();

    ws.notificationStream.listen((data) {
      notifications.insert(0, NotificationModel.fromJson(data));
    });
  }

  void markAllRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }
}
