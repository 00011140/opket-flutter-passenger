import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/cubit/premium_taxi_cubit.dart';
import 'package:opket/cubit/premium_taxi_state.dart';
import 'package:opket/feat/fare_by_options/fare_cubit.dart';

import 'dart:async';

class PremiumTaxi extends StatefulWidget {
  const PremiumTaxi({super.key});

  @override
  State<PremiumTaxi> createState() => _PremiumTaxiState();
}

class _PremiumTaxiState extends State<PremiumTaxi> {
  Timer? _timer;

  bool _enabled = false; // one switch controls everything
  int _labelIndex = 0;

  // This is the service that was chosen when user enabled the switch
  String? _selectedService; // "premium" or "comfort"

  static const _labels = ["Premium", "Comfort"];

  String get _currentService =>
      _labels[_labelIndex].toLowerCase(); // "premium"/"comfort"

  @override
  void initState() {
    super.initState();
    _startSwitching();
  }

  void _startSwitching() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (!mounted) return;
      if (_enabled) return; // safety: don't flip while enabled
      setState(() {
        _labelIndex = (_labelIndex + 1) % _labels.length;
      });
    });
  }

  void _stopSwitching() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopSwitching();
    super.dispose();
  }

  void _onToggle(bool value) {
    setState(() => _enabled = value);

    if (value) {
      // Switch turned ON -> lock current label as selected service and stop switching
      _selectedService = _currentService; // "premium" or "comfort"
      _stopSwitching();

      // If you still want to store premium in PremiumTaxiCubit only:
      if (_selectedService == "premium") {
        context.read<PremiumTaxiCubit>().setData(true);
      } else {
        context.read<PremiumTaxiCubit>().setData(false);
      }

      // Enable the selected service in FareCubit
      context.read<FareCubit>().toggleService(_selectedService!);
    } else {
      // Switch turned OFF -> disable previously selected service and resume switching
      if (_selectedService != null) {
        context.read<FareCubit>().toggleService(_selectedService!);
      }

      // premium cubit off when switch off
      context.read<PremiumTaxiCubit>().setData(false);

      _selectedService = null;
      if (_timer == null) _startSwitching();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PremiumTaxiCubit, PremiumTaxiState>(
      listener: (context, state) {
        if (state.status == PremiumTaxiStatus.notAvailable) {
          _onToggle(false);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _labels[_labelIndex],
            style: const TextStyle(fontFamily: 'WorkSans', fontSize: 16),
          ),
          const SizedBox(width: 12),
          CupertinoSwitch(value: _enabled, onChanged: _onToggle),
        ],
      ),
    );
  }
}
