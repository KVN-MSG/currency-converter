import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'converter_logic.dart';
import 'exchange_rates.dart';

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
      darkTheme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
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
  // I keep the values the user is currently working with here.
  String _amountText = '';
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
          // Once selected, I show only the short code so it fits small screens.
          selectedItemBuilder: (context) =>
              currencies.map((c) => Text(c)).toList(),
          items: currencies
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text('$c - ${currencyNames[c]}'),
                ),
              )
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

    // I recalculate on every rebuild, so the result is always live.
    final amount = ConverterLogic.parseAmount(_amountText);
    final hasError = _amountText.isNotEmpty && amount == null;
    final rate = ConverterLogic.getRate(_fromCurrency, _toCurrency);
    final converted = ConverterLogic.convert(
      amount ?? 0,
      _fromCurrency,
      _toCurrency,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      // I use SafeArea, scrolling and a maximum width to keep my layout usable on
      // small phones, with the keyboard open, and on tablets or the web.
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      // I use "primary" so the white text has proper contrast.
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text('Converted Amount ($_toCurrency)', style: style),
                        // I use FittedBox to shrink very large results to fit.
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            ConverterLogic.formatAmount(converted),
                            style: style.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontSize: theme.textTheme.displaySmall?.fontSize,
                            ),
                          ),
                        ),
                        Text(
                          '1 $_fromCurrency = ${ConverterLogic.formatRate(rate)} $_toCurrency',
                          style: style,
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
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Enter Amount',
                              errorText: hasError ? 'Enter a valid number' : null,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            // I only allow digits and one decimal point, and I limit the
                            // length so huge numbers cannot break my layout.
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'),
                              ),
                              LengthLimitingTextInputFormatter(12),
                            ],
                            onChanged: (String value) {
                              setState(() {
                                _amountText = value;
                              });
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
            ),
          ),
        ),
      ),
    );
  }
}