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
      final rumutaiScheduleData = await FirebaseFirestore.instance.collection("rumutaiSchedule").doc("rumutaiScheduleDoc").get();
      final day1data = rumutaiScheduleData["day1"];
      final day2data = rumutaiScheduleData["day2"];
      //providerの値を更新
      ref.read(day1dateProvider.notifier).state = DateTime(day1data["year"], day1data["month"], day1data["day"]);
      ref.read(day2dateProvider.notifier).state = DateTime(day2data["year"], day2data["month"], day2data["day"]);
      //localに保存
      LocalData.saveLocalData<String>("day1date", formatter.format(ref.read(day1dateProvider)));
      LocalData.saveLocalData<String>("day2date", formatter.format(ref.read(day2dateProvider)));
    } catch (_) {
      _setDateDataFromLocal(ref);
    }
  }

  static Future<void> _setDateDataFromLocal(WidgetRef ref) async {
    final String? day1dateString = await LocalData.readLocalData<String>("day1date");
    final String? day2dateString = await LocalData.readLocalData<String>("day2date");
    if (day1dateString == null || day2dateString == null) {
      return;
    }
    ref.read(day1dateProvider.notifier).state = formatter.parse(day1dateString);
    ref.read(day2dateProvider.notifier).state = formatter.parse(day2dateString);
  }
}
