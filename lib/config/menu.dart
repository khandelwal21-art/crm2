import 'package:flutter/material.dart';

final Map<String, List<Map<String, dynamic>>> roleMenus = {
  'staff': [

     {'title': 'Mark Attendance', 'icon': Icons.access_time_outlined, 'route': '/mark-attendance'},
    {'title': 'Dashboard', 'icon': Icons.dashboard_outlined, 'route': '/dashboard'},
    {
      'title': 'Auto dialer',
      'icon': Icons.assignment_outlined,
       'route': '/autodialer',

    },
     {'title': 'Attendance History', 'icon': Icons.work_outline, 'route': '/attendance-history'},
      {'title': 'Leave', 'icon': Icons.sell_outlined, 'route': '/leave-screen'},
  ],

  'admin': [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'route': '/dashboard'},
    {'title': 'Productivity', 'icon': Icons.bar_chart_outlined, 'route': '/productivity'},
    {'title': 'Incentives', 'icon': Icons.monetization_on_outlined, 'route': '/incentives'},
    {'title': 'Auto Dialer', 'icon': Icons.phone_android, 'route': '/autodialer'},

    {'title': 'Leads Report', 'icon': Icons.assignment_outlined,
      'children': [
        {'title': 'Auto Call', 'route': '/leads/autocall'},
        {'title': 'Lead 2', 'route': '/leads/lead2'},
      ],
    },
    {
      'title': 'Marketing',
      'icon': Icons.campaign_outlined,
      'children': [
        {'title': 'Campaign 1', 'route': '/marketing/campaign1'},
        {'title': 'Campaign 2', 'route': '/marketing/campaign2'},
      ],
    },
    {'title': 'Time Sheet', 'icon': Icons.access_time_outlined, 'route': '/timesheet'},

    // Add more staff menu items as needed
  ],

  'team_leader': [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'route': '/dashboard'},
    {'title': 'Team', 'icon': Icons.group, 'route': '/team'},
    // Add more team leader items as needed
  ],

  'freelancer': [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'route': '/dashboard'},
    {'title': 'Projects', 'icon': Icons.work, 'route': '/projects'},
    // Add more freelancer items as needed
  ],

  // Add a default or guest menu if needed
};
