import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:opket/components/app_card.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/services/location_service.dart';

class AllowLocationDialog extends StatelessWidget {
  const AllowLocationDialog({super.key, required this.onLocationEnabled});
  final VoidCallback onLocationEnabled;

  static const imageUrl =
      "https://res.cloudinary.com/djulzyyif/image/upload/v1771579823/Screenshot_2026-02-20_at_2.29.16_PM_rhscpx.png";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md_lg),
      child: AppCard(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Joylashuvga ruxsat bering",
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.md),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AspectRatio(
                    aspectRatio: 13 / 9,
                    child: ClipRRect(
                      // important for rounded corners
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,

                        placeholder: (context, url) => _imagePlaceHolder(),
                        errorWidget: (context, url, error) =>
                            _imagePlaceHolder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                AppIconButtonRectangle(
                  text: "Ruxsat berish",
                  onPressed: () async {
                    Navigator.pop(context);
                    final result = await LocationService.requestPermission();
                    if (result.granted) onLocationEnabled();
                  },
                  backgroundColor: const Color(0xFFFFE711),
                  textColor: Colors.black,
                  height: 55,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceHolder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade100,
      ),
    );
  }
}
