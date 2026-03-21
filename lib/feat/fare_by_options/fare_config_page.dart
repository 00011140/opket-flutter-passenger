import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:opket/components/app_card.dart';
import 'package:opket/components/app_container.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/core/spacing.dart';
import 'fare_cubit.dart';

class FareConfigPage extends StatefulWidget {
  const FareConfigPage({super.key});

  @override
  State<FareConfigPage> createState() => _FareConfigPageState();
}

class _FareConfigPageState extends State<FareConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<FareCubit, FareState>(
        builder: (context, state) {
          if (state.loading && state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.data == null) {
            return Center(child: Text(state.error ?? "No data"));
          }

          final fare = state.selectedFare!;
          final services = fare.services;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: services.length,
                  // separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final s = services[index];
                    final enabled = fare.enabledServices.contains(s.id);

                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: AppCard(
                        borderRadius: 16,
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.xs,
                          horizontal: AppSpacing.md,
                        ),
                        color: Colors.white,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text(
                            s.description,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          // subtitle: Text("Charge: ${s.charge}"),
                          trailing: CupertinoSwitch(
                            value: enabled,
                            onChanged: (_) {
                              context.read<FareCubit>().toggleService(s.id);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
