class TaskModel {
  final int count;
  final String? next;
  final String? previous;
  final List<Task> results;

  TaskModel({
    required this.count,
    this.next,
    this.previous,
    required this.results

  });
  factory TaskModel.fromJson(Map<String,dynamic> json){
    return TaskModel(
      count: json['count']??0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
class Task {
  final String id;
  final String projectName;
  final String? assignedToName;
  final String? createdByName;
  final bool isDeleted;
  final String? deletedAt;
  final String title;
  final String slug;
  final String description;
  final String priority;
  final String status;
  final String? dueDate;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final String? deletedBy;
  final String project;
  final int assignedTo;
  final int createdBy;

  Task({
    required this.id,
    required this.projectName,
    this.assignedToName,
    this.createdByName,
    required this.isDeleted,
    this.deletedAt,
    required this.title,
    required this.slug,
    required this.description,
    required this.priority,
    required this.status,
    this.dueDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedBy,
    required this.project,
    required this.assignedTo,
    required this.createdBy,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      projectName: json['project_name'],
      assignedToName: json['assigned_to_name'],
      createdByName: json['created_by_name'],
      isDeleted: json['is_deleted'] ?? false,
      deletedAt: json['deleted_at'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      priority: json['priority'],
      status: json['status'],
      dueDate: json['due_date'],
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedBy: json['deleted_by']?.toString(),
      project: json['project'],
      assignedTo: json['assigned_to'],
      createdBy: json['created_by'],
    );
  }
}