import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nexuscrm/controller/dashBoard_controller.dart';
import 'package:nexuscrm/widgets/kCard.dart';
import 'package:nexuscrm/widgets/reusableCharts.dart';

class AdminDashboardPage extends StatelessWidget {
   AdminDashboardPage({super.key});
  final DashBoardController chartController = Get.put(DashBoardController());

  final List<Map<String, dynamic>> cardItems = [
    {'icon': Icons.bar_chart, 'color': Colors.purple, 'title': "Productivity", 'number': "85%"},
    {'icon': Icons.people, 'color': Colors.blue, 'title': "Staff Management", 'number': "18"},
    {'icon': Icons.language, 'color': Colors.orange, 'title': "Source", 'number': "100"},
    {'icon': Icons.card_travel_outlined, 'color': Colors.red, 'title': "Freelancers", 'number': "7"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // cards
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 80 / 50, // card width / card height ratio
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cardItems.length,
                itemBuilder: (context,index){
                  final item = cardItems[index];
                  return Kcard(
                    icon: item['icon'],
                    color: item['color'],
                    title: item['title'],
                    number: item['number'],
                  );
                },
              ),

              // productivity chart
              SizedBox(height: 10,),
              Card(
                color: Colors.white,
                elevation: 5,
                child: ReusableChart(chartType:ChartType.bar,
                  title: "Productivity",
                  data: chartController.getBarChartData(),
                ),
              ),
              SizedBox(height: 10,),
              Card(
                color: Colors.white,
                elevation: 5,
                child: ReusableChart(chartType:ChartType.pie,
                  title: "Staff Management",
                  data: chartController.getPieChartData(),
                ),
              ),
              SizedBox(height: 10,),

              Card(
                color: Colors.white,
                elevation: 5,
                child: ReusableChart(chartType:ChartType.pie,
                  title: "Source",
                  data: chartController.getPieChartData(),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}