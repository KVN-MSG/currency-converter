import 'exchange_rates.dart';

/// I keep the conversion logic here with no Flutter widgets in it, so my UI
/// code stays simple and I can test this class on its own.
class ConverterLogic {
  const ConverterLogic._();

  /// I return the fixed rate for converting 1 unit of [from] into [to].
  static double getRate(String from, String to) {
    return exchangeRates[from]![to]!;
  }

  /// I convert [amount] of [from] currency into [to] currency.
  static double convert(double amount, String from, String to) {
    return amount * getRate(from, to);
  }

  /// I turn the text typed by the user into a number.
  /// I return null if the text is empty or is not a valid number (e.g. ".").
  static double? parseAmount(String text) {
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  /// I format a converted amount to 2 decimal places with thousands
  static String formatAmount(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '$whole.${parts[1]}';
  }

  /// I format an exchange rate for display and trim pointless trailing zeros,
  static String formatRate(double rate) {
    var text = rate.toStringAsFixed(rate >= 1 ? 4 : 6);
    text = text.replaceFirst(RegExp(r'0+$'), '');
    return text.replaceFirst(RegExp(r'\.$'), '');
  }
}