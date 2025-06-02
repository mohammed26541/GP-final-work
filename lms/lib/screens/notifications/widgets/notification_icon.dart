import 'package:flutter/material.dart';

/// Widget that displays an icon based on notification type
class NotificationIcon extends StatelessWidget {
  final String type;

  const NotificationIcon({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;
    
    switch (type.toLowerCase()) {
      case 'course':
        iconData = Icons.book;
        iconColor = Colors.blue;
        break;
      case 'payment':
        iconData = Icons.payment;
        iconColor = Colors.green;
        break;
      case 'chat':
        iconData = Icons.chat;
        iconColor = Colors.purple;
        break;
      case 'system':
      default:
        iconData = Icons.notifications;
        iconColor = Colors.orange;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(
          (iconColor.r * 255).round(),
          (iconColor.g * 255).round(),
          (iconColor.b * 255).round(),
          0.1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }
}
