import 'package:Acorn/services/constants.dart';

String idGenerator() {
  final now = Constants.dateToday;
  return now.microsecondsSinceEpoch.toString();
}
