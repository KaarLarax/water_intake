import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/bars/bar_graph.dart';
import 'package:water_intake/data/water_data.dart';
import 'package:water_intake/utils/date_helper.dart';

class WaterSummary extends StatelessWidget {
  final DateTime? startOfWeek;
  const WaterSummary({super.key, required this.startOfWeek});

  @override
  Widget build(BuildContext context) {
    String sunday = convertDateTimeToString(
      startOfWeek!.add(Duration(days: 0)),
    );
    String monday = convertDateTimeToString(
      startOfWeek!.add(Duration(days: 1)),
    );
    String tuesday = convertDateTimeToString(
      startOfWeek!.add(Duration(days: 2)),
    );
    String wednesday = convertDateTimeToString(
      startOfWeek!.add(Duration(days: 3)),
    );
    String thursday = convertDateTimeToString(
      startOfWeek!.add(Duration(days: 4)),
    );
    String friday = convertDateTimeToString(
      startOfWeek!.add(Duration(days: 5)),
    );
    String saturday = convertDateTimeToString(
      startOfWeek!.add(Duration(days: 6)),
    );

    return Consumer<WaterData>(
      builder: (context, value, child) {
        final dailyIntake = value.calculateDailyWaterIntake();
        final dynamicMaxY = value.calculateMaxWeeklyIntake();
        return Column(
          children: [
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarGraph(
                maxY: dynamicMaxY,
                sunWateramt: dailyIntake[sunday] ?? 0,
                monWateramt: dailyIntake[monday] ?? 0,
                tueWateramt: dailyIntake[tuesday] ?? 0,
                wedWateramt: dailyIntake[wednesday] ?? 0,
                thuWateramt: dailyIntake[thursday] ?? 0,
                friWateramt: dailyIntake[friday] ?? 0,
                satWateramt: dailyIntake[saturday] ?? 0,
              ),
            ),
          ],
        );
      },
    );
  }
}
