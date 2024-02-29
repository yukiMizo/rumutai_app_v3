import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../local_data.dart';

class AllNotificationIdNotifier extends StateNotifier<List<String>> {
  AllNotificationIdNotifier() : super([]);

  void removeData(String data) {
    state.remove(data);
  }

  void updateAllData(List<String> newData) {
    state = [...newData];
  }
}

class ReadNotificationIdNotifier extends StateNotifier<List<String>> {
  ReadNotificationIdNotifier() : super([]);

  void removeData(String data) {
    state.remove(data);
  }

  void addData(String data) {
    if (state.contains(data)) {
      return;
    }
    List<String> tmpList = state;
    tmpList.add(data);
    state = [...tmpList];
  }

  void updateAllData(List<String> newData) {
    state = [...newData];
  }
}

final unreadNotificationNumberProvider = StateProvider<int>((ref) {
  final List<String> allNotificationId = ref.watch(allNotificationIdProvider);
  final List<String> readNotificationId = ref.watch(readNotificationIdProvider);
  print("helloddddd");
  int unreadNotificationNumber = 0;
  for (String id in allNotificationId) {
    if (!readNotificationId.contains(id)) {
      unreadNotificationNumber++;
    }
  }
  return unreadNotificationNumber;
});
final unreadNotificationIdProvider = StateProvider<List<String>>((ref) {
  final List<String> allNotificationId = ref.watch(allNotificationIdProvider);
  final List<String> readNotificationId = ref.watch(readNotificationIdProvider);
  List<String> unreadNotificationId = [];
  for (String id in allNotificationId) {
    if (!readNotificationId.contains(id)) {
      unreadNotificationId.add(id);
    }
  }
  return unreadNotificationId;
});

final readNotificationIdProvider = StateNotifierProvider<ReadNotificationIdNotifier, List<String>>((ref) => ReadNotificationIdNotifier());
final allNotificationIdProvider = StateNotifierProvider<AllNotificationIdNotifier, List<String>>((ref) => AllNotificationIdNotifier());

class NotificationNumberManager {
  static Future<void> setNotificationNumber(WidgetRef ref) async {
    //set allNotificationListProvider from firestore
    final List<String> notificationIdList = [];
    debugPrint("loadedNotificationDataForInit");
    await FirebaseFirestore.instance.collection("notificationToRead").doc("notificationToReadDoc").get().then((DocumentSnapshot doc) {
      final Map gotMap = doc.data() as Map;
      gotMap.forEach((id, _) => notificationIdList.add(id));
    });
    ref.read(allNotificationIdProvider.notifier).updateAllData(notificationIdList);

    //set provider data from local
    await _setReadNotificationIdProviderFromLocal(ref);
  }

  static Future<void> _setReadNotificationIdProviderFromLocal(ref) async {
    //set readNotificationIdProvider from local
    final List<String> emptyList = [];
    final List<String> dataFromLocal = (await LocalData.readLocalData<List>("readNotification") ?? emptyList);
    ref.read(readNotificationIdProvider.notifier).updateAllData(dataFromLocal);
  }

  static Future<void> readNotification(WidgetRef ref, String id) async {
    //set local data
    final List<String> tmpList = await LocalData.readLocalData<List>("readNotification");
    tmpList.add(id);
    await LocalData.saveLocalData<List>("readNotification", tmpList);

    //set provider data from local
    _setReadNotificationIdProviderFromLocal(ref);
  }
}
