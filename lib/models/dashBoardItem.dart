

class DashboardItem {
  final String title;
  final String description;
  final String status;
  final String? extra;

  DashboardItem({
    required this.title,
    required this.description,
    required this.status,
    this.extra,
  });
}
