import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:water_intake/model/water.dart';

class WaterData extends ChangeNotifier {
  List<Water> waterDataList = [];

  void addWater(Water water) async {
    final url = Uri.https(
      "water-intaker-93cc3-default-rtdb.firebaseio.com",
      'water.json',
    );

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amount': water.amount,
        'unit': water.unit,
        'dataTime': water.dateTime.toUtc().toIso8601String(),
      }),
    );

    notifyListeners();

    if (response.statusCode == 200) {
      print('Data saved successfully');
    } else {
      print('Failed to save data: ${response.statusCode}');
    }
  }

  Future<List<Water>> getWater() async {
    final url = Uri.https(
      "water-intaker-93cc3-default-rtdb.firebaseio.com",
      'water.json',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load water data');
    }

    if (response.body == 'null') {
      return [];
    }

    final Map<String, dynamic> data = json.decode(response.body);
    data.forEach((id, waterData) {
      waterDataList.add(Water.fromJson(waterData, id));
    });
    notifyListeners();
    return waterDataList;
  }
}
