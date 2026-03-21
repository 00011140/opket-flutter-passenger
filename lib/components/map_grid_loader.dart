import 'package:flutter/material.dart';

class MapGridLoader extends StatelessWidget {
  const MapGridLoader({super.key});

  @override
  Widget build(BuildContext context) {
    const tileSize = 80.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / tileSize).ceil();
        final safeColumns = columns < 1 ? 1 : columns;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: safeColumns,
            childAspectRatio: 1,
          ),
          itemBuilder: (_, __) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                border: Border.all(color: const Color(0xFFd9d9d9), width: 0.5),
              ),
            );
          },
          itemCount: 100,
        );
      },
    );
  }
}
