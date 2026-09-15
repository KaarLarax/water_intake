import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/components/water_intake_summary.dart';
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
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadingData();
  }

  void _loadingData() async {
    await Provider.of<WaterData>(context, listen: false).getWater().then(
      (waters) => {
        if (waters.isNotEmpty)
          {
            setState(() {
              isLoading = false;
            }),
          }
        else
          {
            setState(() {
              isLoading = false;
            }),
          },
      },
    );
  }

  void saveWater() async {
    await Provider.of<WaterData>(context, listen: false).addWater(
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
      builder: (context, value, child) {
        final WeeklyWaterIntake = value.calculateWeeklyWaterIntake(value);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [IconButton(icon: Icon(Icons.map), onPressed: () {})],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Weekly ', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '$WeeklyWaterIntake ml',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            children: [
              WaterSummary(startOfWeek: value.startOfWeek()),
              !isLoading
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.waterDataList.length,
                      itemBuilder: (context, index) {
                        final waterModel = value.waterDataList[index];
                        return WaterTile(waterModel: waterModel);
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          floatingActionButton: FloatingActionButton(
            onPressed: addWater,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void clearWaterInput() {
    amountController.clear();
  }
}
