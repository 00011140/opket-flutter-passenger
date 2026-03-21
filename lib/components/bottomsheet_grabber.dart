import 'package:flutter/material.dart';

class BottomsheetGrabber extends StatelessWidget {
  const BottomsheetGrabber({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
