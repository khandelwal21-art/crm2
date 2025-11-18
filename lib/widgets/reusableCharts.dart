import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum ChartType {
  bar,
  line,
  pie,
  // Add more chart types if needed
}

class ReusableChart extends StatelessWidget {
  final ChartType chartType;
  final dynamic data;  // You can make this strongly typed based on your data model
  final String? title;
  final double height;

  const ReusableChart({
    super.key,
    required this.chartType,
    required this.data,
    this.title,
    this.height=300
  });

  @override
  Widget build(BuildContext context) {
    Widget chartWidget;

    switch (chartType) {
      case ChartType.bar:
        chartWidget = BarChart(data as BarChartData);
        break;
      case ChartType.line:
        chartWidget = LineChart(data as LineChartData);
        break;
      case ChartType.pie:
        chartWidget = PieChart(data as PieChartData);
        break;

    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold
            )),
            const SizedBox(height: 25),
          ],
          SizedBox(
            height: height,
            child: chartWidget,
          ),
        ],
      ),
    );
  }
}
