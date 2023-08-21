import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsTab extends StatefulWidget {
  static const title = 'Settings';
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  var switchPushNotification = false;
  var switchLocation = false;
  var switchStatus = false;
  var switchGeofence = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
    );
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
    } else if(status.isDenied){
      return false;
    }
    return false;
  }

  void _showPrompt(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Permissions'),
          content:
              const Text('Please disable push notifications in the settings.'),
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
                  if(!result){
                    setState(() => switchPushNotification = false);
                  } else{
                    setState(() => switchPushNotification = true);
                  }
                });
              } else {
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
                  if(!result){
                    setState(() => switchLocation = false);
                  } else{
                    setState(() => switchLocation = true);
                  }
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
      ],
    );
  }
}
