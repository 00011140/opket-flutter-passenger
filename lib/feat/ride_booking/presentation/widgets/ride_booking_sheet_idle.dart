part of '../index.dart';

class RideBookingSheetIdle extends StatelessWidget {
  const RideBookingSheetIdle({super.key, required this.onRecenter});
  final VoidCallback onRecenter;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          AppContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // FoodLogo(),
                // Expanded(
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: RideOptionsInstant(),
                //   ),
                // ),
                SizedBox(width: AppSpacing.sm),
                RecenterButton(onTap: onRecenter),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(bottom: 8, top: AppSpacing.sm),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: const [
                BoxShadow(blurRadius: 15, color: Colors.black12),
              ],
              color: Colors.white,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BottomsheetGrabber(),
                  SizedBox(height: AppSpacing.sm),
                  RideOptionsInstant(),
                  SizedBox(height: AppSpacing.sm_md),
                  Row(
                    children: [
                      AppbarMenu(),
                      SizedBox(width: AppSpacing.md),
                      Expanded(child: RequestRideButton()),
                      SizedBox(width: AppSpacing.md),
                      RideOptionsButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
