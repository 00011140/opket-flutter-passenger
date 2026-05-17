import 'package:flutter/material.dart';
import 'package:opket/core/theme/spacing.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? text;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: const Color.fromARGB(91, 255, 255, 255),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.grey,
                        strokeWidth: 1,
                      ),
                      if (text != null)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.md),
                          child: Text(
                            text!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(fontSize: 20),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
