import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../local_data.dart';

enum LoginStatus { isLoggedInRumutaiStaff, loggedInAdmin }

final pickedPersonForMyGameProvider = StateProvider<String>((ref) => "");

final isLoggedInRumutaiStaffProvider = StateProvider<bool>((ref) => false);
final isLoggedInAdminProvider = StateProvider<bool>((ref) => false);

class LocalDataManager {
  static Future tryLogin({
    //TODO
    required WidgetRef ref,
    required String hrAndNumber,
    required List<LoginStatus> newLoginStatusList,
  }) async {
    //update local data
    final List<String> loginStatusStringList = [];
    for (var loginStatus in newLoginStatusList) {
      loginStatusStringList.add(loginStatus.name);
    }
    await LocalData.saveLocalData<String>("hrAndNumber", hrAndNumber);
    await LocalData.saveLocalData<List>("currentLoginStatusList", loginStatusStringList);
    //update provider data
    await setLoginDataFromLocal(ref);
  }

  static Future<void> setLoginDataFromLocal(WidgetRef ref) async {
    ref.read(pickedPersonForMyGameProvider.notifier).state = await LocalData.readLocalData<String>("pickedPersonForMyGame");

    ref.read(isLoggedInAdminProvider.notifier).state = await LocalData.readLocalData<bool>("isLoggedInAdmin");
    ref.read(isLoggedInRumutaiStaffProvider.notifier).state = await LocalData.readLocalData<bool>("isLoggedInRumutaiStaff");
  }
}
