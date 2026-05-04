import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';

import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_cubit.dart';

enum OtpCodeState { idle, success, error }

class OtpInputField extends StatefulWidget {
  final int length;
  final TextEditingController controller;
  final FocusNode focusNode;
  final OtpCodeState state;
  final ValueChanged<String>? onCompleted;
  final VoidCallback? onEditing; // notify parent to reset error

  const OtpInputField({
    super.key,
    this.length = 4,
    required this.controller,
    required this.focusNode,
    this.state = OtpCodeState.idle,
    this.onCompleted,
    this.onEditing,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  Timer? _cursorTimer;
  bool _showCursor = true;

  int _cursorIndex = 0;

  @override
  void initState() {
    super.initState();

    _cursorIndex = widget.controller.text.length;

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 0), weight: 1),
    ]).animate(_shakeCtrl);

    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => setState(() => _showCursor = !_showCursor),
    );
  }

  @override
  void didUpdateWidget(covariant OtpInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state == OtpCodeState.error &&
        oldWidget.state != OtpCodeState.error) {
      _shakeCtrl.forward(from: 0);
      HapticFeedback.heavyImpact();
    }

    if (widget.state == OtpCodeState.success &&
        oldWidget.state != OtpCodeState.success) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    _cursorTimer?.cancel();
    super.dispose();
  }

  void _handleTap(int index) {
    widget.focusNode.requestFocus();

    final textLength = widget.controller.text.length;
    final position = index.clamp(0, textLength);

    setState(() {
      _cursorIndex = position;
    });

    widget.controller.selection = TextSelection.collapsed(offset: position);
  }

  void _handleTextChange(String value) {
    setState(() {
      _cursorIndex = value.length;
    });

    widget.onEditing?.call(); // let parent reset error safely

    if (value.length == widget.length) {
      widget.onCompleted?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;

    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnim.value, 0),
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Hidden input (no weird hitbox issues)
          SizedBox(
            width: 0,
            height: 0,
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.length),
              ],
              onChanged: _handleTextChange,
            ),
          ),

          /// Visible UI
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              final char = index < text.length ? text[index] : '';
              final isActive = index == _cursorIndex;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _handleTap(index),
                child: _OtpBox(
                  value: char,
                  showCursor: isActive && _showCursor,
                  state: widget.state,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final String value;
  final bool showCursor;
  final OtpCodeState state;

  const _OtpBox({
    required this.value,
    required this.showCursor,
    required this.state,
  });

  Color get borderColor {
    switch (state) {
      case OtpCodeState.success:
        return Colors.green;
      case OtpCodeState.error:
        return Colors.red;
      case OtpCodeState.idle:
      default:
        return const Color.fromARGB(255, 223, 223, 223);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 52,
      height: 52,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: value.isNotEmpty
          ? Text(value, style: Theme.of(context).textTheme.headlineMedium)
          : showCursor
          ? Container(width: 2, height: 24, color: borderColor)
          : null,
    );
  }
}
