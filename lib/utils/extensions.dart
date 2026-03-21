// import 'package:intl/intl.dart';

import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  bool toBoolean() {
    if (toLowerCase() == "true" || toLowerCase() == "1") {
      return true;
    } else if (toLowerCase() == "false" || toLowerCase() == "0") {
      return false;
    } else {
      throw UnsupportedError(
        "Unsupported value for conversion to boolean: $this",
      );
    }
  }

  String addUzbCode() {
    return '+998$this';
  }

  formatUzbekPhone() {
    // Remove all non-digits
    final digits = replaceAll(RegExp(r'\D'), '');

    // Ensure it starts with Uzbekistan country code
    if (!digits.startsWith('998')) {
      return '+998 ';
    }

    // Slice safely
    String part(int start, int end) => digits.length > start
        ? digits.substring(start, digits.length < end ? digits.length : end)
        : '';

    final p1 = part(3, 5); // operator code
    final p2 = part(5, 8); // first block
    final p3 = part(8, 10); // second block
    final p4 = part(10, 12); // last block

    String result = '+998';
    if (p1.isNotEmpty) result += ' $p1';
    if (p2.isNotEmpty) result += ' $p2';
    if (p3.isNotEmpty) result += ' $p3';
    if (p4.isNotEmpty) result += ' $p4';

    return result;
  }
}

extension IntExtension on int {
  String addZero() {
    return this < 10 ? "0$this" : toString();
  }

  String formatUzbekSoumFromCents() {
    final int soum = this;

    final String digits = soum.toString();
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      final int positionFromEnd = digits.length - i;
      buffer.write(digits[i]);

      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }

  String formatWithThousands() {
    final formatter = NumberFormat.decimalPattern('fr_FR');
    return formatter.format(this);
  }

  String addUzbCode() {
    return '+998$this';
  }

  int tiyinToUzs() {
    return this ~/ 100;
  }
}
