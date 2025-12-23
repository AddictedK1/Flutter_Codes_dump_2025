import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan EMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EMICalculatorPage(),
    );
  }
}

class EMICalculatorPage extends StatefulWidget {
  const EMICalculatorPage({super.key});

  @override
  State<EMICalculatorPage> createState() => _EMICalculatorPageState();
}

class _EMICalculatorPageState extends State<EMICalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _loanTenureController = TextEditingController();

  double? _emiResult;
  double? _totalAmount;
  double? _totalInterest;

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _loanTenureController.dispose();
    super.dispose();
  }

  void _calculateEMI() {
    double principal = double.parse(_loanAmountController.text);
    double annualRate = double.parse(_interestRateController.text);
    int tenureMonths = int.parse(_loanTenureController.text);

    // Convert annual rate to monthly rate
    double monthlyRate = annualRate / 12 / 100;

    // EMI Formula: [P x R x (1+R)^N]/[(1+R)^N-1]
    double emi;
    if (monthlyRate == 0) {
      emi = principal / tenureMonths;
    } else {
      double factor = pow(1 + monthlyRate, tenureMonths).toDouble();
      emi = (principal * monthlyRate * factor) / (factor - 1);
    }

    double totalPayment = emi * tenureMonths;
    double totalInterestPaid = totalPayment - principal;

    setState(() {
      _emiResult = emi;
      _totalAmount = totalPayment;
      _totalInterest = totalInterestPaid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan EMI Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _loanAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Loan Amount',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                  hintText: 'Enter loan amount',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  if (double.tryParse(value) == null) {
                    return "Enter valid number";
                  }
                  if (double.parse(value) <= 0) {
                    return "Amount must be greater than 0";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _interestRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Annual Interest Rate',
                  suffixText: '%',
                  border: OutlineInputBorder(),
                  hintText: 'Enter interest rate',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  if (double.tryParse(value) == null) {
                    return "Enter valid number";
                  }
                  if (double.parse(value) < 0) {
                    return "Rate cannot be negative";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _loanTenureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Loan Tenure (Months)',
                  border: OutlineInputBorder(),
                  hintText: 'Enter tenure in months',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  if (int.tryParse(value) == null) {
                    return "Enter valid number";
                  }
                  if (int.parse(value) <= 0) {
                    return "Tenure must be greater than 0";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _calculateEMI();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Calculate EMI",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 32),
              if (_emiResult != null) ...[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Results',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 24),
                        _buildResultRow(
                          'Monthly EMI',
                          '₹ ${_emiResult!.toStringAsFixed(2)}',
                          Colors.green,
                        ),
                        const SizedBox(height: 12),
                        _buildResultRow(
                          'Total Amount Payable',
                          '₹ ${_totalAmount!.toStringAsFixed(2)}',
                          Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        _buildResultRow(
                          'Total Interest',
                          '₹ ${_totalInterest!.toStringAsFixed(2)}',
                          Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
