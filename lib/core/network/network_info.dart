import 'package:connectivity_plus/connectivity_plus.dart';

/// Network connectivity checker
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  /// Check if connected to mobile data
  Future<bool> get isMobileConnected async {
    final result = await connectivity.checkConnectivity();
    return result == ConnectivityResult.mobile;
  }

  /// Check if connected to WiFi
  Future<bool> get isWifiConnected async {
    final result = await connectivity.checkConnectivity();
    return result == ConnectivityResult.wifi;
  }

  /// Get connection type as string
  Future<String> get connectionType async {
    final result = await connectivity.checkConnectivity();
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'Unknown';
    }
  }
}
