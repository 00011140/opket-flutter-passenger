import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/authentication_wrapper.dart';
import 'package:opket/cubit/auth_cubit.dart';
import 'package:opket/feat/food/models/restaurant_model.dart';
import 'package:opket/feat/food/restaurant_detail_page.dart';
import 'package:opket/utils/show_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantCard extends StatefulWidget {
  final RestaurantModel item;
  const RestaurantCard({super.key, required this.item});

  @override
  State<RestaurantCard> createState() => RestaurantCardState();
}

class RestaurantCardState extends State<RestaurantCard>
    with SingleTickerProviderStateMixin {
  bool liked = false;

  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _bounceTap() async {
    // press down -> release (bounce back)
    await _ctrl.forward();
    await _ctrl.reverse();

    _navigate();
  }

  void _navigate() {
    final authState = context.read<AuthCubit>().state;

    if (authState is UnAuthenticated) {
      showAppModelBottomSheet(context, const AuthenticationWrapper());

      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => RestaurantDetailPage(restaurant: widget.item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final card = Theme.of(context).cardColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.none,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _bounceTap,
        onTapDown: (_) => _ctrl.forward(),
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image
              // image
              ScaleTransition(
                scale: _scale,

                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  clipBehavior: Clip.hardEdge,

                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: item.bannerUrl != null
                            ? ClipRRect(
                                // important for rounded corners
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: item.bannerUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      _imagePlaceHolder(),
                                  errorWidget: (context, url, error) =>
                                      _imagePlaceHolder(),
                                ),
                              )
                            : _imagePlaceHolder(),
                      ),

                      // 🔥 Bottom dark gradient + name
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black54,
                                  Colors.black45,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(5, 12, 5, 0),
                child: Row(
                  children: [
                    const Icon(Icons.delivery_dining, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "${item.prepTimeMin}-${item.prepTimeMax} min",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (item.delivery.freeOverAmount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 236, 248, 231),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Bepul yetkazish",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 29, 143, 29),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceHolder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade100,
        ),
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.grey.shade300,
            size: 30,
          ),
        ),
      ),
    );
  }
}

class RestaurantsShimmer extends StatelessWidget {
  const RestaurantsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, __) => _shimmerBox(height: 240, radius: 20),
      ),
    );
  }

  static Widget _shimmerBox({
    double height = 16,
    double? width,
    double radius = 12,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
