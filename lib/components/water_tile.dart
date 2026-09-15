import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/data/water_data.dart';
import 'package:water_intake/model/water.dart';

class WaterTile extends StatelessWidget {
  const WaterTile({super.key, required this.waterModel});

  final Water waterModel;

  @override
  Widget build(BuildContext context) {
    final localDate = waterModel.dateTime.toLocal();
    return Card(
      elevation: 4,
      child: ListTile(
        title: Row(
          children: [
            Icon(Icons.water_drop, color: Colors.blue, size: 20),
            Text(
              '${waterModel.amount.toStringAsFixed(2)} ml',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        subtitle: Text('${localDate.day}/${localDate.month}/${localDate.year}'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            Provider.of<WaterData>(
              context,
              listen: false,
            ).deleteWater(waterModel);
          },
        ),
      ),
    );
  }
}
