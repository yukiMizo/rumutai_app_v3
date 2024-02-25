import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../local_data.dart';

final day1dateProvider = StateProvider<DateTime>((ref) => DateTime(2024, 3, 13));
final day2dateProvider = StateProvider<DateTime>((ref) => DateTime(2024, 3, 14));

class PickedPersonDataManager {
  static Future<void> setDateDataFromFirestore(WidgetRef ref) async {}

  static Future<void> setDateDataFromLocal(WidgetRef ref) async {
    ref.read(day1dateProvider.notifier).state = await LocalData.readLocalData<String>("day1date") ?? "";
  }
}
