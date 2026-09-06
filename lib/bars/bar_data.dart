import 'package:water_intake/bars/individual_bar.dart';

class BarData {
  final double sunWaterAmt;
  final double monWaterAmt;
  final double tueWaterAmt;
  final double wedWaterAmt;
  final double thuWaterAmt;
  final double friWaterAmt;
  final double satWaterAmt;

  List<IndividualBar> barData = [];

  BarData({
    required this.sunWaterAmt,
    required this.monWaterAmt,
    required this.tueWaterAmt,
    required this.wedWaterAmt,
    required this.thuWaterAmt,
    required this.friWaterAmt,
    required this.satWaterAmt,
  });

  void initBarData() {
    barData = [
      IndividualBar(x: 0, y: sunWaterAmt),
      IndividualBar(x: 1, y: monWaterAmt),
      IndividualBar(x: 2, y: tueWaterAmt),
      IndividualBar(x: 3, y: wedWaterAmt),
      IndividualBar(x: 4, y: thuWaterAmt),
      IndividualBar(x: 5, y: friWaterAmt),
      IndividualBar(x: 6, y: satWaterAmt),
    ];
  }
}
