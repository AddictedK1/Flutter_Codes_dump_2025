import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Quotes extends StatefulWidget {
  const Quotes({super.key});

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  final String api = "https://api.adviceslip.com/advice";
  String quote = "Random Quote";

  generateQuote() async {
    var res = await http.get(Uri.parse(api));
    var result = jsonDecode(res.body);
    setState(() {
      quote = result["slip"]["advice"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Random Quote Generator")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(quote),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                generateQuote();
              },
              child: Text("Generate Quote"),
            ),
          ],
        ),
      ),
    );
  }
}
