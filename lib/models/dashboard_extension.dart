// --------------------------
// Project → DashboardItem
// --------------------------
import 'package:nexuscrm/models/project_model.dart';
import 'package:nexuscrm/models/task_model.dart';

import 'dashBoardItem.dart';

extension ProjectUIMapper on Project {
  DashboardItem toDashboardItem() {
    return DashboardItem(
      title: name,
      description: description,
      status: status ,
      extra: startDate,
    );
  }
}

// --------------------------
// Task → DashboardItem
// --------------------------
extension TaskUIMapper on Task {
  DashboardItem toDashboardItem() {
    return DashboardItem(
      title: projectName,
      description: description,
      status: status,
      extra: title, // project_name
    );
  }}