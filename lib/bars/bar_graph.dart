import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:water_intake/bars/bar_data.dart';

class BarGraph extends StatelessWidget {
  final double maxY;
  final double sunWateramt;
  final double monWateramt;
  final double tueWateramt;
  final double wedWateramt;
  final double thuWateramt;
  final double friWateramt;
  final double satWateramt;

  const BarGraph({
    super.key,
    required this.maxY,
    required this.sunWateramt,
    required this.monWateramt,
    required this.tueWateramt,
    required this.wedWateramt,
    required this.thuWateramt,
    required this.friWateramt,
    required this.satWateramt,
  });

  @override
  Widget build(BuildContext context) {
    BarData barData = BarData(
      sunWaterAmt: sunWateramt,
      monWaterAmt: monWateramt,
      tueWaterAmt: tueWateramt,
      wedWaterAmt: wedWateramt,
      thuWaterAmt: thuWateramt,
      friWaterAmt: friWateramt,
      satWaterAmt: satWateramt,
    );

    barData.initBarData();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: 0,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getBottomTitlesWidget,
              ),
            ),
          ),
          barGroups: barData.barData
              .map(
                (data) => BarChartGroupData(
                  x: data.x,
                  barRods: [
                    BarChartRodData(
                      toY: data.y,
                      color: Theme.of(context).primaryColor,
                      width: 20,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: .1),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget getBottomTitlesWidget(double value, TitleMeta meta) {
    const TextStyle style = TextStyle(
      color: Color.fromARGB(255, 24, 23, 23),
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    String text = switch (value.toInt()) {
      0 => 'S',
      1 => 'M',
      2 => 'T',
      3 => 'W',
      4 => 'T',
      5 => 'F',
      6 => 'S',
      _ => '',
    };

    Widget textWidget = Text(text, style: style);
    return SideTitleWidget(space: 3, meta: meta, child: textWidget);
  }
}
