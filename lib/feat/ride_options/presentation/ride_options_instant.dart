part of '../index.dart';

class RideOptionsInstant extends StatefulWidget {
  const RideOptionsInstant({super.key});

  @override
  State<RideOptionsInstant> createState() => _RideOptionsInstantState();
}

class _RideOptionsInstantState extends State<RideOptionsInstant> {
  Timer? _timer;

  bool _enabled = false;
  int _labelIndex = 0;

  String? _selectedService;

  List<RideOption> _labels = [];

  String get _currentService => _labels[_labelIndex].optionId;

  @override
  void dispose() {
    _stopSwitching();
    super.dispose();
  }

  // ================= TIMER =================

  void _startSwitching() {
    if (_labels.isEmpty) return;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (!mounted || _enabled || _labels.isEmpty) return;

      setState(() {
        _labelIndex = (_labelIndex + 1) % _labels.length;
      });
    });
  }

  void _stopSwitching() {
    _timer?.cancel();
    _timer = null;
  }

  // ================= TOGGLE =================

  void _onToggle(bool value) {
    setState(() => _enabled = value);
    print(_currentService);
    context.read<SelectedRideOptionsCubit>().toggleOption(_currentService);

    if (value) {
      _stopSwitching();
    } else {
      _startSwitching();
    }
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return BlocListener<RideOptionsCubit, RideOptionsState>(
      listener: (context, state) {
        if (state is RideOptionsSuccess) {
          final instantLabels = state.options.where((o) => o.instant).toList();

          if (instantLabels.isEmpty) return;

          setState(() {
            _labels = instantLabels;
            _labelIndex = 0; // reset index
          });

          if (!_enabled) {
            _startSwitching();
          }
        }
      },
      child: SizedBox(height: 55, child: Row(children: _optionsList())),
    );
  }

  List<Widget> _optionsList() {
    return _labels.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;

      return Padding(
        padding: EdgeInsets.only(
          right: index == _labels.length - 1 ? 0 : AppSpacing.sm,
        ),
        child: RideBookingOptionCard(
          title: option.titleForPassenger ?? option.title,
          price: option.charge.toInt(),
          optionId: option.optionId,
        ),
      );
    }).toList();
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
