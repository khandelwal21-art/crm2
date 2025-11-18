import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController{
  final List<String> months = ['Feb', 'Mar', 'Apr', 'Jun', 'Jul', 'Aug', 'Oct', 'Dec'];
  final RxList<double> monthlyValues = <double>[3, 4.3, 6.2, 5, 4, 5.1, 4.8, 5.3].obs;


  BarChartData getBarChartData(
      {double maxY = 7}
      ) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: (value, meta) {
              // Show only for main values
              switch (value.toInt()) {
                case 1:
                  return const Text('\$1.5k', style: TextStyle(fontSize: 11), textAlign: TextAlign.left);
                case 3:
                  return const Text('\$3k', style: TextStyle(fontSize: 11), textAlign: TextAlign.left);
                case 4:
                  return const Text('\$4.5k', style: TextStyle(fontSize: 11), textAlign: TextAlign.left);
                case 6:
                  return const Text('\$6k', style: TextStyle(fontSize: 11), textAlign: TextAlign.left);
                default:
                  return const SizedBox.shrink(); // No label for other Y values
              }
            },
          ),

        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(
                months[value.toInt() % months.length],
                style: const TextStyle(color: Colors.black87, fontSize: 10),
              );
            },
          ),
        ),

        //top titles
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        //right titles
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),

      borderData: FlBorderData(show: false),

      barGroups: List.generate(
        monthlyValues.length,
            (i) => BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              width: 20,
              toY: monthlyValues[i],
              color: Colors.orange,
            ),
          ],
        ),
      ),
      //background lines
      gridData: FlGridData(show: false),
    );
  }

  PieChartData  getPieChartData(){
    return PieChartData(
      sections: [
        PieChartSectionData(
          value: 7,
          color: Colors.blue, // Freelancer
          title: 'Freelancer - 7',
          radius: 90,           titleStyle: TextStyle(fontSize: 12, color: Colors.white),
        ),
        PieChartSectionData(
          value: 3,
          color: Colors.orange, // Total Employees
          title: 'Total Emp - 3',
          radius: 90,           titleStyle: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
      centerSpaceRadius: 0, // <<----- This removes the hole
      borderData: FlBorderData(show: false),
    );
  }

}

