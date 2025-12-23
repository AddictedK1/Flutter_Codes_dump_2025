import 'package:flutter/material.dart';

class BmiCalcScreen extends StatefulWidget {
  const BmiCalcScreen({super.key});

  @override
  State<BmiCalcScreen> createState() => _BmiCalcScreenState();
}

class _BmiCalcScreenState extends State<BmiCalcScreen> {
  TextEditingController wtxtController = TextEditingController();

  TextEditingController htxtController = TextEditingController();
  String res = "";
  double result = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BMI Calc")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              controller: wtxtController,
              decoration: InputDecoration(
                hintText: "Enter weight in Kg: ",
                labelText: "Weight in Kg: ",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: htxtController,
              decoration: InputDecoration(
                hintText: "Enter height in meter: ",
                labelText: "Height in meter: ",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                double wt = double.parse(wtxtController.text);
                double ht = double.parse(htxtController.text);
                result = wt / (ht * ht);
                if (result < 16) {
                  res = "SEVERE THINNESS";
                } else if (result < 17 && result >= 16) {
                  res = "MODERATE THINNESS";
                } else if (result < 18.5 && result >= 17) {
                  res = "MILD THINNESS";
                } else if (result < 25 && result >= 18.5) {
                  res = "NORMAL";
                } else {
                  res = "OBESSE THINNESS";
                }
                setState(() {});
              },
              child: Text("Calculate"),
            ),
            SizedBox(height: 20),
            Text(
              "Result: ${result.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 20),
            Text(res, style: TextStyle(fontSize: 25)),
          ],
        ),
      ),
    );
  }
}
