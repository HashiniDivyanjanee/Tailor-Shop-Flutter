// import 'package:fl_chart/fl_chart.dart' as fl_chart;
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:tailer_shop/Const/constant.dart';
// import 'package:tailer_shop/View/Dashboad/Widgets/custome_card.dart';
// import 'package:tailer_shop/Viewmodel/line_chart.dart';

// class LineChart extends StatelessWidget {
//   const LineChart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final data = LineData();

//     return CustomCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Steps Overview",
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           AspectRatio(
//             aspectRatio: 16 / 6,
//             child: fl_chart.LineChart(
//               fl_chart.LineChartData(
//                   lineTouchData: fl_chart.LineTouchData(
//                     handleBuiltInTouches: true,
//                   ),
//                   gridData: fl_chart.FlGridData(show: false),
//                   titlesData: fl_chart.FlTitlesData(
//                       rightTitles: fl_chart.AxisTitles(
//                           sideTitles: fl_chart.SideTitles(showTitles: false)),
//                       topTitles: fl_chart.AxisTitles(
//                           sideTitles: fl_chart.SideTitles(showTitles: false)),
//                       bottomTitles: fl_chart.AxisTitles(
//                           sideTitles: fl_chart.SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (double value, TitleMeta meta) {
//                           return data.bottomTitle[value.toInt()] != null
//                               ? fl_chart.SideTitleWidget(
//                                   axisSide: meta.axisSide,
//                                   child: Text(
//                                       data.bottomTitle[value.toInt()]
//                                           .toString(),
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[400])),
//                                 )
//                               : const SizedBox();
//                         },
                     
//                         interval: 1,
//                         reservedSize: 40,
//                       ))),
//                   borderData: fl_chart.FlBorderData(show: false),
//                   lineBarsData: [
//                     fl_chart.LineChartBarData(
//                         color: selectionColor,
//                         barWidth: 2.5,
//                         belowBarData: fl_chart.BarAreaData(
//                             gradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                               selectionColor.withOpacity(0.5),
//                               Colors.transparent
//                             ]),show: true),
//                             dotData: fl_chart.FlDotData(show: false),
//                             )
//                   ], minX: 0,
//                   maxX: 120,
//                   maxY: 105,
//                   minY: -5),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
