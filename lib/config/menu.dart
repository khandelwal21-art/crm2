import 'package:flutter/material.dart';

final Map<String, List<Map<String, dynamic>>> roleMenus = {
  'admin': [
    {'title': 'Dashboard', 'icon': Icons.dashboard_outlined, 'route': '/dashboard'},
    {
      'title': 'User',
      'icon': Icons.person_2_outlined,
      // Represent nested children as a list of maps with 'title' and 'route'
      'children': [
        {'title': 'Profile', 'route': '/user/profile'},
        {'title': 'Settings', 'route': '/user/settings'},
        {'title': 'Logout', 'route': '/logout'},
      ],
    },
    {
      'title': 'Productivity',
      'icon': Icons.bar_chart_outlined,
      'children': [
        {'title': 'Report 1', 'route': '/productivity/report1'},
        {'title': 'Report 2', 'route': '/productivity/report2'},
      ],
    },
    {
      'title': 'Leads Report',
      'icon': Icons.assignment_outlined,
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
    {'title': 'Project', 'icon': Icons.work_outline, 'route': '/project'},
    {'title': 'Add Sell', 'icon': Icons.sell_outlined, 'route': '/add_sell'},
  ],

  'staff': [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'route': '/dashboard'},
    {'title': 'Productivity', 'icon': Icons.bar_chart_outlined, 'route': '/productivity'},
    {'title': 'Incentives', 'icon': Icons.monetization_on_outlined, 'route': '/incentives'},
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
