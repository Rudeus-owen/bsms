import 'package:intl/intl.dart';

NumberFormat formatter = NumberFormat("#,##0", "en_US");

extension ValidateEmail on String {
  bool isEmail() {
    final RegExp regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return regex.hasMatch(this);
  }
}

extension Pluralize on int {
  String pluralize(String singular, [String plural = 's']) =>
      this == 1 ? singular : singular + plural;
}
