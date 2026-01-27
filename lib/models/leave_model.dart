class LeaveModel {
  int? id;
  String? leaveType;
  String? startDate;
  String? endDate;
  String? reason;
  String? status;
  int? totalDays;

  LeaveModel({
    this.id,
    this.leaveType,
    this.startDate,
    this.endDate,
    this.reason,
    this.status,
    this.totalDays,
  }
  );

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
        id: json['id'],
        leaveType: json['leave_type'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        reason: json['reason'],
        status: json['status'],
        totalDays: json['total_days']
    );
  }
}