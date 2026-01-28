class AttendanceRecord {
  final String uid;
  final String date;
  final String? checkIn;
  final String? checkOut;
  final String? status;
  final int? lateMinutes;
  final String? workingHours;

  AttendanceRecord({
    required this.uid,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.status,
    this.lateMinutes,
    this.workingHours,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      uid: json['uid'] ?? '',
      date: json['date'] ?? '',
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      status: json['status'],
      lateMinutes: json['late_minutes'],
      workingHours: json['working_hours'],
    );
  }
}
