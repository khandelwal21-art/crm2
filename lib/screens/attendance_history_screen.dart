import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nexuscrm/config/theme.dart';
import 'package:nexuscrm/widgets/glass_card.dart';
import 'package:nexuscrm/widgets/kAppBar.dart';
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

  AttendanceTracker? _trackerSummary;

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
    final String? token = box.read('token');
    final monthString = DateFormat('yyyy-MM').format(month);
    final url = 'http://18.138.124.3/accounts/attendance/calendar/?month=$monthString';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final attendanceResponse = AttendanceMonthResponse.fromJson(decodedData);

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
        1,
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
      builder: (context, child) { // Custom theme for DatePicker
        return Theme(
          data: AppTheme.lightTheme.copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      }
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
      backgroundColor: AppTheme.backgroundLight,
      extendBodyBehindAppBar: true, 
      appBar: const KAppBar(title: 'Attendance History'),
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundLight,
           // Reuse background
          image: DecorationImage(
            image: NetworkImage("https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?q=80&w=2670&auto=format&fit=crop"),
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildMonthSelector(),
              const SizedBox(height: 20),
              _buildSummaryCards(),
              const SizedBox(height: 20),
              Expanded(child: _buildAttendanceList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
            onPressed: () => _changeMonth(-1),
            color: AppTheme.textSecondary,
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 20, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMMM yyyy').format(_selectedDate),
                  style: AppTheme.heading2.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            onPressed: () => _changeMonth(1),
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _statCard("Present", "${_trackerSummary?.presentDays ?? 0}", AppTheme.primaryColor, Icons.check_circle_rounded),
          const SizedBox(width: 12),
          _statCard("Absent", "${_trackerSummary?.presentDays ?? 0}", Colors.red, Icons.cancel_rounded),
           const SizedBox(width: 12),
          _statCard("Late", "${_trackerSummary?.presentDays ?? 0}", Colors.orange, Icons.timer_off_rounded),
           const SizedBox(width: 12),
          _statCard("Avg Hrs", "8.5", Colors.blue, Icons.access_time_filled_rounded),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, Color color, IconData icon) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTheme.heading2.copyWith(fontSize: 20, color: color)),
          Text(title, style: AppTheme.bodyText.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAttendanceList() {
    return FutureBuilder<List<AttendanceUIModel>>(
      future: _attendanceData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No attendance records.', style: AppTheme.bodyText));
        }

        final list = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1)))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, size: 16, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(data.date, style: AppTheme.buttonText.copyWith(color: AppTheme.textPrimary, fontSize: 15)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text('${data.totalHoursHeader} hrs', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(Icons.login_rounded, data.records.first.checkIn, 'In', Colors.green),
                _verticalDivider(),
                _buildInfoItem(Icons.logout_rounded, data.records.first.checkOut, 'Out', Colors.red),
                _verticalDivider(),
                _buildInfoItem(Icons.history_toggle_off_rounded, data.records.first.totalHrs, 'Total', Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _verticalDivider() => Container(height: 30, width: 1, color: Colors.grey.withOpacity(0.2));

  Widget _buildInfoItem(IconData icon, String time, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(time, style: AppTheme.heading2.copyWith(fontSize: 16)),
        Text(label, style: AppTheme.bodyText.copyWith(fontSize: 12)),
      ],
    );
  }
}