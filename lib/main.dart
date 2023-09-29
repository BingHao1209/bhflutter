import 'package:flutter/material.dart';
import 'wifi.dart';
import 'settings_tab.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vibration/vibration.dart';

import 'api/firebase.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FireBaseApi().initNotifcation();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('launch_background');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter 2 Home Page',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
          useMaterial3: true,
        ),
        navigatorKey: navigatorKey,
        home: const MyHomePage(title: 'Flutter 2 Home Page'),
        routes: {
          CheckWifi.route: (context) => const CheckWifi(),
          SettingsTab.route: (context) => const SettingsTab(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String T = "";
  int curIndex = 0;
  final List<Widget> _bottomNav = <Widget>[
    const CheckWifi(),
    const SettingsTab(),
  ];
  final List<String> _appBarTitle = <String>[
    CheckWifi.title,
    SettingsTab.title,
  ];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
  const AndroidNotificationDetails(
    '12345678', // Replace with your own channel ID
    'BHFlutter22',
    channelDescription: 'This is a BH test channel',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );
  late final NotificationDetails platformChannelSpecifics;


  Future<void> scheduleNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Pressed another page',
      'You have pressed ${_appBarTitle[curIndex]}',
      platformChannelSpecifics,
    );
  }

  @override
  void initState() {
    platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_appBarTitle[curIndex]),
      ),
      body: _bottomNav[curIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi),
            label: 'Wifi',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: curIndex,
        onTap: (int index) async {
          Vibration.vibrate(duration: 50);
          setState(() {
            curIndex = index;
          });
          await scheduleNotification();
        },
      ),
    );
  }
}
