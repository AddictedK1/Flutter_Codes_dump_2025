import 'package:flutter/material.dart';
import 'dart:math';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();

  String _interestType = 'Compound'; // Simple or Compound
  String _tenureUnit = 'Years'; // Years or Months

  double? _emi, _totalPayment, _totalInterest;

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  void _reset() {
    _formKey.currentState?.reset();
    _principalController.clear();
    _rateController.clear();
    _tenureController.clear();
    setState(() {
      _interestType = 'Compound';
      _tenureUnit = 'Years';
      _emi = null;
      _totalPayment = null;
      _totalInterest = null;
    });
  }

  void _calculate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final principal = double.parse(_principalController.text);
    final annualRate = double.parse(_rateController.text);
    final tenureInput = double.parse(_tenureController.text);

    final tenureMonths = (_tenureUnit == 'Years')
        ? (tenureInput * 12).round()
        : tenureInput.round();
    final tenureYears = (_tenureUnit == 'Years')
        ? tenureInput
        : (tenureInput / 12.0);

    double emi = 0, totalPayment = 0, totalInterest = 0;

    if (_interestType == 'Simple') {
      final interest = principal * (annualRate / 100) * tenureYears;
      totalPayment = principal + interest;
      emi = totalPayment / tenureMonths;
      totalInterest = interest;
    } else {
      final monthlyRate = annualRate / 100 / 12;
      final n = tenureMonths;
      if (monthlyRate == 0) {
        emi = principal / n;
      } else {
        final powFactor = pow(1 + monthlyRate, n);
        emi = principal * monthlyRate * powFactor / (powFactor - 1);
      }
      totalPayment = emi * n;
      totalInterest = totalPayment - principal;
    }

    setState(() {
      _emi = emi;
      _totalPayment = totalPayment;
      _totalInterest = totalInterest;
    });
  }

  String _fmt(double? v) => v == null ? '-' : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loan Calculator')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _principalController,
                    decoration: InputDecoration(
                      labelText: 'Principal Amount',
                      border: UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null ||
                            double.tryParse(v) == null ||
                            double.parse(v) <= 0)
                        ? 'Enter valid amount'
                        : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _rateController,
                    decoration: InputDecoration(
                      labelText: 'Interest Rate (%)',
                      border: UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || double.tryParse(v) == null)
                        ? 'Enter valid rate'
                        : null,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _tenureController,
                          decoration: InputDecoration(
                            labelText: 'Loan Tenure',
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              (v == null ||
                                  double.tryParse(v) == null ||
                                  double.parse(v) <= 0)
                              ? 'Enter valid tenure'
                              : null,
                        ),
                      ),
                      SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _tenureUnit,
                        items: ['Years', 'Months']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _tenureUnit = v!),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _interestType,
                    decoration: InputDecoration(
                      labelText: 'Interest Type',
                      border: UnderlineInputBorder(),
                    ),
                    items: ['Compound', 'Simple']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _interestType = v!),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _calculate,
                          child: Text('Calculate'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _reset,
                          child: Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_emi != null) ...[
              SizedBox(height: 32),
              Text('Results', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 16),
              _buildRow('Monthly EMI', _fmt(_emi)),
              Divider(),
              _buildRow('Total Payment', _fmt(_totalPayment)),
              _buildRow('Total Interest', _fmt(_totalInterest)),
              Divider(),
              _buildRow('Interest Type', _interestType),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      ),
    );
  }
}
