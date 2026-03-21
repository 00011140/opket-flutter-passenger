import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/cubit/ride_cubit.dart';

class CallingText extends StatefulWidget {
  const CallingText({super.key});

  @override
  State<CallingText> createState() => _CallingTextState();
}

class _CallingTextState extends State<CallingText> {
  late Stopwatch _stopwatch;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _start() {
    _stopwatch.reset();
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  void _stop() {
    _timer?.cancel();
    _stopwatch.stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  String _formatTime() {
    final minutes = _stopwatch.elapsed.inMinutes;
    final seconds = _stopwatch.elapsed.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideCubit, RideState>(
      listener: (context, state) {
        if (state is RideRequestSuccess) {
          _start();
        } else if (state is RideRequestEndCall) {
          _stop();
        }
      },
      builder: (context, state) {
        return Text(
          state is RideRequestLoading ? "Chaqirilyapti..." : _formatTime(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}
