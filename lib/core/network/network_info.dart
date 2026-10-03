import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final InternetConnection internetConnection;

  NetworkInfoImpl({
    required this.connectivity,
    required this.internetConnection,
  });

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none) &&
        connectivityResult.length == 1) {
      return false;
    }
    return await internetConnection.hasInternetAccess;
  }

  @override
  Stream<bool> get onConnectivityChanged {
    // Listen to internetConnection.onStatusChange for verified real internet access
    return internetConnection.onStatusChange.map(
      (status) => status == InternetStatus.connected,
    ).distinct();
  }
}
