/// The 3 fixed physical scanner roles this build can be flashed/configured
/// as — deviceId is what actually gets published to Message Hub (topic
/// routing + heartbeat), never changed once a unit is registered under it.
/// [label] is only shown on this device's own role-picker screen, never
/// published anywhere.
enum DeviceRole {
  brew('scanner-order-01', 'Scanner Brew', 'Brew'),
  call('scanner-complete-01', 'Scanner Call', 'Call'),
  pickup('scanner-customer-01', 'Scanner Pickup', 'Pickup');

  const DeviceRole(this.deviceId, this.label, this.scanCode);

  final String deviceId;
  final String label;

  /// The barcode/QR text scanned on DeviceRolePickerScreen to pick this
  /// role — deliberately a word, not a digit, so it can never be confused
  /// with a real order number that happens to get scanned while the
  /// picker is still showing (an exact-match digit like "1" would risk
  /// exactly that if an order number were ever that short).
  final String scanCode;
}
