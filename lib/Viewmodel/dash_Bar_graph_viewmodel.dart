import 'package:flutter/material.dart';
import 'package:tailer_shop/Model/bar_graph_model.dart';
import 'package:tailer_shop/Model/graph_model.dart';

class BarGraphData {
  final data = [
    BarGraphModel(
        label: "Orders",
        color: const Color(0xFFFEB95A),
        graph: [
          GraphModel(x: 0, y: 8),
          GraphModel(x: 1, y: 10),
          GraphModel(x: 2, y: 7),
          GraphModel(x: 3, y: 4),
          GraphModel(x: 4, y: 4),
          GraphModel(x: 5, y: 6)
        ]),
         BarGraphModel(
        label: "Job Card",
        color: const Color(0xFFF2C8ED),
        graph: [
          GraphModel(x: 0, y: 8),
          GraphModel(x: 1, y: 10),
          GraphModel(x: 2, y: 7),
          GraphModel(x: 3, y: 4),
          GraphModel(x: 4, y: 4),
          GraphModel(x: 5, y: 6)
        ]),
        
  ];
  final label = ['M', 'T', 'W', 'T', 'F', 'S'];
}
