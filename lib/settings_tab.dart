import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsTab extends StatefulWidget {
  static const title = 'Settings';
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool switchPushNotification = false;
  bool switchLocation = false;
  bool switchStatus = false;
  bool switchGeofence = false;

  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  @override
  void dispose() {
    saveSettings();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
    );
  }

  Future<void> saveSettings() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotification',switchPushNotification);
    await prefs.setBool('location',switchLocation);
    await prefs.setBool('status',switchStatus);
    await prefs.setBool('geofence',switchGeofence);
  }

  Future<void> loadSettings() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
    switchPushNotification =  prefs.getBool('pushNotification')??false;
    switchLocation =  prefs.getBool('location')??false;
    switchStatus =  prefs.getBool('status')??false;
    switchGeofence =  prefs.getBool('geofence')??false;
    });
  }

  Future<bool> setPermission(var permission) async {
    late PermissionStatus status;
    if (permission == 'Notification') {
      status = await Permission.notification.request();
    } else if (permission == 'Location') {
      status = await Permission.location.request();
    } else{
      return false;
    }

    if (status.isGranted) {
      return true;
    }
    return false;
  }

  void _showPrompt(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissions Denied'),
          content:
              const Text('To enable or disable permissions, please go to app settings.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Open App Settings'),
            ),
          ],
        );
      },
    ).then((result) {
      if (result != null && result) {
        openAppSettings();
      }
    });
  }

  Widget _buildList() {
    return ListView(
      children: [
        const Padding(padding: EdgeInsets.only(top: 24)),
        ListTile(
          title: const Text('Enable Push Notifications'),
          trailing: Switch.adaptive(
            value: switchPushNotification,
            onChanged: (value) async {
              if (value) {
                await setPermission('Notification').then((result) {
                    setState(() => switchPushNotification = result);
                });
              } else{
                _showPrompt(context);
                setState(() => switchPushNotification = false);
              }
            },
          ),
        ),
        ListTile(
          title: const Text('Allow Location Tracking'),
          trailing: Switch.adaptive(
            value: switchLocation,
            onChanged: (value) async{
              if (value) {
                await setPermission('Location').then((result) {
                    setState(() => switchLocation = result);
                });
              } else {
                _showPrompt(context);
                setState(() => switchLocation = false);
              }
            }),
        ),
        ListTile(
          title: const Text('Show Status Updates'),
          trailing: Switch.adaptive(
              value: switchStatus,
              onChanged: (value) {
                setState(() => switchStatus = value);
              }),
        ),
        ListTile(
          title: const Text('Allow Geofence'),
          trailing: Switch.adaptive(
              value: switchGeofence,
              onChanged: (value) {
                setState(() => switchGeofence = value);
              }),
        ),
        ListTile(
          title: const Text('Open App Settings'),
          trailing: TextButton(
              onPressed: () => openAppSettings(), 
              child: const Text("Open Settings"),)
              // Switch.adaptive(
              // value: switchGeofence,
              // onChanged: (value) {
              //   setState(() => switchGeofence = value);
              // }),
        ),
      ],
    );
  }
}
