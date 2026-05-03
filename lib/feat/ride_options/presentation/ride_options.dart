part of '../index.dart';

class RideOptionsButton extends StatefulWidget {
  const RideOptionsButton({super.key});

  @override
  State<RideOptionsButton> createState() => _RideOptionsButtonState();
}

class _RideOptionsButtonState extends State<RideOptionsButton> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RideOptionsCubit>().getRideOptions();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton.filled(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          onPressed: () => _showRideOptions(context),
          icon: Icon(AppIcons.tune, size: 30, color: Colors.black),
        ),
        BlocBuilder<SelectedRideOptionsCubit, List<String>>(
          builder: (context, state) {
            if (state.isEmpty) {
              return SizedBox.shrink();
            }
            return Positioned(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success,
                ),
                child: Center(
                  child: Text(
                    state.length.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showRideOptions(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      barrierColor: Colors.black54,
      builder: (_) {
        return RideOptions();
      },
    );
  }
}

class RideOptions extends StatefulWidget {
  const RideOptions({super.key});

  @override
  State<RideOptions> createState() => _RideOptionsState();
}

class _RideOptionsState extends State<RideOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<RideOptionsCubit, RideOptionsState>(
        builder: (context, state) {
          if (state is RideOptionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RideOptionsError) {
            return Center(child: Text(state.message));
          }

          if (state is RideOptionsSuccess) {
            final options = state.options;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: options.length,
                    // separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      final s = options[index];
                      // final enabled = options.enabledServices.contains(s.id);

                      return Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.md),
                        child: AppCard(
                          borderRadius: 16,
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.xs,
                            horizontal: AppSpacing.md,
                          ),
                          color: Colors.white,
                          child:
                              BlocBuilder<
                                SelectedRideOptionsCubit,
                                List<String>
                              >(
                                builder: (context, selectedOtions) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    title: Text(
                                      s.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                    subtitle: Text("+${s.charge.toInt()}"),
                                    trailing: CupertinoSwitch(
                                      value: selectedOtions.contains(
                                        s.optionId,
                                      ),
                                      onChanged: (_) {
                                        context
                                            .read<SelectedRideOptionsCubit>()
                                            .toggleOption(s.optionId);
                                      },
                                    ),
                                  );
                                },
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
