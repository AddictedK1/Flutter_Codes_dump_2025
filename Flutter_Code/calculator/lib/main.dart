import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expression Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '0';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '0';
      } else if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
          if (_expression.isEmpty) {
            _result = '0';
          }
        }
      } else if (value == '=') {
        _calculateResult();
      } else {
        _expression += value;
      }
    });
  }

  void _calculateResult() {
    try {
      final result = _evaluateExpression(_expression);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Error';
    }
  }

  String _formatResult(double result) {
    if (result.isInfinite) {
      return 'Error: Division by zero';
    }
    if (result.isNaN) {
      return 'Error';
    }
    // Remove trailing zeros and decimal point if not needed
    if (result == result.toInt()) {
      return result.toInt().toString();
    }
    return result
        .toStringAsFixed(8)
        .replaceAll(RegExp(r'0*$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  double _evaluateExpression(String expr) {
    // Remove spaces
    expr = expr.replaceAll(' ', '');

    if (expr.isEmpty) {
      return 0;
    }

    // Parse and evaluate the expression
    return _parseExpression(expr);
  }

  double _parseExpression(String expr) {
    // Handle addition and subtraction (lowest precedence)
    for (int i = expr.length - 1; i >= 0; i--) {
      if (expr[i] == '+' ||
          (expr[i] == '-' && i > 0 && _isOperatorOrDigit(expr[i - 1]))) {
        final left = _parseExpression(expr.substring(0, i));
        final right = _parseTerm(expr.substring(i + 1));
        return expr[i] == '+' ? left + right : left - right;
      }
    }
    return _parseTerm(expr);
  }

  double _parseTerm(String expr) {
    // Handle multiplication and division (higher precedence)
    for (int i = expr.length - 1; i >= 0; i--) {
      if (expr[i] == '*' || expr[i] == '/') {
        final left = _parseTerm(expr.substring(0, i));
        final right = _parseFactor(expr.substring(i + 1));
        if (expr[i] == '*') {
          return left * right;
        } else {
          if (right == 0) {
            return double.infinity;
          }
          return left / right;
        }
      }
    }
    return _parseFactor(expr);
  }

  double _parseFactor(String expr) {
    // Handle parentheses and numbers
    if (expr.startsWith('(') && expr.endsWith(')')) {
      return _parseExpression(expr.substring(1, expr.length - 1));
    }

    // Handle negative numbers
    if (expr.startsWith('-')) {
      return -_parseFactor(expr.substring(1));
    }

    // Handle parentheses
    int parenCount = 0;
    for (int i = 0; i < expr.length; i++) {
      if (expr[i] == '(') parenCount++;
      if (expr[i] == ')') parenCount--;

      if (parenCount == 0 && i < expr.length - 1) {
        if (expr[i] == ')') {
          // Implicit multiplication: )number or )(
          if (i + 1 < expr.length &&
              (expr[i + 1] == '(' || _isDigit(expr[i + 1]))) {
            return _parseFactor(expr.substring(0, i + 1)) *
                _parseFactor(expr.substring(i + 1));
          }
        }
      }
    }

    // Find matching parentheses
    parenCount = 0;
    for (int i = 0; i < expr.length; i++) {
      if (expr[i] == '(') {
        if (parenCount == 0) {
          int start = i;
          int depth = 1;
          for (int j = i + 1; j < expr.length; j++) {
            if (expr[j] == '(') depth++;
            if (expr[j] == ')') depth--;
            if (depth == 0) {
              final innerValue = _parseExpression(expr.substring(start + 1, j));
              final before = start > 0 ? expr.substring(0, start) : '';
              final after = j < expr.length - 1 ? expr.substring(j + 1) : '';

              if (before.isNotEmpty) {
                return _parseFactor(before) *
                    innerValue *
                    (after.isNotEmpty ? _parseFactor(after) : 1);
              } else if (after.isNotEmpty) {
                return innerValue * _parseFactor(after);
              }
              return innerValue;
            }
          }
        }
        parenCount++;
      }
      if (expr[i] == ')') parenCount--;
    }

    // Parse number
    return double.parse(expr);
  }

  bool _isOperatorOrDigit(String char) {
    return char == ')' || _isDigit(char);
  }

  bool _isDigit(String char) {
    return '0123456789.'.contains(char);
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            foregroundColor: textColor ?? Colors.black,
            padding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Expression Calculator'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Display area
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression.isEmpty ? '0' : _expression,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _result,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // Buttons area
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          'C',
                          color: Colors.red[400],
                          textColor: Colors.white,
                        ),
                        _buildButton(
                          '(',
                          color: Colors.blue[400],
                          textColor: Colors.white,
                        ),
                        _buildButton(
                          ')',
                          color: Colors.blue[400],
                          textColor: Colors.white,
                        ),
                        _buildButton(
                          '⌫',
                          color: Colors.orange[400],
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton(
                          '/',
                          color: Colors.blue[400],
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton(
                          '*',
                          color: Colors.blue[400],
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton(
                          '-',
                          color: Colors.blue[400],
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('0'),
                        _buildButton('.'),
                        _buildButton(
                          '=',
                          color: Colors.green[400],
                          textColor: Colors.white,
                        ),
                        _buildButton(
                          '+',
                          color: Colors.blue[400],
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
