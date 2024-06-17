// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:tailer_shop/Model/graph_model.dart';
// import 'package:tailer_shop/View/Dashboad/Widgets/custome_card.dart';
// import 'package:tailer_shop/ViewModel/dash_bar_graph_viewmodel.dart';

// class BarGraphCard extends StatelessWidget {
//   const BarGraphCard({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     final barGraphData = BarGraphData();
//     return GridView.builder(
//       itemCount: barGraphData.data.length,
//       shrinkWrap: true,
//       physics: ScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 15,
//         mainAxisSpacing: 12,
//         childAspectRatio: 5 / 4,
//       ),
//       itemBuilder: (context, index) {
//         return CustomCard(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   barGraphData.data[index].label,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 12),
//               Expanded(
//                 child: BarChart(
//                   BarChartData(
//                     barGroups: _chartGroups(
//                       points: barGraphData.data[index].graph,
//                       color: barGraphData.data[index].color,
//                     ),
//                     borderData: FlBorderData(border: Border()),
//                     gridData: FlGridData(show: false),
//                     titlesData: FlTitlesData(
//                       bottomTitles: SideTitles(
//                         showTitles: true,
//                         getTextStyles: (value) => const TextStyle(
//                           fontSize: 11,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         margin: 5,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   List<BarChartGroupData> _chartGroups({
//     required List<GraphModel> points,
//     required Color color,
//   }) {
//     return points.map((point) {
//       return BarChartGroupData(
//         x: point.x.toDouble(),
//         barRods: [
//           BarChartRodData(
//             y: point.y.toDouble(),
//             width: 12,
//             color: color.withOpacity(point.y > 4 ? 1 : 0.4),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(3),
//               topRight: Radius.circular(3),
//             ),
//           ),
//         ],
//       );
//     }).toList();
//   }
// }
