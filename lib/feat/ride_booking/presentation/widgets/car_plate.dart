import 'package:flutter/material.dart';

class CarPlate extends StatelessWidget {
  const CarPlate({super.key, required this.carNumber});
  final String carNumber;

  @override
  Widget build(BuildContext context) {
    const plateHeight = 70.0;
    const flagBoxWidth = 25.0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black87, width: 2),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left region code box (selectable)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black87, width: 2),
              ),
            ),
            child: Text(
              "50",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
          // Series letter (one or two letters)
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                carNumber,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ),

          // Right flag + "uz"
          Container(
            width: flagBoxWidth,
            height: plateHeight - 24,
            margin: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                // Replace with your flag asset (small stripe image) or build with colored containers.
                // This example uses simple colored stripes to avoid requiring assets.
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(child: Container(color: Color(0xFF1F8A49))),
                      Expanded(child: Container(color: Color(0xFFFFFFFF))),
                      Expanded(child: Container(color: Color(0xFF0082CA))),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'UZ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
