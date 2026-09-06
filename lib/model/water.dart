class Water {
  final String? id;
  final double amount;
  final DateTime dateTime;
  final String unit;

  Water({
    this.id,
    required this.amount,
    required this.dateTime,
    required this.unit,
  });

  factory Water.fromJson(Map<String, dynamic> json, String id) {
    return Water(
      id: id,
      amount: json['amount'],
      dateTime: DateTime.parse(json['dateTime']).toUtc(),
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'unit': unit,
    };
  }
}
