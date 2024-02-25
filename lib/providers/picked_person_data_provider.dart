import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local_data.dart';

enum LoginStatus { isLoggedInRumutaiStaff, loggedInAdmin }

final pickedPersonForMyGameProvider = StateProvider<String>((ref) => "");

class PickedPersonDataManager {
  static Future<void> setPickedPersonDataFromLocal(WidgetRef ref) async {
    ref.read(pickedPersonForMyGameProvider.notifier).state = await LocalData.readLocalData<String>("pickedPersonForMyGame") ?? "";
  }
}
