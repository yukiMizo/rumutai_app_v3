import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../local_data.dart';

final day1dateProvider = StateProvider<DateTime>((ref) => DateTime(2024, 3, 13));
final day2dateProvider = StateProvider<DateTime>((ref) => DateTime(2024, 3, 14));

class RumutaiDateManager {
  static final formatter = DateFormat('yyyy-M-d');
  static Future<void> setDateData(WidgetRef ref) async {
    try {
      debugPrint("loadedDateData");
      final rumutaiScheduleData = await FirebaseFirestore.instance.collection("rumutaiSchedule").doc("rumutaiScheduleDoc").get();
      final day1data = rumutaiScheduleData["day1"];
      final day2data = rumutaiScheduleData["day2"];

      final String day1dateString = formatter.format(DateTime(day1data["year"], day1data["month"], day1data["day"]));
      final String day2dateString = formatter.format(DateTime(day2data["year"], day2data["month"], day2data["day"]));
      //localに保存
      await LocalData.saveLocalData<String>("day1date", day1dateString);
      await LocalData.saveLocalData<String>("day2date", day2dateString);
      //providerの値を更新
      await _setDateDataFromLocal(ref);
    } catch (_) {
      await _setDateDataFromLocal(ref);
    }
  }

  static Future<void> _setDateDataFromLocal(WidgetRef ref) async {
    final String? day1dateString = await LocalData.readLocalData<String>("day1date");
    final String? day2dateString = await LocalData.readLocalData<String>("day2date");
    if (day1dateString == null || day2dateString == null) {
      return;
    }

    //不必要な更新を防ぐ
    if (formatter.format(ref.read(day1dateProvider)) != day1dateString) {
      ref.read(day1dateProvider.notifier).state = formatter.parse(day1dateString);
    }
    if (formatter.format(ref.read(day2dateProvider)) != day2dateString) {
      ref.read(day2dateProvider.notifier).state = formatter.parse(day2dateString);
    }
  }
}
