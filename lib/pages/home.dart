import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/components/water_tile.dart';
import 'package:water_intake/data/water_data.dart';
import 'package:water_intake/model/water.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final amountController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    Provider.of<WaterData>(context, listen: false).getWater();
  }

  void saveWater() async {
    Provider.of<WaterData>(context, listen: false).addWater(
      Water(
        amount: double.parse(amountController.text),
        unit: 'ml',
        dateTime: DateTime.now().toUtc(),
      ),
    );
    clearWaterInput();
    if (!context.mounted) {
      return; // if the widget is no longer in the widget tree, return early to avoid calling setState
    }
  }

  void addWater() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Water'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Water added in your daily intake!'),
            SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (ml)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              saveWater();
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          elevation: 4,
          centerTitle: true,
          actions: [IconButton(icon: Icon(Icons.map), onPressed: () {})],
          title: const Text('Water'),
        ),
        body: ListView.builder(
          itemCount: value.waterDataList.length,
          itemBuilder: (context, index) {
            final waterModel = value.waterDataList[index];
            return WaterTile(waterModel: waterModel);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: FloatingActionButton(
          onPressed: addWater,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void clearWaterInput() {
    amountController.clear();
  }
}
