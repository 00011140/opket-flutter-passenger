import 'package:flutter/material.dart';
import 'package:opket/core/widgets/app_button_rectangle.dart';

enum BalanceInfoType { success, error }

class BalanceInfo extends StatelessWidget {
  const BalanceInfo({
    super.key,
    this.message = '',
    this.customMessage,
    required this.onPressed,
    required this.type,
  });
  final String message;
  final List<TextSpan>? customMessage;
  final BalanceInfoType type;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _icon(),
        SizedBox(height: 10),
        if (customMessage == null)
          Text(
            message,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        if (customMessage != null)
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black, // default color
              ),
              children: customMessage,
            ),
          ),
        SizedBox(height: 10),
        AppButtonRectangle(text: "Yaxshi", onPressed: onPressed),
      ],
    );
  }

  Widget _icon() {
    if (type == BalanceInfoType.error) {
      return Icon(Icons.error_outline, size: 65, color: Colors.orange);
    } else {
      return Icon(
        Icons.check_circle_outline_rounded,
        size: 65,
        color: Colors.green,
      );
    }
  }
}
