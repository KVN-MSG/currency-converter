// This is my fixed exchange-rate data for the Currency Converter.
// I keep this in its own file so the data is separate from my UI code.

/// I list the currencies the user can choose from (the brief asks for at least five).
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

/// I show these full names in the drop-down menus so the codes are easy to recognise.
const Map<String, String> currencyNames = {
  'USD': 'US Dollar',
  'GBP': 'British Pound',
  'EUR': 'Euro',
  'JPY': 'Japanese Yen',
  'NGN': 'Nigerian Naira',
};