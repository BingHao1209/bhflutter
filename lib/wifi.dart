import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckWifi extends StatefulWidget {
  const CheckWifi({super.key});

  static const title = 'Wifi Status';

  @override
  State<CheckWifi> createState() => _CheckWifiState();
}

class _CheckWifiState extends State<CheckWifi> {
  bool _activeConnection = false;
  String T = "";
  int curIndex = 0;
  StreamSubscription<ConnectivityResult>? subscription;

  Future checkConnection() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      try {
        if (result == ConnectivityResult.mobile) {
          setState(() {
            _activeConnection = true;
            T = "I am connected to a mobile network.";
          });
        } else if (result == ConnectivityResult.bluetooth) {
          setState(() {
            _activeConnection = true;
            T = "I am connected to a bluetooth.";
          });
        } else if (result == ConnectivityResult.other) {
          setState(() {
            _activeConnection = true;
            T = "I am connected to a network which is not in the above mentioned networks.";
          });
        } else if (result == ConnectivityResult.wifi) {
          setState(() {
            _activeConnection = true;
            T = "I am connected to a wifi network.";
          });
        } else if (result == ConnectivityResult.ethernet) {
          setState(() {
            _activeConnection = true;
            T = "I am connected to a ethernet network.";
          });
        } else if (result == ConnectivityResult.vpn) {
          setState(() {
            _activeConnection = true;
            T = "I am connected to a vpn network.";
          });
        } else if (result == ConnectivityResult.none) {
          setState(() {
            _activeConnection = false;
            T = "I am not connected to any network.";
          });
        }
      } on SocketException catch (_) {
        setState(() {
          _activeConnection = false;
          T = "Inactive";
        });
      }
    });
  }

  @override
  void initState() {
    checkConnection();
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Active Connection? $_activeConnection',
              style: const TextStyle(fontSize: 20),
            ),
            const Divider(),
            Text(
              T,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
