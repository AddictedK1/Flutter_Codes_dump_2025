//counter_screen.dart
import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  CounterScreen({super.key, required this.counter, required this.price});
  String counter;
  String price;

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  late int count;
  late int capacity;
  late int available = capacity;
  double earnings = 0;
  double amount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = 0;
    capacity = int.parse(widget.counter);
  }

  _calculateAmount() {
    amount = count * double.parse(widget.price);
    setState(() {});
  }

  _bookTicket() {
    if (count > available) {
      Text("No Ticket available");
    } else {
      earnings += amount;
      available -= count;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter App')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Capacity:$capacity'),
              Text('Available:$available'),
              Text('Earnings:$earnings'),
            ],
          ),
          Text(count.toString(), style: TextStyle(fontSize: 50)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  count++;
                  setState(() {});
                  _calculateAmount();
                },
                child: Icon(Icons.add, size: 30),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (count > 0) count--;
                  });
                  _calculateAmount();
                },
                child: Icon(Icons.remove, size: 30),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    count = 0;
                  });
                  _calculateAmount();
                },
                child: Icon(Icons.refresh, size: 30),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text('Amount Payable: $amount'),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _bookTicket();
              });
            },
            child: Text("Book Ticket"),
          ),
        ],
      ),
    );
  }
}
