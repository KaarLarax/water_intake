import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:water_intake/model/water.dart';
import 'package:water_intake/utils/date_helper.dart';

class WaterData extends ChangeNotifier {
  List<Water> waterDataList = [];
  final _url = dotenv.get('URL_FIREBASE');

  Future<void> addWater(Water water) async {
    final url = Uri.https(_url, 'water.json');

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amount': water.amount,
        'unit': water.unit,
        'dateTime': water.dateTime.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print('Data saved successfully: ${extractedData.toString()}');
      waterDataList.add(
        Water(
          id: extractedData['name'],
          amount: water.amount,
          unit: water.unit,
          dateTime: water.dateTime,
        ),
      );
    } else {
      print('Failed to save data: ${response.statusCode}');
    }

    notifyListeners();
  }

  Future<List<Water>> getWater() async {
    final url = Uri.https(_url, 'water.json');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load water data');
    }

    if (response.body == 'null') {
      return [];
    }

    waterDataList.clear();

    final Map<String, dynamic> data = json.decode(response.body);
    data.forEach((id, waterData) {
      waterDataList.add(Water.fromJson(waterData, id));
    });

    notifyListeners();
    return waterDataList;
  }

  DateTime? startOfWeek() {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(now.year, now.month, now.day);
    DateTime startOfWeek;

    for (int i = 0; i < 7; i++) {
      if (getWeekDay(dateTime.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = dateTime.subtract(Duration(days: i));
        return startOfWeek;
      }
    }
    return null;
  }

  String getWeekDay(DateTime date) {
    return switch (date.weekday) {
      1 => 'Mon',
      2 => 'Tue',
      3 => 'Wed',
      4 => 'Thu',
      5 => 'Fri',
      6 => 'Sat',
      7 => 'Sun',
      _ => '',
    };
  }

  Future<void> deleteWater(Water water) async {
    final url = Uri.https(_url, 'water/${water.id}.json');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      waterDataList.removeWhere((w) => w.id == water.id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete water data');
    }
  }

  // Calculate the weekly water intake for the current week
  String calculateWeeklyWaterIntake(WaterData waterData) {
    double totalIntake = 0.0;
    for (var water in waterData.waterDataList) {
      if (water.dateTime.isAfter(startOfWeek()!)) {
        totalIntake += double.parse(water.amount.toString());
      }
    }
    return totalIntake.toStringAsFixed(2);
  }

  // Caculate the daily water intake for the current day
  Map<String, double> calculateDailyWaterIntake() {
    Map<String, double> dailyWaterSummary = {};

    for (var water in waterDataList) {

      String date = convertDateTimeToString(water.dateTime.toLocal());
      double amount = double.parse(water.amount.toString());

      if (dailyWaterSummary.containsKey(date)) {
        double currentAmount = dailyWaterSummary[date]!;
        currentAmount += double.parse(water.amount.toString());
        dailyWaterSummary[date] = currentAmount;
      } else {
        dailyWaterSummary.addAll({date: amount});
      }

    }
    return dailyWaterSummary;
  }

  double calculateMaxWeeklyIntake() {
    final daily = calculateDailyWaterIntake();
    if (daily.isEmpty) return 100.0;
    double maxVal = daily.values.reduce((a, b) => a > b ? a : b);
    double adjustedMax = (maxVal * 1.2).ceilToDouble();
    return adjustedMax > 100.0 ? adjustedMax : 100.0;
  }
}