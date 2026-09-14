import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/bars/bar_graph.dart';
import 'package:water_intake/data/water_data.dart';

class WaterSummary extends StatelessWidget {
  final DateTime? startOfWeek;
  const WaterSummary({super.key, required this.startOfWeek});

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterData>(
      builder: (context, value, child) => Column(
        children: [
          SizedBox(
            height: 200,
            child: BarGraph(
              maxY: 100,
              sunWateramt: 10,
              monWateramt: 10,
              tueWateramt: 10,
              wedWateramt: 4,
              thuWateramt: 10,
              friWateramt: 10,
              satWateramt: 10,
            ),
          ),
        ],
      ),
    );
  }
}
