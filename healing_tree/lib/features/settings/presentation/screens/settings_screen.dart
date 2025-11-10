import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Profile Section
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: const Text('User Profile'),
              subtitle: const Text('Tap to edit profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to profile edit
              },
            ),
          ),

          // Appearance
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Appearance',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Theme'),
              subtitle: const Text('System default'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Show theme selector
              },
            ),
          ),

          // Notifications
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications),
              title: const Text('Enable Notifications'),
              subtitle: const Text('Get reminded to write'),
              value: true,
              onChanged: (value) {
                // TODO: Toggle notifications
              },
            ),
          ),

          // Privacy & Security
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Privacy & Security',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SwitchListTile(
              secondary: const Icon(Icons.lock),
              title: const Text('Biometric Lock'),
              subtitle: const Text('Use fingerprint or face ID'),
              value: false,
              onChanged: (value) {
                // TODO: Toggle biometric lock
              },
            ),
          ),

          // Data
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Data',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.cloud_upload),
              title: const Text('Backup & Restore'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to backup screen
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export Data'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Show export options
              },
            ),
          ),

          // About
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Healing Tree'),
              subtitle: const Text('Version 0.1.0'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Show about dialog
              },
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
