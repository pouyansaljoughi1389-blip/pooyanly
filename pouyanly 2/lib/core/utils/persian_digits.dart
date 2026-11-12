/// Converts Western and Arabic-Indic numerals to Persian numerals for UI display.
extension PersianDigits on String {
  String toPersianDigits() => replaceAllMapped(
        RegExp(r'[0-9٠-٩]'),
        (match) {
          const digits = '۰۱۲۳۴۵۶۷۸۹';
          final code = match.group(0)!.codeUnitAt(0);
          final value = code >= 0x0660 && code <= 0x0669
              ? code - 0x0660
              : code - 0x30;
          return digits[value];
        },
      );
}

String toPersianDigits(Object? value) => value.toString().toPersianDigits();
