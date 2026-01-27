class AttendanceTracker {
  final int presentDays;
  final int absentDays;
  final int lateArrivals;
  final double avgWorkingHours;

  AttendanceTracker({
    required this.presentDays,
    required this.absentDays,
    required this.lateArrivals,
    required this.avgWorkingHours,
  });

  factory AttendanceTracker.fromJson(Map<String, dynamic> json) {
    return AttendanceTracker(
      presentDays: json['present_days'] ?? 0,
      absentDays: json['absent_days'] ?? 0,
      lateArrivals: json['late_arrivals'] ?? 0,
      // API returns 0.01, ensuring it's treated as double
      avgWorkingHours: (json['avg_working_hours'] ?? 0.0).toDouble(),
    );
  }
}