import 'dart:async';

import 'package:flutter/material.dart';

import 'package:qr_reader/core/di/index.dart';
import 'package:qr_reader/domain/entities/index.dart';
import 'package:qr_reader/domain/usecases/index.dart';

/// Lets whoever is setting up this physical unit pick which of the 3 fixed
/// scanner roles it is, instead of that being baked in at build time — one
/// APK now works for all 3 stations. The choice is saved (survives app
/// restarts/power cycles) and stays in effect until picked again here.
///
/// This device (a plain STB driving an HDMI monitor) has no touchscreen at
/// all, so tapping the on-screen buttons below only works on hardware that
/// DOES have a touch panel — the primary input here is scanning one of the
/// 3 printed role codes ("Brew"/"Call"/"Pickup" — see DeviceRole.scanCode)
/// with the same hardware scanner used for normal order scans, via the same
/// onScan channel ScannerCubit uses.
class DeviceRolePickerScreen extends StatefulWidget {
  const DeviceRolePickerScreen({super.key, required this.onRoleSelected});

  final ValueChanged<DeviceRole> onRoleSelected;

  @override
  State<DeviceRolePickerScreen> createState() => _DeviceRolePickerScreenState();
}

class _DeviceRolePickerScreenState extends State<DeviceRolePickerScreen> {
  final _saveDeviceRole = getIt<SaveDeviceRoleUsecase>();
  final _observeScan = getIt<ObserveScanUsecase>();
  StreamSubscription<String>? _scanSubscription;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _scanSubscription = _observeScan().listen(_handleScan);
  }

  void _handleScan(String code) {
    final trimmed = code.trim().toLowerCase();
    for (final role in DeviceRole.values) {
      if (role.scanCode.toLowerCase() == trimmed) {
        unawaited(_select(role));
        return;
      }
    }
  }

  Future<void> _select(DeviceRole role) async {
    if (_saving) return;
    setState(() => _saving = true);
    await _saveDeviceRole(role);
    if (!mounted) return;
    widget.onRoleSelected(role);
  }

  @override
  void dispose() {
    unawaited(_scanSubscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select This Scanner\'s Role',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Scan the printed Brew / Call / Pickup code for this station',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 32),
                for (final role in DeviceRole.values) ...[
                  _RoleButton(
                    role: role,
                    enabled: !_saving,
                    onTap: () => _select(role),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_saving) ...[
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({
    required this.role,
    required this.enabled,
    required this.onTap,
  });

  final DeviceRole role;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 64,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1C1E),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: Text('${role.scanCode} — ${role.label}'),
      ),
    );
  }
}
