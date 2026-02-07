class ProjectModel {
  final int count;
  final String? next;
  final String? previous;
  final List<Project> results;

  ProjectModel({
    required this.count,
    this.next,
    this.previous,
    required this.results

});
  factory ProjectModel.fromJson(Map<String,dynamic> json){
    return ProjectModel(
        count: json['count']??0,
        next: json['next'],
        previous: json['previous'],
        results: (json['results'] as List)
            .map((e) => Project.fromJson(e as Map<String, dynamic>))
            .toList(),
    );
  }
}
class Project {
  final String id;
  final String? createdByName;
  final bool isDeleted;
  final String? deletedAt;
  final String name;
  final String slug;
  final String description;
  final String startDate;
  final String endDate;
  final String status;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final int? deletedBy;
  final int? createdBy;

  Project({
    required this.id,
    this.createdByName,
    required this.isDeleted,
    this.deletedAt,
    required this.name,
    required this.slug,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedBy,
     this.createdBy,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      createdByName: json['created_by_name'],
      isDeleted: json['is_deleted'],
      deletedAt: json['deleted_at'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedBy: json['deleted_by'],
      createdBy: json['created_by'],
    );
  }
}
