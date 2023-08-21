import 'package:flutter/material.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:vibration/vibration.dart';

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

  Future checkConnection() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        setState(() {
          _activeConnection = true;
          T = "I am connected to a mobile network.";
        });
      } else if (connectivityResult == ConnectivityResult.bluetooth) {
        setState(() {
          _activeConnection = true;
          T = "I am connected to a bluetooth.";
        });
      } else if (connectivityResult == ConnectivityResult.other) {
        setState(() {
          _activeConnection = true;
          T = "I am connected to a network which is not in the above mentioned networks.";
        });
      } else if (connectivityResult == ConnectivityResult.wifi) {
        setState(() {
          _activeConnection = true;
          T = "I am connected to a wifi network.";
        });
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        setState(() {
          _activeConnection = true;
          T = "I am connected to a ethernet network.";
        });
      } else if (connectivityResult == ConnectivityResult.vpn) {
        setState(() {
          _activeConnection = true;
          T = "I am connected to a vpn network.";
        });
        // Note for iOS and macOS:
        // There is no separate network interface type for [vpn].
        // It returns [other] on any device (also simulator)
      } else if (connectivityResult == ConnectivityResult.none) {
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
  }

  @override
  void initState() {
    checkConnection();
    super.initState();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Vibration.vibrate(duration: 50);
          checkConnection();
        },
        tooltip: 'Connection',
        child: const Text("Check"),
      ),
    );
  }
}
