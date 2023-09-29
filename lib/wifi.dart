import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckWifi extends StatefulWidget {
  const CheckWifi({super.key});
  static const route = '/wifi';
  static const title = 'Wifi Status';

  @override
  State<CheckWifi> createState() => _CheckWifiState();
}

class _CheckWifiState extends State<CheckWifi> {
  bool _activeConnection = false;
  String T = "";
  int curIndex = 0;
  StreamSubscription<ConnectivityResult>? subscription;

  // Future checkConnection() async {
  //   subscription = Connectivity()
  //       .onConnectivityChanged
  //       .listen((ConnectivityResult result) {
  //     try {
  //       if (result == ConnectivityResult.mobile) {
  //         setState(() {
  //           _activeConnection = true;
  //           T = "I am connected to a mobile network.";
  //         });
  //       } else if (result == ConnectivityResult.bluetooth) {
  //         setState(() {
  //           _activeConnection = true;
  //           T = "I am connected to a bluetooth.";
  //         });
  //       } else if (result == ConnectivityResult.other) {
  //         setState(() {
  //           _activeConnection = true;
  //           T = "I am connected to a network which is not in the above mentioned networks.";
  //         });
  //       } else if (result == ConnectivityResult.wifi) {
  //         setState(() {
  //           _activeConnection = true;
  //           T = "I am connected to a wifi network.";
  //         });
  //       } else if (result == ConnectivityResult.ethernet) {
  //         setState(() {
  //           _activeConnection = true;
  //           T = "I am connected to a ethernet network.";
  //         });
  //       } else if (result == ConnectivityResult.vpn) {
  //         setState(() {
  //           _activeConnection = true;
  //           T = "I am connected to a vpn network.";
  //         });
  //       } else if (result == ConnectivityResult.none) {
  //         setState(() {
  //           _activeConnection = false;
  //           T = "I am not connected to any network.";
  //         });
  //       }
  //     } on SocketException catch (_) {
  //       setState(() {
  //         _activeConnection = false;
  //         T = "Inactive";
  //       });
  //     }
  //   });
  // }
  //
  // @override
  // void initState() {
  //   checkConnection();
  //   super.initState();
  // }

  Connectivity connectivity = Connectivity();
  ConnectivityResult connectivityResult =ConnectivityResult.none;

  Future<void> checkConnectivityAndInternet() async {
    var conn = getConnectionValue(connectivityResult);
    //String statusMessage = 'Check Connection: $conn';
    String statusMessage = '';
    if (conn != 'None') {
      try {
        final response = await http.get(Uri.parse('https://www.google.com/'));
        if (response.statusCode == 200) {
          final startTime = DateTime.now();
          await http.get(Uri.parse('https://www.google.com/'));
          final endTime = DateTime.now();
          final duration = endTime.difference(startTime);
          final milliseconds = duration.inMilliseconds;

          if (milliseconds > 500) {
            statusMessage = '$conn : Poor Internet $milliseconds ms';
          }else {
            statusMessage = '$conn - Good Internet $milliseconds ms';
          }
          setState(() {
            _activeConnection = true;
          });
        }
      } catch (e) {
        debugPrint('$e');
      }
    } else {
      statusMessage = '$conn : No Internet';
    }

    setState(() {
      T = statusMessage;
    });
  }

  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500),(timer) async {
      if(!mounted) {
        timer.cancel();
      }else{
        ConnectivityResult result = await connectivity.checkConnectivity();
        setState(() {
          connectivityResult = result;
          checkConnectivityAndInternet();
        });
      }
    });
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
