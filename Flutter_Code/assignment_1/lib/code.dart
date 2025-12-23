import 'package:flutter/material.dart';

class Code extends StatefulWidget {
  const Code({super.key});

  @override
  State<Code> createState() => _CodeState();
}

class _CodeState extends State<Code> {
  final actualController = TextEditingController();
  final gstController1 = TextEditingController();

  final totalController = TextEditingController();
  final gstController2 = TextEditingController();

  String case1Result = "";
  String case2Result = "";

  // Case 1: Actual + GST%
  void calculateCase1() {
    double actual = double.tryParse(actualController.text) ?? 0;
    double gstPercent = double.tryParse(gstController1.text) ?? 0;

    double igst = actual * gstPercent / 100;
    double cgst = igst / 2;
    double sgst = igst / 2;
    double total = actual + igst;

    setState(() {
      case1Result =
          """
          Actual Amount: ${actual.toStringAsFixed(2)}
          IGST: ${igst.toStringAsFixed(2)}
          CGST: ${cgst.toStringAsFixed(2)}
          SGST: ${sgst.toStringAsFixed(2)}
          Total: ${total.toStringAsFixed(2)}
          """;
    });
  }

  // Case 2: Total + GST%
  void calculateCase2() {
    double total = double.tryParse(totalController.text) ?? 0;
    double gstPercent = double.tryParse(gstController2.text) ?? 0;

    double actual = total / (1 + gstPercent / 100);
    double igst = actual * gstPercent / 100;
    double cgst = igst / 2;
    double sgst = igst / 2;

    setState(() {
      case2Result =
          """
          Actual Amount: ${actual.toStringAsFixed(2)}
          IGST: ${igst.toStringAsFixed(2)}
          CGST: ${cgst.toStringAsFixed(2)}
          SGST: ${sgst.toStringAsFixed(2)}
          Total: ${total.toStringAsFixed(2)}
          """;
    });
  }

  /// Reset all fields and results
  void clearAll() {
    actualController.clear();
    gstController1.clear();
    totalController.clear();
    gstController2.clear();
    setState(() {
      case1Result = "";
      case2Result = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GST Calculator")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Case 1: Actual Amount + GST %",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: actualController,
              decoration: const InputDecoration(
                labelText: "Enter Actual Amount",
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: gstController1,
              decoration: const InputDecoration(labelText: "Enter GST %"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: calculateCase1,
              child: const Text("Calculate Case 1"),
            ),
            Text(case1Result, style: const TextStyle(fontSize: 16)),
            SizedBox(height: 50,),
            const Divider(thickness: 2),

            const Text(
              "Case 2: Total Amount + GST %",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: totalController,
              decoration: const InputDecoration(
                labelText: "Enter Total Amount",
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: gstController2,
              decoration: const InputDecoration(labelText: "Enter GST %"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: calculateCase2,
              child: const Text("Calculate Case 2"),
            ),
            Text(case2Result, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: clearAll,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Clear All"),
            ),
          ],
        ),
      ),
    );
  }
}
