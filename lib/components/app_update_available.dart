import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:opket/components/app_button.dart';

class AppUpdateAvailable extends StatefulWidget {
  const AppUpdateAvailable({super.key});

  @override
  State<AppUpdateAvailable> createState() => _AppUpdateAvailableState();
}

class _AppUpdateAvailableState extends State<AppUpdateAvailable> {
  bool _isChecking = true;
  bool _isUpdateAvailable = false;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (!mounted) return;

      setState(() {
        _isUpdateAvailable =
            info.updateAvailability == UpdateAvailability.updateAvailable;
        _isChecking = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isChecking = false;
        _isUpdateAvailable = false;
      });
    }
  }

  Future<void> _startUpdateFlow() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      debugPrint('Update failed: $e');
    } finally {
      // Re-check update status after flow
      await _checkForUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking || !_isUpdateAvailable || _dismissed) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    return AppButton(
      text: "Yangilash",
      isLoading: false,
      onPressed: _startUpdateFlow,
      backgroundColor: Colors.blue.withOpacity(0.15),
      customText: Text(
        "Yangilash",
        style: TextStyle(fontSize: 18, color: Colors.blue),
      ),
    );
  }
}
