import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumutai_app/providers/notification_number_provider.dart';
import 'package:rumutai_app/themes/app_color.dart';

import 'notifications_detail_screen.dart';

import '../../providers/sign_in_data_provider.dart';
import '../home_screen.dart';

class NotificationDataToPass {
  final Map data;
  final int index;

  NotificationDataToPass({
    required this.data,
    required this.index,
  });
}

class NotificationsScreen extends ConsumerStatefulWidget {
  static const routeName = "/notification-screen";

  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _isLoading = false;
  bool _isInit = true;
  final List<Map> _notifications = [];

  Future _loadData() async {
    setState(() {
      _isLoading = true;
    });

    List<String> notificationIdList = [];
    debugPrint("loadedNotificationData");
    await FirebaseFirestore.instance.collection("notificationToRead").doc("notificationToReadDoc").get().then((DocumentSnapshot doc) {
      final Map gotMap = doc.data() as Map;
      gotMap.forEach((id, map) {
        notificationIdList.add(id);
        _notifications.add({
          "id": id,
          "timeStamp": map["timeStamp"].toDate(),
          "content": map["content"],
          "title": map["title"],
        });
      });
    });
    //update provider
    ref.read(allNotificationIdProvider.notifier).updateAllData(notificationIdList);

    _notifications.sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildUnreadNotifier(String id) {
    final isUnread = ref.watch(unreadNotificationIdProvider).contains(id);
    return isUnread
        ? Container(
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.accentColor),
            height: 8,
            width: 8,
            margin: const EdgeInsets.only(right: 10),
          )
        : const SizedBox(width: 18);
  }

  Widget _buildNotificationWidget({
    required notificationData,
    required int index,
    required bool isLoggedInAdmin,
  }) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          NotificationsDetailScreen.routeName,
          arguments: NotificationDataToPass(data: notificationData, index: index),
        ),
        child: Hero(
          tag: "notification-tag$index",
          child: Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 20, top: 12, bottom: 12),
              child: Row(
                children: [
                  _buildUnreadNotifier(notificationData["id"]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 250,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            notificationData["title"],
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('yyyy/MM/dd HH:mm').format(notificationData["timeStamp"]),
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  if (isLoggedInAdmin) const Expanded(child: SizedBox()),
                  if (isLoggedInAdmin)
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) {
                          return _delteNotificationDialog(notificationData: notificationData);
                        },
                      ),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _delteNotificationDialog({required notificationData}) {
    bool dialogIsLoading = false;
    return StatefulBuilder(
      builder: (context, setStateInDialog) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: const Text("確認"),
          content: SizedBox(
            height: 200,
            width: 200,
            child: dialogIsLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                notificationData["title"],
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(notificationData["content"]),
                            ]),
                          ),
                        ),
                      ),
                      const Divider(),
                      const Text(
                        "を消去します。",
                      )
                    ],
                  ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            if (!dialogIsLoading)
              SizedBox(
                width: 120,
                height: 40,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("キャンセル"),
                ),
              ),
            if (!dialogIsLoading)
              SizedBox(
                width: 120,
                height: 40,
                child: FilledButton(
                  child: const Text("消去"),
                  onPressed: () async {
                    setStateInDialog(() {
                      dialogIsLoading = true;
                    });
                    final String notificationId = notificationData["id"];
                    await FirebaseFirestore.instance.collection("notification").doc(notificationId).delete();
                    await FirebaseFirestore.instance.collection("notificationToRead").doc("notificationToReadDoc").update({notificationId: FieldValue.delete()});

                    //provider 更新
                    ref.read(allNotificationIdProvider.notifier).removeData(notificationId);

                    dialogIsLoading = false;
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("通知を消去しました。")),
                    );
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(HomeScreen.routeName),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit) {
      _loadData();
      _isInit = false;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("通知一覧")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "通知はまだありません",
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: ((context, index) {
                    return _buildNotificationWidget(
                      notificationData: _notifications[index],
                      index: index,
                      isLoggedInAdmin: ref.watch(isLoggedInAdminProvider),
                    );
                  }),
                ),
    );
  }
}
