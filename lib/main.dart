import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 2 Home Page',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter 2 Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final String title;



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _activeConnection = false;
  String T="";
  Future checkConnection() async{
    try{
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        setState(() {
          _activeConnection=true;
          T="I am connected to a mobile network.";
        });
      } else if (connectivityResult == ConnectivityResult.bluetooth) {
        setState(() {
          _activeConnection=true;
          T="I am connected to a bluetooth.";
        });
      } else if (connectivityResult == ConnectivityResult.other) {
        setState(() {
          _activeConnection=true;
          T="I am connected to a network which is not in the above mentioned networks.";
        });
      } else if (connectivityResult == ConnectivityResult.wifi) {
        setState(() {
          _activeConnection=true;
          T="I am connected to a wifi network.";
        });
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        setState(() {
          _activeConnection=true;
          T="I am connected to a ethernet network.";
        });
      } else if (connectivityResult == ConnectivityResult.vpn) {
        setState(() {
          _activeConnection=true;
          T="I am connected to a vpn network.";
        });
        // Note for iOS and macOS:
        // There is no separate network interface type for [vpn].
        // It returns [other] on any device (also simulator)
      } else if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          _activeConnection=false;
          T="I am not connected to any network.";
        });
      }
    } on SocketException catch(_){
      setState(() {
        _activeConnection=false;
        T="Inactive";
      });
    }
  }

  Future<void> createNotificationChannels() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id',
      'Channel Name',
      importance: Importance.high,
      playSound: true,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }


  @override
  void initState(){
    checkConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      // body: Center(
      //   child: Column(
      //
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         'Active Connection? $_activeConnection',
      //         style: const TextStyle(fontSize: 20),
      //       ),
      //       const Divider(),
      //       Text(T,
      //         style: const TextStyle(fontSize: 20),),
      //     ],
      //   ),
      //
      // ),
      body: Center(
          child: ElevatedButton(
            onPressed: () async{
              await createNotificationChannels();
            },
            child: const Text('Create Notification Channels'),
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          checkConnection();
        },
        tooltip: 'Connection',
        child: const Text("Check"),
      ),
    );
  }


  Widget build2(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
          child: ElevatedButton(
            onPressed: () async{
              await createNotificationChannels();
            }, child: const Text('Create Notification Channels'),
          )
      ),
    );
  }

}
