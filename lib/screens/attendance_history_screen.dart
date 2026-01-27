import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/attandance_tracker.dart';
import '../models/attendance_month_response.dart';

// --- UI DATA MODELS ---
class AttendanceUIModel {
  final String date;
  final String totalHoursHeader;
  final List<AttendanceDetails> records;

  AttendanceUIModel({
    required this.date,
    required this.totalHoursHeader,
    required this.records,
  });
}

class AttendanceDetails {
  final String checkIn;
  final String checkOut;
  final String totalHrs;

  AttendanceDetails({
    required this.checkIn,
    required this.checkOut,
    required this.totalHrs,
  });
}

// --- SCREEN ---
class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  late DateTime _selectedDate;
  late Future<List<AttendanceUIModel>> _attendanceData;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchDataForMonth(_selectedDate);
  }

  void _fetchDataForMonth(DateTime month) {

    setState(() {
      _trackerSummary = null;
      _attendanceData = _fetchAndProcessData(month);
    });
    _fetchTrackerStats(month);
  }

    Future<List<AttendanceUIModel>> _fetchAndProcessData(DateTime month) async {
      final box = GetStorage();
      // Retrieve the token (replace 'token' with your actual key name)
      final String? token = box.read('token');
      final monthString = DateFormat('yyyy-MM').format(month);
      final url = 'http://18.138.124.3/accounts/attendance/calendar/?month=$monthString';

      try {
        final response = await http.get(
          Uri.parse(url),
          // Adding headers here
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        );

        if (response.statusCode == 200) {
          final decodedData = json.decode(response.body);

          // FIXED: Using decodedData instead of decodedJson
          final attendanceResponse = AttendanceMonthResponse.fromJson(decodedData);

          // Map API data to UI model
          return attendanceResponse.calendar
              .where((day) => day.status != "Future")
              .map((day) {
            return AttendanceUIModel(
              date: day.date,
              totalHoursHeader: day.workingHours ?? "00:00",
              records: [
                AttendanceDetails(
                  checkIn: day.checkIn ?? "--:--",
                  checkOut: day.checkOut ?? "--:--",
                  totalHrs: day.workingHours ?? "00:00",
                ),
              ],
            );
          }).toList();
        } else {
          throw Exception('Server Error: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint("API Error: $e");
        rethrow;
      }
    }
  AttendanceTracker? _trackerSummary;

  Future<void> _fetchTrackerStats(DateTime month) async {
    final box = GetStorage();
    final String? token = box.read('token');
    final monthString = DateFormat('yyyy-MM').format(month);
    final url = 'http://18.138.124.3/accounts/attendance/tracker/?month=$monthString';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _trackerSummary = AttendanceTracker.fromJson(json.decode(response.body));
        });
      }
    } catch (e) {
      debugPrint("Tracker API Error: $e");
    }
  }
  void _changeMonth(int monthIncrement) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + monthIncrement,
        1, // Safe approach to avoid month-end issues
      );
      _fetchDataForMonth(_selectedDate);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _fetchDataForMonth(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Attendance History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildMonthSelector(),
          const SizedBox(height: 24),
          _buildSummaryCards(),
          const SizedBox(height: 24),
          Expanded(child: _buildAttendanceList()),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.keyboard_double_arrow_left),
              onPressed: () => _changeMonth(-1),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Row(
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.calendar_today, size: 20),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_double_arrow_right),
              onPressed: () => _changeMonth(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
        children: [
          _statCard("Present",
              "${_trackerSummary?.presentDays ?? 0} Days",
              Colors.green),
      _statCard("Absent",
          "${_trackerSummary?.presentDays ?? 0} Days",
          Colors.red),
      _statCard("Late Entry",
          "${_trackerSummary?.presentDays ?? 0} Days",
          Colors.orange),
      _statCard("Avg Hours",
          "${_trackerSummary?.presentDays ?? 0} Days",
          Colors.blue),
 ]     ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAttendanceList() {
    return FutureBuilder<List<AttendanceUIModel>>(
      future: _attendanceData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF004D40)));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No attendance records found.'));
        }

        final list = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: list.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) => AttendanceCard(data: list[index]),
        );
      },
    );
  }
}

// --- ATTENDANCE CARD WIDGET ---
class AttendanceCard extends StatelessWidget {
  final AttendanceUIModel data;
  const AttendanceCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias, // Ensures header matches radius
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(
        children: [
          _buildHeader(),
          ...data.records.map((record) => _buildRecordRow(record)).toList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF004D40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Date: ${data.date}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text('Total Hrs: ${data.totalHoursHeader}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRecordRow(AttendanceDetails record) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(Icons.login, record.checkIn, 'Check In'),
          _buildInfoItem(Icons.logout, record.checkOut, 'Check Out'),
          _buildInfoItem(Icons.timer_outlined, record.totalHrs, 'Total Hrs'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String time, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF004D40), size: 24),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 12)),
      ],
    );
  }
}