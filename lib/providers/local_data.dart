import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class LocalData with ChangeNotifier {
  /*
  bool? isLoggedInAdmin;
  bool? isLoggedInRumutaiStaff;
  //bool? isLoggedInResultEditor;
  String? pickedPersonForMyGame;

  Future setDataFromLocal() async {
    isLoggedInAdmin = await readLocalData<bool>("isLoggedInAdmin");
    isLoggedInRumutaiStaff = await readLocalData<bool>("isLoggedInRumutaiStaff");
    pickedPersonForMyGame = await readLocalData<String>("pickedPersonForMyGame");
    notifyListeners();
  }


  static Future<List<String>> listOfStringThatPasswordDidChange() async {
    bool? adminIsLoggedIn = await readLocalData<bool>("isLoggedInAdmin");
    bool? rumutaiStaffIsLoggedIn = await readLocalData<bool>("isLoggedInRumutaiStaff");
    final List<String> listToReturn = [];
    if (adminIsLoggedIn == true || rumutaiStaffIsLoggedIn == true) {
      var passwordData = await FirebaseFirestore.instance.collection("password").doc("passwordDoc").get();

      if (adminIsLoggedIn == true) {
        final oldAdminPassword = await readLocalData<String>("adminPassword");
        if (passwordData["Admin"] != oldAdminPassword) {
          await saveLocalData<bool>("isLoggedInAdmin", false);
          listToReturn.add("管理者");
        }
      }
      if (rumutaiStaffIsLoggedIn == true) {
        final oldRumutaiStaffPassword = await readLocalData<String>("rumutaiStaffPassword");
        if (passwordData["RumutaiStaff"] != oldRumutaiStaffPassword) {
          await saveLocalData<bool>("isLoggedInRumutaiStaff", false);
          listToReturn.add("ルム対スタッフ");
        }
      }
    }
    return listToReturn;
  }
*/
  static Future saveLocalData<T>(String name, T value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (T) {
      case int:
        await prefs.setInt(name, value as int);
        break;
      case String:
        await prefs.setString(name, value as String);
        break;
      case bool:
        await prefs.setBool(name, value as bool);
        break;
      case List<String>:
        await prefs.setStringList(name, value as List<String>);
        break;
      default:
        break;
    }
  }

  static Future<dynamic> readLocalData<T>(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Object? result;
    switch (T) {
      case int:
        result = prefs.getInt(name);
        break;
      case String:
        result = prefs.getString(name);
        break;
      case bool:
        result = prefs.getBool(name);
        break;
      case List<String>:
        result = prefs.getStringList(name);
        break;
      default:
        break;
    }
    return result;
  }

  static void deleteLocalData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(name);
  }
}
