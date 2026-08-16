import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Formatting helpers for Currency, Dates, Percentages, and Truncation.
class Formatters {
  Formatters._();

  static String currency(double amount, {String symbol = AppConstants.currencySymbol}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  static String discountPercent(double originalPrice, double discountedPrice) {
    if (originalPrice <= 0 || discountedPrice >= originalPrice) return '0%';
    final discount = ((originalPrice - discountedPrice) / originalPrice) * 100;
    return '${discount.round()}% OFF';
  }
}
