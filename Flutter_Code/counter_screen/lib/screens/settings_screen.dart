//settings_screen.dart
import 'package:counter_screen/screens/counter_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  TextEditingController capacityTxtController = TextEditingController();
  TextEditingController priceTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter App')),
      body: Row(
        children: [
          Expanded(
            child: TextField(
              controller: capacityTxtController,
              decoration: InputDecoration(
                hintText: 'Enter total capacity',
                labelText: 'Capacity',
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: priceTxtController,
              decoration: InputDecoration(
                hintText: 'Enter price/seat',
                labelText: 'Price/Seat',
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (capacityTxtController.text.isNotEmpty &&
                  priceTxtController.text.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CounterScreen(
                      counter: capacityTxtController.text,
                      price: priceTxtController.text,
                    ),
                  ),
                );
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
