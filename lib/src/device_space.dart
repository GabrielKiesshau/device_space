import 'dart:async';
import 'package:flutter/services.dart';

class DeviceSpace {
  /// Free space in Bytes
  int free;

  /// Total space in Bytes
  int total;

  /// Threshold in Bytes for showing `lowOnSpace`
  late int lowOnSpaceThreshold;

  /// Number of digits to use for the Human Readable values
  int fractionDigits;

  /// Used space in Bytes
  int get used => total - free;

  /// Free space in a Human Readable format
  String get freeSize => _toHuman(free, fractionDigits);

  /// Used space in a Human Readable format
  String get usedSize => _toHuman(used, fractionDigits);

  /// Total space in a Human Readable format
  String get totalSize => _toHuman(total, fractionDigits);

  /// Usage as a percentage
  int get usagePercent => (usageValue * 100).round();

  /// Usage as a number from 0...1
  double get usageValue => used / total;

  /// Flag to show if the free space is below the lowOnSpaceThreshold
  bool get lowOnSpace => free <= lowOnSpaceThreshold;

  DeviceSpace({
    required this.free,
    required this.total,
    this.lowOnSpaceThreshold = 2 * 1024 * 1024 * 1024,
    this.fractionDigits = 2,
  });
}

/// Returns the device space for the device
Future<DeviceSpace> getDeviceSpace({
  /// Threshold in Bytes for showing `lowOnSpace`
  int lowOnSpaceThreshold = 2 * 1024 * 1024 * 1024,

  /// Number of digits to use for the Human Readable values
  int fractionDigits = 2,
}) async {
  int free = await _invokeMethodInt('getFreeSpace');
  int total = await _invokeMethodInt('getTotalSpace');
  return DeviceSpace(
    free: free,
    total: total,
    lowOnSpaceThreshold: lowOnSpaceThreshold,
    fractionDigits: fractionDigits,
  );
}

/// Makes a platform method call and returns an integer
MethodChannel _channel = const MethodChannel('device_space');
Future<int> _invokeMethodInt(String method) async {
  var result = await _channel.invokeMethod(method);
  return int.tryParse(result.toString()) ?? 0;
}

/// Units used for the `_toHuman` method
List<String> _units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

/// Returns bytes as a human readable string
///
/// Trailing 0's are automatically trimmed
///
/// * 102 B
/// * 43 MB
/// * 21.1 GB
String _toHuman(int bytes, int fractionDigits) {
  int multiplier = 1024;
  int lowerBoundary = 1;
  int upperBoundary = multiplier;
  for (var i = 0; i < _units.length; i++) {
    if (bytes < upperBoundary) {
      String fixed = (bytes / lowerBoundary).toStringAsFixed(fractionDigits);
      return '${_trimTrailingZeros(fixed)} ${_units[i]}';
    }
    lowerBoundary = upperBoundary;
    upperBoundary *= multiplier;
  }
  return 'Huge';
}

/// Trims trailing zeros (and possibly the dot) from a string
String _trimTrailingZeros(String value) {
  final regex = RegExp(r"\.?0+$");
  return value.replaceAll(regex, '');
}
