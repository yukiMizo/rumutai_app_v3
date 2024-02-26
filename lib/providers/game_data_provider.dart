import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//gameId:試合後のに割り振られた、試合を特定するためのID 例：1d-a01　→ 一年男子、Aブロック1番の試合

enum GameDataCategory { d1, j1, k1, d2, j2, k2, d3, j3, k3 } //d:男子, j:女子, k:混合, 数字:学年

enum GameDataBlock { a, b, f, l } //a,b:リーグのブロック ,f,l:トーナメントのブロック（fが決勝）

enum GameDataNumber {
  n00,
  n01,
  n02,
  n03,
  n04,
  n05,
  n06,
  n07,
  n08,
  n09,
  n10,
  n11,
  n12,
  n13,
  n14,
  n15,
} //nに特に意味はない

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

//画面遷移時のデータのgameDataのやり取り用（detailScreenで試合または編集ボタンを押した時用）
class GameDataToPassStaffOrAdmin {
  final Map thisGameData;
  final bool isReverse;

  GameDataToPassStaffOrAdmin({
    required this.thisGameData,
    this.isReverse = false,
  });
}

class GameDataForResultNotifier extends StateNotifier<Map> {
  GameDataForResultNotifier() : super({});

  //一つのゲームデータ更新
  void updateOneGameData({
    required String gameId,
    required String key,
    required Map data,
    bool setMerge = false,
  }) {
    Map tmpState = state;

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
    Map tmpState = state;

    tmpState[category] = newData;

    state = tmpState;
  }

  void updateAllData(Map newGameData) {
    state = newGameData;
  }
}

class GameDataForScheduleNotifier extends StateNotifier<Map> {
  GameDataForScheduleNotifier() : super({});

  //一つのゲームデータ更新
  void updateOneGameData({
    required String gameId,
    required String key,
    required Map data,
    required Map teams,
    bool setMerge = false,
  }) {
    Map tmpState = state;

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
    Map tmpState = state;

    tmpState[classNumber] = newData;

    state = tmpState;
  }

  //データ全て更新
  void updateAllData(Map newGameData) {
    state = newGameData;
  }
}

final gameDataForResultProvider = StateNotifierProvider<GameDataForResultNotifier, Map>((ref) => GameDataForResultNotifier());
final gameDataForScheduleProvider = StateNotifierProvider<GameDataForScheduleNotifier, Map>((ref) => GameDataForScheduleNotifier());

class GameDataManager {
  final firebase = FirebaseFirestore.instance;

  /* List l = [
    //1b
    "1b-a00",
    "1b-a01",
    "1b-a02",
    "1b-a03",
    "1b-a04",
    "1b-a05",

    "1b-b00",
    "1b-b01",
    "1b-b02",
    "1b-b03",
    "1b-b04",
    "1b-b05",
    "1b-b06",
    "1b-b07",
    "1b-b08",
    "1b-b09",

    "1b-f00",
    "1b-f01",
    "1b-f02",
    "1b-f03",

    "1b-l00",
    "1b-l01",
    "1b-l02",
    "1b-l03",
    "1b-l04",

    //1g
    "1g-a00",
    "1g-a01",
    "1g-a02",
    "1g-a03",
    "1g-a04",
    "1g-a05",
    "1g-a06",
    "1g-a07",
    "1g-a08",
    "1g-a09",

    "1g-b00",
    "1g-b01",
    "1g-b02",
    "1g-b03",
    "1g-b04",
    "1g-b05",
    "1g-b06",
    "1g-b07",
    "1g-b08",
    "1g-b09",
    "1g-b10",
    "1g-b11",
    "1g-b12",
    "1g-b13",
    "1g-b14",

    "1g-f00",
    "1g-f01",
    "1g-f02",
    "1g-f03",

    "1g-l00",
    "1g-l01",
    "1g-l02",
    "1g-l03",
    "1g-l04",
    "1g-l05",

    //1m
    "1m-a00",
    "1m-a01",
    "1m-a02",
    "1m-a03",
    "1m-a04",
    "1m-a05",
    "1m-a06",
    "1m-a07",
    "1m-a08",
    "1m-a09",

    "1m-b00",
    "1m-b01",
    "1m-b02",
    "1m-b03",
    "1m-b04",
    "1m-b05",
    "1m-b06",
    "1m-b07",
    "1m-b08",
    "1m-b09",

    "1m-f00",
    "1m-f01",
    "1m-f02",
    "1m-f03",

    "1m-l00",
    "1m-l01",
    "1m-l02",
    "1m-l03",
    "1m-l04",

    //2b
    "2b-a00",
    "2b-a01",
    "2b-a02",
    "2b-a03",
    "2b-a04",
    "2b-a05",

    "2b-b00",
    "2b-b01",
    "2b-b02",
    "2b-b03",
    "2b-b04",
    "2b-b05",

    "2b-f00",
    "2b-f01",
    "2b-f02",
    "2b-f03",

    "2b-l00",
    "2b-l01",
    "2b-l02",
    "2b-l03",

    //2g
    "2g-a00",
    "2g-a01",
    "2g-a02",
    "2g-a03",
    "2g-a04",
    "2g-a05",
    "2g-a06",
    "2g-a07",
    "2g-a08",
    "2g-a09",

    "2g-b00",
    "2g-b01",
    "2g-b02",
    "2g-b03",
    "2g-b04",
    "2g-b05",
    "2g-b06",
    "2g-b07",
    "2g-b08",
    "2g-b09",

    "2g-f00",
    "2g-f01",
    "2g-f02",
    "2g-f03",

    "2g-l00",
    "2g-l01",
    "2g-l02",
    "2g-l03",
    "2g-l04",

    //2m
    "2m-a00",
    "2m-a01",
    "2m-a02",
    "2m-a03",
    "2m-a04",
    "2m-a05",
    "2m-a06",
    "2m-a07",
    "2m-a08",
    "2m-a09",

    "2m-b00",
    "2m-b01",
    "2m-b02",
    "2m-b03",
    "2m-b04",
    "2m-b05",

    "2m-f00",
    "2m-f01",
    "2m-f02",
    "2m-f03",

    "2m-l00",
    "2m-l01",
    "2m-l02",
    "2m-l03",
    "2m-l04",
  ];*/
/*
  bool _leagueIsFilled(String gameId) {
    if (gameId[3] != "a" || gameId != "b") {
      return false;
    }
    bool leagueIsFilled = true;
    List<Map> leaguesToCheck = [
      _gameData[gameId.substring(0, 2)]["a"],
      _gameData[gameId.substring(0, 2)]["b"],
    ];
    for (var league in leaguesToCheck) {
      league.forEach((gameId, gameData) {
        if (gameData["gameStatus"] != "after") {
          leagueIsFilled = false;
        }
      });
    }
    return leagueIsFilled;
  }*/

  static Future updateData({
    required String gameId,
    required Map<String, Object> newData,
    required Map teams,
    bool setMerge = false,
    required WidgetRef ref,
  }) async {
    //firestore上のデータ更新
    try {
      if (!setMerge) {
        await FirebaseFirestore.instance.collection('gameData2').doc(gameId).update(newData);
      } else {
        await FirebaseFirestore.instance.collection('gameData2').doc(gameId).set(newData, SetOptions(merge: true));
      }
    } catch (e) {
      return;
    }

    //デバイス上のデータ更新
    newData.forEach((key, data) {
      ref.read(gameDataForResultProvider.notifier).updateOneGameData(gameId: gameId, key: key, data: data as Map);
      ref.read(gameDataForScheduleProvider.notifier).updateOneGameData(gameId: gameId, key: key, data: data, teams: teams);
    });
  }

  static Future<Map> getGameDataByCategory({required WidgetRef ref, required GameDataCategory category}) async {
    String categoryString = "";
    switch (category) {
      case GameDataCategory.d1:
        categoryString = "1d";
        break;
      case GameDataCategory.j1:
        categoryString = "1j";
        break;
      case GameDataCategory.k1:
        categoryString = "1k";
        break;
      case GameDataCategory.d2:
        categoryString = "2d";
        break;
      case GameDataCategory.j2:
        categoryString = "2j";
        break;
      case GameDataCategory.k2:
        categoryString = "2k";
        break;
      case GameDataCategory.d3:
        categoryString = "3d";
        break;
      case GameDataCategory.j3:
        categoryString = "3j";
        break;
      case GameDataCategory.k3:
        categoryString = "3k";
        break;
    }
    if (ref.read(gameDataForResultProvider)[categoryString] == null) {
      print("loaded1");
      await _loadGameDataForResult(gameDataCategory: category, ref: ref);
    }
    return ref.read(gameDataForResultProvider)[categoryString];
  }

  static Future<Map> getGameDataByClassNumber({required WidgetRef ref, required classNumber}) async {
    if (ref.read(gameDataForScheduleProvider)[classNumber] == null) {
      print("loaded2");
      await _loadGameDataForSchedule(classNumber: classNumber, ref: ref);
    }
    return ref.read(gameDataForScheduleProvider)[classNumber];
  }

  static Future _loadGameDataForResult({required GameDataCategory gameDataCategory, required WidgetRef ref}) async {
    late String gradeCategory;
    switch (gameDataCategory) {
      case GameDataCategory.d1:
        gradeCategory = "1d";
        break;
      case GameDataCategory.j1:
        gradeCategory = "1j";
        break;
      case GameDataCategory.k1:
        gradeCategory = "1k";
        break;
      case GameDataCategory.d2:
        gradeCategory = "2d";
        break;
      case GameDataCategory.j2:
        gradeCategory = "2j";
        break;
      case GameDataCategory.k2:
        gradeCategory = "2k";
        break;
      case GameDataCategory.d3:
        gradeCategory = "3d";
        break;
      case GameDataCategory.j3:
        gradeCategory = "3j";
        break;
      case GameDataCategory.k3:
        gradeCategory = "3k";
        break;
    }

    await FirebaseFirestore.instance.collection("gameDataToRead").doc(gradeCategory).get().then(
      (DocumentSnapshot doc) {
        ref.read(gameDataForResultProvider.notifier).setData(category: gradeCategory, newData: doc.data() as Map);
      },
    );
  }

  static Future _loadGameDataForSchedule({required String classNumber, required WidgetRef ref}) async {
    await FirebaseFirestore.instance.collection("classGameDataToRead").doc(classNumber).get().then(
      (DocumentSnapshot doc) {
        ref.read(gameDataForScheduleProvider.notifier).setData(classNumber: classNumber, newData: doc.data() as Map);
      },
    );
  }

  /*Future loadGameData2({required String collection}) async {
    //final data = await firebase.collection(collection).get();

    l.forEach((gameid) async {
      await firebase.collection(collection).doc(gameid).set({
        "team": {"0": "101", "1": "102"},
        "score": [0, 0],
        "referee": ["審判A", "審判B", "審判C", ""],
        "place": "鯱光館",
        "gameId": gameid as String,
        "gameStatus": "before",
        "startTime": {"date": "1", "hour": "13", "minute": "00"},
        "extraTime": "",
        "rumutaiStaff": "スタッフ",
        "scoreDetail": {
          "0": [0, 0],
          "1": [0, 0],
          "2": [0, 0],
        }
      });
    });
/*
    for (var gameData in data.docs) {
      _gameData[gameData.id] = {
        "team": gameData["team"] ?? ["No Data", "No Data"],
        "score": gameData["score"] ?? ["No Data", "No Data"],
        "referee": gameData["referee"] ?? ["No Data"],
        "place": gameData["place"] ?? "No Data",
        "startTime":
            gameData["startTime"] ?? {"date": "", "hour": "", "minute": ""},
      };
    }*/
  }*/
}
