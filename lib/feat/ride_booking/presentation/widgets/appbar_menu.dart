part of '../index.dart';

class AppbarMenu extends StatelessWidget {
  const AppbarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 20.0,
      ),
      onPressed: () {
        Navigator.pushNamed(context, RouteNames.profile);
      },
      icon: const Icon(Icons.menu_rounded, size: 28, color: Colors.black),
    );
  }
}
