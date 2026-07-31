class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(
    double amount, {
    String decimalSeparator = '.',
    String currencySymbol = '€',
    bool symbolOnRight = true,
  }) {
    final String numericValue = amount
        .toStringAsFixed(2)
        .replaceAll('.', decimalSeparator);

    if (symbolOnRight) {
      return '$numericValue $currencySymbol';
    }

    return '$currencySymbol $numericValue';
  }
}