import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:water_intake/model/water.dart';

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
        'dateTime': water.dateTime.toUtc().toIso8601String(),
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
          dateTime: water.dateTime.toUtc(),
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
    DateTime startOfWeek, dateTime = DateTime.now();

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
}
