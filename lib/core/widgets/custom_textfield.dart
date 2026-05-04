import 'dart:math';
// import 'package:doppi/theme/colors.dart';
// import 'package:doppi/theme/sizes.dart';
// import 'package:doppi/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opket/core/theme/colors.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? topLabel;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final int maxLength;
  final int? maxLines;
  final bool filled;
  final Color? fillColor;
  final bool isPhone;
  final bool isBig;
  final bool border;
  final bool isRequired;
  final bool validate;
  final bool enabled;
  final bool isCarPlateNumber;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final String? helperText;
  final EdgeInsets? contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.label,
    this.autofillHints,
    this.topLabel,
    this.onFieldSubmitted,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.validate = false,
    this.isRequired = true,
    this.isBig = false,
    this.enabled = true,
    this.isCarPlateNumber = false,
    this.hintText,
    this.contentPadding,
    this.focusNode,
    required this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLength = 50,
    this.maxLines,
    this.style,
    this.labelStyle,
    this.fillColor,
    this.hintStyle,
    this.filled = true,
    this.border = true,
    this.isPhone = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      autofillHints: autofillHints,
      enabled: enabled,
      textCapitalization: TextCapitalization.words,
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: isBig ? TextStyle(fontSize: 24) : textTheme.labelMedium,
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: [
        if (keyboardType == TextInputType.number)
          FilteringTextInputFormatter.digitsOnly,
        if (isPhone) FilteringTextInputFormatter.digitsOnly,
        if (isPhone) UzbekistanPhoneFormatter(),
        if (isCarPlateNumber) LengthLimitingTextInputFormatter(6),
        if (isCarPlateNumber) UzbekPlateFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bu maydonni to\'ldirish majburiy';
        }

        if (!isValidUzbekPhone(value)) {
          return "Iltimos telefon raqamni to'liq kiriting";
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        fillColor: fillColor,
        helperText: helperText,
        errorStyle: TextStyle(color: Colors.red),
        helperMaxLines: 2,
        prefixIcon: isPhone
            ? Padding(
                padding: const EdgeInsets.only(left: 0, right: 4),
                child: Text(
                  "+998",
                  style: isBig
                      ? TextStyle(fontSize: 24)
                      : textTheme.labelMedium,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 12, right: 4),
                child: prefixIcon,
              ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: InputBorder.none,
        filled: filled,
        hintText: hintText ?? label,
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: _border(theme),
        disabledBorder: _border(theme),
        focusedBorder: _focusedBorder(theme),
        focusedErrorBorder: _errorBorder(theme),
        errorBorder: _errorBorder(theme),
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      ),
    );
  }

  bool isValidUzbekPhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length == 9;
  }

  UnderlineInputBorder? _border(ThemeData theme) {
    if (!border) return null;
    return UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
  }

  UnderlineInputBorder? _focusedBorder(ThemeData theme) {
    if (!border) return null;
    return UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54));
  }

  UnderlineInputBorder? _errorBorder(ThemeData theme) {
    if (!border) return null;

    return UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
    );
  }
}

class UzbekPlateFormatter extends TextInputFormatter {
  final RegExp privatePattern = RegExp(r'^[A-Z][0-9]{3}[A-Z]{2}$');
  final RegExp companyPattern = RegExp(r'^[0-9]{3}[A-Z]{3}$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.toUpperCase();

    // Allow empty
    if (text.isEmpty) return newValue;

    // Max 6 chars
    if (text.length > 6) return oldValue;

    // Validate progressively as user types
    for (int i = 0; i < text.length; i++) {
      String c = text[i];

      if (i == 0) {
        // Private starts with letter, company starts with digit → allow both here
        if (!RegExp(r'[A-Z0-9]').hasMatch(c)) return oldValue;
      }

      if (i >= 1 && i <= 2) {
        // If first char was letter → private → positions 2–3 must be digits
        // If first char was digit → company → positions 2–3 must be digits still
        if (!RegExp(r'[0-9]').hasMatch(c)) return oldValue;
      }

      if (i == 3) {
        if (text[0].contains(RegExp(r'[A-Z]'))) {
          // Private: 4th must be digit
          if (!RegExp(r'[0-9]').hasMatch(c)) return oldValue;
        } else {
          // Company: 4th must be letter
          if (!RegExp(r'[A-Z]').hasMatch(c)) return oldValue;
        }
      }

      if (i >= 4 && i <= 5) {
        if (text[0].contains(RegExp(r'[A-Z]'))) {
          // Private: last two must be letters
          if (!RegExp(r'[A-Z]').hasMatch(c)) return oldValue;
        } else {
          // Company: last two must also be letters
          if (!RegExp(r'[A-Z]').hasMatch(c)) return oldValue;
        }
      }
    }

    return newValue.copyWith(text: text);
  }
}

class UzbekistanPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 9 digits (00 000-00-00)
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    String formatted = '';

    if (digits.isNotEmpty) {
      // 00
      formatted = digits.substring(0, min(2, digits.length));

      // 00 000
      if (digits.length > 2) {
        formatted += ' ' + digits.substring(2, min(5, digits.length));
      }

      // 00 000-00
      if (digits.length > 5) {
        formatted += '-' + digits.substring(5, min(7, digits.length));
      }

      // 00 000-00-00
      if (digits.length > 7) {
        formatted += '-' + digits.substring(7, digits.length);
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
