import 'package:flutter/material.dart';
import 'wifi.dart';
import 'settings_tab.dart';

void main() {
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
      home: const MyHomePage(title: 'Flutter 2 Home Page'),
    );
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
        onTap: (int index) {
          setState(() {
            curIndex = index;
          });
        },
      ),
    );
  }
}
