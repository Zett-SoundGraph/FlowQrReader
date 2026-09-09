import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:qr_reader/core/constants/index.dart';
import 'package:qr_reader/core/di/index.dart';
import 'package:qr_reader/domain/entities/index.dart';
import 'package:qr_reader/domain/usecases/index.dart';
import 'package:qr_reader/presentation/cubit/index.dart';
import 'package:qr_reader/presentation/screens/device_role_picker_screen.dart';
import 'package:qr_reader/presentation/screens/scanner_screen.dart';

/// App root: resolves which of the 3 fixed roles this physical unit is
/// (previously-saved role if any, otherwise the on-device picker) BEFORE
/// ever constructing ScannerCubit — its constructor connects to MQTT and
/// publishes the heartbeat immediately, so DeviceIdentity must already be
/// applied by the time that happens.
class DeviceRoleGate extends StatefulWidget {
  const DeviceRoleGate({super.key});

  @override
  State<DeviceRoleGate> createState() => _DeviceRoleGateState();
}

class _DeviceRoleGateState extends State<DeviceRoleGate> {
  final _getSavedDeviceRole = getIt<GetSavedDeviceRoleUsecase>();
  bool _loading = true;
  DeviceRole? _role;

  @override
  void initState() {
    super.initState();
    _resolveSavedRole();
  }

  Future<void> _resolveSavedRole() async {
    final saved = await _getSavedDeviceRole();
    if (saved != null) DeviceIdentity.apply(saved);
    if (!mounted) return;
    setState(() {
      _role = saved;
      _loading = false;
    });
  }

  void _onRoleSelected(DeviceRole role) {
    DeviceIdentity.apply(role);
    setState(() => _role = role);
  }

  /// Passed down to ScannerScreen so a technician can re-open the picker
  /// later to switch this unit to a different role — the previous
  /// ScannerCubit (and its MQTT connection under the old identity) is torn
  /// down automatically when this rebuild swaps it out for the picker.
  void _changeRole() => setState(() => _role = null);

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final role = _role;
    if (role == null) {
      return DeviceRolePickerScreen(onRoleSelected: _onRoleSelected);
    }

    return BlocProvider(
      key: ValueKey(role),
      create: (_) => getIt<ScannerCubit>(),
      child: ScannerScreen(onChangeRole: _changeRole),
    );
  }
}
