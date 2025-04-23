import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "New Message",
      description: "You have received a new message.",
      time: "2 min ago",
      icon: Icons.message,
    ),
    NotificationItem(
      title: "Update Available",
      description: "A new update is available for the app.",
      time: "1 hour ago",
      icon: Icons.system_update,
    ),
    NotificationItem(
      title: "Reminder",
      description: "Don't forget your meeting at 4 PM.",
      time: "3 hours ago",
      icon: Icons.alarm,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
          title: Text("Notifications"),
          centerTitle: true,
          flexibleSpace: Container(
      decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xff5F2C82),
      Color(0xffA83279),],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    ),),
      body:
          notifications.isEmpty
              ? Center(child: Text("No notifications available."))
              : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationTile(notification: notifications[index]);
                },
              ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
  });
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTile({Key? key, required this.notification})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(notification.icon, color: Colors.blue),
        ),
        title: Text(notification.title),
        subtitle: Text(notification.description),
        trailing: Text(
          notification.time,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}
