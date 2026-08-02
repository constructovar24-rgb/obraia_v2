import 'package:flutter/widgets.dart';

class AppRadius {
  const AppRadius._();

  static const double smValue = 8;
  static const double mdValue = 12;
  static const double lgValue = 16;
  static const double pillValue = 999;

  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(pillValue));
}