// import 'package:betterloop/theme/colors.dart';
import 'package:flutter/material.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key, required this.controller, required this.tabs});
  final TabController controller;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent, // important
      shadowColor: Colors.transparent,

      child: Container(
        height: 60,
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(200),
        ),
        child: TabBar(
          dividerHeight: 0,
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          physics: NeverScrollableScrollPhysics(),
          tabAlignment: TabAlignment.center,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          controller: controller,
          labelPadding: EdgeInsets.all(0),
          indicator: BoxDecoration(
            // color: Colors.yellow,
            borderRadius: BorderRadius.circular(200),
          ),
          tabs: tabs,
          indicatorPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
    );
  }
}
