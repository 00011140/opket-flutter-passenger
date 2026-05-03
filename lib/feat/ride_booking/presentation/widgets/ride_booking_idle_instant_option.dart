part of '../index.dart';

class RideBookingIdleInstantOption extends StatefulWidget {
  const RideBookingIdleInstantOption({super.key});

  @override
  State<RideBookingIdleInstantOption> createState() =>
      _RideBookingIdleInstantOptionState();
}

class _RideBookingIdleInstantOptionState
    extends State<RideBookingIdleInstantOption> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [RideOptionsInstant()],
        );
      },
    );
  }
}
