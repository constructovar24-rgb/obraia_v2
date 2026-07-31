import 'package:flutter/material.dart';

import '../formatters/currency_formatter.dart';

class MoneyText extends StatelessWidget {
  const MoneyText(
    this.amount, {
    super.key,
    this.style,
    this.textAlign,
    this.decimalSeparator = '.',
    this.currencySymbol = '€',
    this.symbolOnRight = true,
    this.semanticLabel,
    this.maxLines,
    this.overflow,
  });

  final double amount;
  final TextStyle? style;
  final TextAlign? textAlign;
  final String decimalSeparator;
  final String currencySymbol;
  final bool symbolOnRight;
  final String? semanticLabel;
  final int? maxLines;
  final TextOverflow? overflow;

  static String format(
    double amount, {
    String decimalSeparator = '.',
    String currencySymbol = '€',
    bool symbolOnRight = true,
  }) {
    return CurrencyFormatter.format(
      amount,
      decimalSeparator: decimalSeparator,
      currencySymbol: currencySymbol,
      symbolOnRight: symbolOnRight,
    );
  }

  String get formattedAmount {
    return format(
      amount,
      decimalSeparator: decimalSeparator,
      currencySymbol: currencySymbol,
      symbolOnRight: symbolOnRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formattedAmount,
      style: style,
      textAlign: textAlign,
      semanticsLabel: semanticLabel,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}