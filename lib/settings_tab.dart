import 'package:flutter/material.dart';


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

  Widget _buildList() {
    return ListView(
      children: [
        const Padding(padding: EdgeInsets.only(top: 24)),
        ListTile(
          title: const Text('Enable Push Notifications'),
          trailing: Switch.adaptive(
            value: switchPushNotification,
            onChanged: (value) =>
                setState(() => switchPushNotification = value),
          ),
        ),
        ListTile(
          title: const Text('Allow Location Tracking'),
          trailing: Switch.adaptive(
            value: switchLocation,
            onChanged: (value) => setState(() => switchLocation = value),
          ),
        ),
        ListTile(
          title: const Text('Show Status Updates'),
          trailing: Switch.adaptive(
            value: switchStatus,
            onChanged: (value) => setState(() => switchStatus = value),
          ),
        ),
        ListTile(
          title: const Text('Allow Geofence'),
          trailing: Switch.adaptive(
            value: switchGeofence,
            onChanged: (value) => setState(() => switchGeofence = value),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
    );
  }
}
