import 'package:intl/intl.dart';

final NumberFormat _inr = NumberFormat.decimalPattern('en_IN');

/// Formats an amount the same way the web prototype's `fmt()` helper does:
/// "₹1,25,900" with Indian digit grouping.
String rupees(num amount) => '₹${_inr.format(amount.round())}';
