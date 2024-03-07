import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'init_data_provider.dart';

//gameId:試合後のに割り振られた、試合を特定するためのID 例：1d-a01　→ 一年男子、Aブロック1番の試合

enum GameDataCategory {
  d1("1d"),
  j1("1j"),
  k1("1k"),
  d2("2d"),
  j2("2j"),
  k2("2k"),
  d3("3d"),
  j3("3j"),
  k3("3k");

  final String asString;
  const GameDataCategory(this.asString);
} //d:男子, j:女子, k:混合, 数字:学年

enum GameStatus { before, now, after }

//画面遷移時のデータのgameDataのやり取り用
class GameDataToPass {
  final String gameDataId;
  final String? classNumber;
  final bool isReverse;
  final bool? isMyGame;

  GameDataToPass({
    required this.gameDataId,
    this.classNumber,
    this.isMyGame = false,
    this.isReverse = false,
  });
}

//画面遷移時のデータのgameDataのやり取り用（detailScreenで編集ボタンを押した時用）
class GameDataToPassAdmin {
  final Map thisGameData;
  final bool isReverse;

  GameDataToPassAdmin({
    required this.thisGameData,
    this.isReverse = false,
  });
}

//
class GameDataForResultNotifier extends StateNotifier<Map> {
  GameDataForResultNotifier() : super({});

  //一つのゲームデータ更新
  void updateOneGameData({
    required String gameId,
    required String key,
    required data,
    bool setMerge = false,
  }) {
    Map tmpState = {...state};

    final String category = gameId.substring(0, 2);
    final String block = gameId[3];

    if (!setMerge) {
      if (tmpState[category] != null) {
        tmpState[category][block][gameId].update(key, (_) => data);
      }
    } else {
      data.forEach((k, d) {
        if (tmpState[category] != null) {
          tmpState[category][block][gameId]["team"].update(k, (_) => d);
        }
      });
    }

    state = tmpState;
  }

  //新しくデータを追加
  void setData({
    required String category,
    required Map newData,
  }) {
    Map tmpState = {...state};

    tmpState[category] = newData;

    state = tmpState;
  }

  void updateAllData(Map newGameData) {
    state = {...newGameData};
  }
}

class GameDataForScheduleNotifier extends StateNotifier<Map> {
  GameDataForScheduleNotifier() : super({});

  //一つのゲームデータ更新
  void updateOneGameData({
    required String gameId,
    required String key,
    required data,
    required Map teams,
    bool setMerge = false,
  }) {
    Map tmpState = {...state};

    final String gender = gameId[1];

    if (!setMerge) {
      if (tmpState[teams["0"]] != null) {
        tmpState[teams["0"]][gender][gameId].update(key, (_) => data);
      }
      if (tmpState[teams["1"]] != null) {
        tmpState[teams["1"]][gender][gameId].update(key, (_) => data);
      }
    } else {
      data.forEach((k, d) {
        if (tmpState[teams["0"]] != null) {
          tmpState[teams["0"]][gender][gameId]["team"].update(k, (_) => d);
        }
        if (tmpState[teams["1"]] != null) {
          tmpState[teams["1"]][gender][gameId]["team"].update(k, (_) => d);
        }
      });
    }

    state = tmpState;
  }

  //新しくデータを追加
  void setData({
    required String classNumber,
    required Map newData,
  }) {
    Map tmpState = {...state};

    tmpState[classNumber] = newData;

    state = tmpState;
  }

  //データ全て更新
  void updateAllData(Map newGameData) {
    state = {...newGameData};
  }
}

final gameDataForResultProvider = StateNotifierProvider<GameDataForResultNotifier, Map>((ref) => GameDataForResultNotifier());
final gameDataForScheduleProvider = StateNotifierProvider<GameDataForScheduleNotifier, Map>((ref) => GameDataForScheduleNotifier());

class GameDataManager {
  static final firebase = FirebaseFirestore.instance;

  static Future updateData({
    required String gameId,
    required Map<String, Object> newData,
    required Map teams,
    bool setMerge = false,
    required WidgetRef ref,
  }) async {
    final String collection = ref.read(semesterProvider) == Semester.zenki ? "gameDataZenki" : "gameDataKouki";
    //firestore上のデータ更新
    try {
      if (!setMerge) {
        await firebase.collection(collection).doc(gameId).update(newData);
      } else {
        await firebase.collection(collection).doc(gameId).set(newData, SetOptions(merge: true));
      }
    } catch (e) {
      return;
    }
    //デバイス上のデータ更新
    newData.forEach((key, data) {
      ref.read(gameDataForResultProvider.notifier).updateOneGameData(
            gameId: gameId,
            key: key,
            data: data,
            setMerge: setMerge,
          );
      ref.read(gameDataForScheduleProvider.notifier).updateOneGameData(
            gameId: gameId,
            key: key,
            data: data,
            teams: teams,
            setMerge: setMerge,
          );
    });
  }

  static Future<Map> getGameDataByCategory({
    required WidgetRef ref,
    required GameDataCategory category,
    bool load = false,
  }) async {
    String categoryString = category.asString;
    if (load || ref.read(gameDataForResultProvider)[categoryString] == null) {
      await _loadGameDataForResult(gameDataCategory: category, ref: ref);
    }
    return ref.read(gameDataForResultProvider)[categoryString];
  }

  static Future<Map> getGameDataByClassNumber({
    required WidgetRef ref,
    required classNumber,
    bool load = false,
  }) async {
    if (load || ref.read(gameDataForScheduleProvider)[classNumber] == null) {
      await _loadGameDataForSchedule(classNumber: classNumber, ref: ref);
    }
    return ref.read(gameDataForScheduleProvider)[classNumber];
  }

  static Future _loadGameDataForResult({required GameDataCategory gameDataCategory, required WidgetRef ref}) async {
    final String collection = ref.read(semesterProvider) == Semester.zenki ? "gameDataToReadZenki" : "gameDataToReadKouki";
    final String gradeCategory = gameDataCategory.asString;

    debugPrint("loadedGameDataCategory");
    await firebase.collection(collection).doc(gradeCategory).get().then(
      (DocumentSnapshot doc) {
        ref.read(gameDataForResultProvider.notifier).setData(category: gradeCategory, newData: doc.data() as Map);
      },
    );
  }

  static Future _loadGameDataForSchedule({required String classNumber, required WidgetRef ref}) async {
    final String collection = ref.read(semesterProvider) == Semester.zenki ? "classGameDataToReadZenki" : "classGameDataToReadKouki";

    debugPrint("loadedGameDataClass");
    await firebase.collection(collection).doc(classNumber).get().then(
      (DocumentSnapshot doc) {
        ref.read(gameDataForScheduleProvider.notifier).setData(classNumber: classNumber, newData: doc.data() as Map);
      },
    );
  }
}
