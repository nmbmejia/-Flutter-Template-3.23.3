import 'package:Acorn/services/constants.dart';
import 'package:intl/intl.dart';

class Currency {
  static final formatter = NumberFormat("#,##0.00", "en_US");

  static String format(double x, {bool appendSymbol = true}) {
    return '${Constants.currency}${formatter.format(x)}';
  }
}
