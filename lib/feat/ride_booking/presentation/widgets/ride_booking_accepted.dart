part of '../index.dart';

class RideBookingAccepted extends StatefulWidget {
  final DriverModel driver;

  const RideBookingAccepted({super.key, required this.driver});

  @override
  State<RideBookingAccepted> createState() => _RideBookingAcceptedState();
}

class _RideBookingAcceptedState extends State<RideBookingAccepted> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          RideBookingStarted(),
          SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.driver.carColor} ${widget.driver.carModel}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: _callDriver,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 19, 202, 65),
                      ),
                      icon: Icon(Icons.phone),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    widget.driver.name,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CarPlate(carNumber: widget.driver.carNumber),
                const SizedBox(height: AppSpacing.md),
                CancelRideButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _callDriver() async {
    final phone = widget.driver.phone.addUzbCode();
    final Uri uri = Uri.parse('tel:$phone');

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
