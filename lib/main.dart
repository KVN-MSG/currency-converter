import 'package:flutter/material.dart';

/// I list the currencies the user can choose from.
const List<String> currencies = ['USD', 'GBP', 'EUR', 'JPY', 'NGN'];

/// I use this fixed, hard-coded exchange rate table instead of a live API.
///
/// I look up a rate with exchangeRates[from][to]. It tells me how much of the
/// `to` currency I get for 1 unit of the `from` currency. The exchange rates 
/// I've set are illustrative only, rounded for simplicity, loosely based
/// on 1 USD = 0.79 GBP, 0.92 EUR, 150 JPY and 1500 NGN. I set GBP -> USD to 
/// 1.27 so that the example in the brief (100 GBP = 127.00 USD) stays true.
const Map<String, Map<String, double>> exchangeRates = {
  'USD': {
    'USD': 1.0,
    'GBP': 0.79,
    'EUR': 0.92,
    'JPY': 150.0,
    'NGN': 1500.0,
  },
  'GBP': {
    'USD': 1.27,
    'GBP': 1.0,
    'EUR': 1.164557,
    'JPY': 189.873418,
    'NGN': 1898.734177,
  },
  'EUR': {
    'USD': 1.086957,
    'GBP': 0.858696,
    'EUR': 1.0,
    'JPY': 163.043478,
    'NGN': 1630.434783,
  },
  'JPY': {
    'USD': 0.006667,
    'GBP': 0.005267,
    'EUR': 0.006133,
    'JPY': 1.0,
    'NGN': 10.0,
  },
  'NGN': {
    'USD': 0.000667,
    'GBP': 0.000527,
    'EUR': 0.000613,
    'JPY': 0.1,
    'NGN': 1.0,
  },
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // I use this widget as the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.teal)),
      home: const CurrencyConverter(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  // I store the currencies currently selected in the two drop-downs.
  String _fromCurrency = 'USD';
  String _toCurrency = 'GBP';

  /// I swap the "from" and "to" currencies with a single action.
  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
  }

  /// I build one labelled currency drop-down here, so "From" and "To" share
  /// one piece of code instead of me copying and pasting it.
  Widget _buildCurrencyDropdown({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: currencies
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text('Converted Amount', style: style),
                Text(
                  '0.00',
                  style: style.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontSize: theme.textTheme.displaySmall?.fontSize,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: theme.colorScheme.primary, width: 2),
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Amount',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      print('Value: $value');
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCurrencyDropdown(
                          label: 'From',
                          value: _fromCurrency,
                          onChanged: (String? value) {
                            setState(() {
                              _fromCurrency = value ?? _fromCurrency;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_horiz),
                        tooltip: 'Swap currencies',
                        onPressed: _swapCurrencies,
                      ),
                      Expanded(
                        child: _buildCurrencyDropdown(
                          label: 'To',
                          value: _toCurrency,
                          onChanged: (String? value) {
                            setState(() {
                              _toCurrency = value ?? _toCurrency;
                            });
                          },
                        ),
                      ),
                    ],
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