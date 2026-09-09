import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:qr_reader/core/constants/index.dart';
import 'package:qr_reader/presentation/cubit/index.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key, this.onChangeRole});

  /// Opens the role picker again — null hides the "change role" button
  /// entirely (used by the widget test, which doesn't go through
  /// DeviceRoleGate).
  final VoidCallback? onChangeRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<ScannerCubit, ScannerState>(
            builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Barcode Scanner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _ConnectionBadge(connected: state.isConnected),
                    const Spacer(),
                    Text(
                      DeviceIdentity.deviceId,
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    if (onChangeRole != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onChangeRole,
                        icon: const Icon(Icons.swap_horiz, color: Colors.white54),
                        tooltip: 'Change scanner role',
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),
                if (state.lastBarcode.isNotEmpty) ...[
                  const Text('Last Scan',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    state.lastBarcode,
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                const Text('Log',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 4),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.logs.length,
                    itemBuilder: (_, i) => Text(
                      state.logs[i],
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectionBadge extends StatelessWidget {
  const _ConnectionBadge({required this.connected});

  final bool connected;

  @override
  Widget build(BuildContext context) {
    final color = connected ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 6),
          Text(
            connected ? 'ONLINE' : 'OFFLINE',
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
