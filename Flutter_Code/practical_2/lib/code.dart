import 'package:flutter/material.dart';

class Code extends StatefulWidget {
  const Code({super.key});

  @override
  State<Code> createState() => _CodeState();
}

class _CodeState extends State<Code> {
  final lengthController = TextEditingController();
  final weightController = TextEditingController();
  final tempController = TextEditingController();
  final areaController = TextEditingController();

  String lengthResult = "";
  String weightResult = "";
  String tempResult = "";
  String areaResult = "";

  void convertLength() {
    double value = double.parse(lengthController.text) ?? 0;
    double km = value / 1000;
    setState(() {
      lengthResult = "$value meters = $km kilometers";
    });
  }

  void convertWeight() {
    double value = double.parse(weightController.text) ?? 0;
    double kg = value / 1000;
    setState(() {
      weightResult = "$value grams = $kg kilograms";
    });
  }

  void convertTemp() {
    double value = double.parse(tempController.text) ?? 0;
    double f = (value * 9 / 5) + 32;
    setState(() {
      tempResult = "$value C = $f F";
    });
  }

  void convertArea() {
    double value = double.parse(areaController.text) ?? 0;
    double hectare = value / 10000;
    setState(() {
      areaResult = "$value m^2 = $hectare hectares";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Practical 2")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          child: Column(
            children: [
              // Length
              TextField(
                controller: lengthController,
                decoration: InputDecoration(labelText: "Enter length in meters"),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: convertLength,
                child: Text("Convert Length"),
              ),
              Text(lengthResult),
        
              SizedBox(height: 20),
        
              // Weight
              TextField(
                controller: weightController,
                decoration: InputDecoration(labelText: "Enter weight in grams"),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: convertWeight,
                child: Text("Convert Weight"),
              ),
              Text(weightResult),
        
              SizedBox(height: 20),
        
              // Temperature
              TextField(
                controller: tempController,
                decoration: InputDecoration(labelText: "Enter temp in Celsius"),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(onPressed: convertTemp, child: Text("Convert Temp")),
              Text(tempResult),
        
              SizedBox(height: 20),
        
              // Area
              TextField(
                controller: areaController,
                decoration: InputDecoration(labelText: "Enter area in m²"),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(onPressed: convertArea, child: Text("Convert Area")),
              Text(areaResult),
            ],
          ),
        ),
      ),
    );
  }
}
