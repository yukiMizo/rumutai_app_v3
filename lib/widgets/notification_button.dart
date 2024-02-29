import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumutai_app/themes/app_color.dart';

import '../screens/notification/notifications_screen.dart';

import '../providers/notification_number_provider.dart';

class NotificationButton extends ConsumerWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int notificationCount = ref.watch(unreadNotificationNumberProvider);
    return Badge(
      label: Text(notificationCount.toString()),
      backgroundColor: AppColors.accentColor,
      alignment: const Alignment(0.3, -0.3),
      isLabelVisible: notificationCount != 0,
      child: IconButton(
        onPressed: () => Navigator.of(context).pushNamed(NotificationsScreen.routeName),
        icon: const Icon(Icons.notifications),
      ),
    );
  }
}
