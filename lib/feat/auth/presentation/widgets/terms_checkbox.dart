import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:opket/app/router/route_names.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsCheckbox extends StatefulWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final bool shake; // Trigger shake animation

  const TermsCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
    this.shake = false,
  }) : super(key: key);

  @override
  _TermsCheckboxState createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(TermsCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger shake if shake == true
    if (widget.shake && !widget.value) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetAnimation.value, 0),
          child: child,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: widget.value,
            onChanged: widget.onChanged,
            activeColor: Colors.blue,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'Davom etish orqali siz rozisiz ',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                children: [
                  TextSpan(
                    text: 'Maxfiylik siyosati',
                    style: TextStyle(
                      color: Colors.blue, // Highlight color
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _openPrivacyPolicy,
                  ),
                  TextSpan(
                    text: ' va ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextSpan(
                    text: 'Foydalanish shartlariga',
                    style: TextStyle(
                      color: Colors.blue, // Highlight color
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          RouteNames.termsAndConditions,
                        );
                      },
                  ),
                  TextSpan(
                    text: '.',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final Uri url = Uri.parse(
      'https://www.freeprivacypolicy.com/live/1da1d328-81b8-47ef-a3b8-45349e4d6a26',
    );

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
