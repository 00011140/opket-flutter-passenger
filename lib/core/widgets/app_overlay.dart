import 'package:flutter/material.dart';

class AppOverlay extends StatelessWidget {
  const AppOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(89, 0, 0, 0),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }
}
