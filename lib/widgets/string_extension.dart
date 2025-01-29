// ignore_for_file: unnecessary_this

import 'package:intl/intl.dart';

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String capitalizeFirstWordLetter() {
    return replaceAll(RegExp(' +'), ' ')
        .split(' ')
        .map((str) => str.toCapitalized())
        .join(' ');
  }
}

extension DoubleExtension on double {
  String toMonetaryFormat() {
    // Check if the decimal part is zero
    if (this % 1 == 0) {
      // Whole number, no decimal places
      return NumberFormat("#,###").format(this);
    } else {
      // Decimal number, up to two decimal places
      return NumberFormat("#,##0.##").format(this);
    }
  }
}
