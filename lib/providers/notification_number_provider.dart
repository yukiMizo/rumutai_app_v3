import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../local_data.dart';

class AllNotificationIdNotifier extends StateNotifier<List<String>> {
  AllNotificationIdNotifier() : super([]);

  void removeData(String data) {
    List<String> tmpList = state;
    tmpList.remove(data);
    state = [...tmpList];
  }

  void updateAllData(List<String> newData) {
    state = [...newData];
  }
}

class ReadNotificationIdNotifier extends StateNotifier<List<String>> {
  ReadNotificationIdNotifier() : super([]);

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
    await setAllNotificationIdProviderFromFirestore(ref);

    //set provider data from local
    await _setReadNotificationIdProviderFromLocal(ref);
  }

  static Future<void> setAllNotificationIdProviderFromFirestore(WidgetRef ref) async {
    final List<String> notificationIdList = [];
    debugPrint("loadedNotificationDataForInit");
    await FirebaseFirestore.instance.collection("notificationToRead").doc("notificationToReadDoc").get().then((DocumentSnapshot doc) {
      final Map gotMap = doc.data() as Map;
      gotMap.forEach((id, _) => notificationIdList.add(id));
    });
    ref.read(allNotificationIdProvider.notifier).updateAllData(notificationIdList);
  }

  static Future<void> readNotification(WidgetRef ref, String id) async {
    //set local data
    final List<String> tmpList = await LocalData.readLocalData<List>("readNotification");
    tmpList.add(id);
    await LocalData.saveLocalData<List>("readNotification", tmpList);

    //set provider data from local
    _setReadNotificationIdProviderFromLocal(ref);
  }

  static Future<void> _setReadNotificationIdProviderFromLocal(ref) async {
    //set readNotificationIdProvider from local
    final List<String> emptyList = [];
    final List<String> dataFromLocal = (await LocalData.readLocalData<List>("readNotification") ?? emptyList);

    //firestoreから消去されたメッセージはローカルからも消去
    final List<String> allNotificationId = ref.read(allNotificationIdProvider);
    List<String> newDataFromLocal = [];
    for (String data in dataFromLocal) {
      if (allNotificationId.contains(data)) {
        newDataFromLocal.add(data);
      }
    }
    LocalData.saveLocalData<List>("readNotification", newDataFromLocal);

    ref.read(readNotificationIdProvider.notifier).updateAllData(newDataFromLocal);
  }
}
