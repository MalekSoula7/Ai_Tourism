class MrzParser {
  static Map<String, String> parse(String rawText) {
    final lines = rawText
        .split('\n')
        .map((l) => l.trim().replaceAll(' ', ''))
        .where((l) => l.length >= 30)
        .toList();

    if (lines.length < 2) return {};

    String? line1, line2;
    for (final line in lines) {
      if (line.startsWith('P<') && line.length >= 44) {
        line1 = line.padRight(44).substring(0, 44);
      } else if (RegExp(r'^\d{6}').hasMatch(line) && line.length >= 44) {
        line2 = line.padRight(44).substring(0, 44);
      }
    }

    if (line1 == null || line2 == null) return {};

    final result = <String, String>{};

    if (line1.length >= 44) {
      result['country'] = line1.substring(2, 5).replaceAll('<', '');
      final namePart = line1.substring(5, 44);
      final nameSplit = namePart.split('<<');
      result['surname'] = nameSplit[0].replaceAll('<', ' ').trim();
      if (nameSplit.length > 1) {
        result['givenNames'] = nameSplit[1].replaceAll('<', ' ').trim();
      }
    }

    if (line2.length >= 44) {
      result['passportNumber'] = line2.substring(0, 9).replaceAll('<', '');
      result['nationality'] = line2.substring(10, 13).replaceAll('<', '');
      result['dateOfBirth'] = _formatDate(line2.substring(13, 19));
      result['sex'] = line2.substring(20, 21);
      result['expiryDate'] = _formatDate(line2.substring(21, 27));
      result['mrzLine1'] = line1;
      result['mrzLine2'] = line2;
    }

    return result;
  }

  static String _formatDate(String mrzDate) {
    if (mrzDate.length != 6) return mrzDate;
    final year = int.tryParse(mrzDate.substring(0, 2)) ?? 0;
    final month = mrzDate.substring(2, 4);
    final day = mrzDate.substring(4, 6);
    final fullYear = year <= 30 ? '20${mrzDate.substring(0, 2)}' : '19${mrzDate.substring(0, 2)}';
    return '$fullYear-$month-$day';
  }
}
