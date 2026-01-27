class AttendanceMonthResponse {
  final String month;
  final List<CalendarDay> calendar;

  AttendanceMonthResponse({required this.month, required this.calendar});

  factory AttendanceMonthResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceMonthResponse(
      month: json['month'] ?? '',
      calendar: (json['calendar'] as List)
          .map((day) => CalendarDay.fromJson(day))
          .toList(),
    );
  }
}

class CalendarDay {
  final String date;
  final int day;
  final String weekday;
  final String status;
  final String? checkIn;
  final String? checkOut;
  final String? workingHours;

  CalendarDay({
    required this.date,
    required this.day,
    required this.weekday,
    required this.status,
    this.checkIn,
    this.checkOut,
    this.workingHours,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      date: json['date'] ?? '',
      day: json['day'] ?? 0,
      weekday: json['weekday'] ?? '',
      status: json['status'] ?? '',
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      workingHours: json['working_hours'],
    );
  }
}