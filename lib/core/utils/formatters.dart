import 'package:intl/intl.dart';

class AppFormatters {
  static final NumberFormat _currencyFormat = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _numberFormat = NumberFormat('#,###', 'en_US');

  static String formatCurrency(num amount) {
    return _currencyFormat.format(amount);
  }

  static String formatNumber(num number) {
    return _numberFormat.format(number);
  }
}

extension NumberFormattingExtension on num {
  String get fCurrency => AppFormatters.formatCurrency(this);
  String get fNumber => AppFormatters.formatNumber(this);
}
