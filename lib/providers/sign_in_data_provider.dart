import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../local_data.dart';

enum SignInType { rumutaiStaff, admin }

final isLoggedInRumutaiStaffProvider = StateProvider<bool>((ref) => false);
final isLoggedInAdminProvider = StateProvider<bool>((ref) => false);

class SignInDataManager {
  static String _stringToSaveLoginData(SignInType signInType) {
    switch (signInType) {
      case SignInType.rumutaiStaff:
        return "isLoggedInRumutaiStaff";
      case SignInType.admin:
        return "isLoggedInAdmin";
    }
  }

  //パスワードが変わっていた場合の処理
  static Future<String> checkIfPasswordChanged(WidgetRef ref) async {
    try {
      final isLoggedInRumutaiStaff = ref.read(isLoggedInRumutaiStaffProvider);
      final isLoggedInAdmin = ref.read(isLoggedInAdminProvider);

      if (!(isLoggedInRumutaiStaff || isLoggedInAdmin)) {
        return ""; //サインインしてない場合チェックする必要なし
      }
      debugPrint("loadedPasswordForChangeCheck");
      final passwordData = await FirebaseFirestore.instance.collection("password").doc("passwordDoc").get();
      if (isLoggedInRumutaiStaff) {
        final oldRumutaiStaffPassword = await LocalData.readLocalData<String>("rumutaiStaffPassword");
        if (passwordData["rumutaiStaff"] != oldRumutaiStaffPassword) {
          signOut(ref);
          return "ルム対スタッフ用のパスワードが変更されたので、サインアウトしました。";
        }
      }
      if (isLoggedInAdmin) {
        final oldAdminPassword = await LocalData.readLocalData<String>("adminPassword");
        if (passwordData["admin"] != oldAdminPassword) {
          signOut(ref);
          return "管理者用のパスワードが変更されたので、サインアウトしました。";
        }
      }
      return "";
    } catch (_) {
      return "";
    }
  }

  static Future signIn(
    WidgetRef ref,
    String password,
    SignInType signInType,
  ) async {
    //ローカルデータの更新
    await LocalData.saveLocalData<bool>(_stringToSaveLoginData(signInType), true);
    switch (signInType) {
      case SignInType.rumutaiStaff:
        await LocalData.saveLocalData<String>("rumutaiStaffPassword", password);
        break;
      case SignInType.admin:
        await LocalData.saveLocalData<String>("adminPassword", password);
        break;
    }
    //プロバイダーの更新
    await setSignInDataFromLocal(ref);
  }

  static Future signOut(WidgetRef ref) async {
    //ローカルデータの更新
    await LocalData.saveLocalData<bool>(_stringToSaveLoginData(SignInType.rumutaiStaff), false);
    await LocalData.saveLocalData<bool>(_stringToSaveLoginData(SignInType.admin), false);
    await LocalData.saveLocalData<String>("rumutaiStaffPassword", "");
    await LocalData.saveLocalData<String>("adminPassword", "");
    //プロバイダーの更新
    await setSignInDataFromLocal(ref);
  }

  static Future<void> setSignInDataFromLocal(WidgetRef ref) async {
    ref.read(isLoggedInRumutaiStaffProvider.notifier).state = await LocalData.readLocalData<bool>(_stringToSaveLoginData(SignInType.rumutaiStaff)) ?? false;
    ref.read(isLoggedInAdminProvider.notifier).state = await LocalData.readLocalData<bool>(_stringToSaveLoginData(SignInType.admin)) ?? false;
  }
}
