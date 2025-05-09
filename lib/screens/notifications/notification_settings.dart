// gofit_app/lib/screens/notification_settings.dart
import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool isReminderOn = true;
  TimeOfDay reminderTime = TimeOfDay(hour: 19, minute: 0);

  void _pickTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );
    if (newTime != null) {
      setState(() {
        reminderTime = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminder Settings')),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Daily Workout Reminder'),
              value: isReminderOn,
              onChanged: (val) {
                setState(() => isReminderOn = val);
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule, color: Colors.orange),
              title: Text('Reminder Time'),
              subtitle: Text('${reminderTime.format(context)}'),
              onTap: isReminderOn ? _pickTime : null,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // ممكن تضيف حفظ في Local أو Firebase
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Settings saved!')));
              },
              child: Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
