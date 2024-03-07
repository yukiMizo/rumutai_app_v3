//game data 全体の更新用のファイルです。
//基本的に次のルム対に向けて新しくgame data を設定する時のみ使用します。

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumutai_app/providers/game_data_provider.dart';

import 'providers/init_data_provider.dart';

class SetGameData {
  //学期を設定（重要！！！！）
  static const semester = Semester.kouki;

  //sport を設定
  static const Map<String, SportsType> sportsTypeMap = {
    "1d": SportsType.futsal,
    "1j": SportsType.basketball,
    "1k": SportsType.volleyball,
    "2d": SportsType.basketball,
    "2j": SportsType.dodgeball,
    "2k": SportsType.volleyball
  };

  //gameIdを設定
  static const List<String> gameIdList1d = [
    //a
    "1d-a01",
    "1d-a02",
    "1d-a03",
    "1d-a04",
    "1d-a05",
    "1d-a06",
    //b
    "1d-b01",
    "1d-b02",
    "1d-b03",
    "1d-b04",
    "1d-b05",
    "1d-b06",
    "1d-b07",
    "1d-b08",
    "1d-b09",
    "1d-b10",
    //f
    "1d-f01",
    "1d-f02",
    "1d-f03",
    "1d-f04",
    //l
    "1d-l01",
    "1d-l02",
    "1d-l03",
    "1d-l04",
    "1d-l05",
  ];
  static const List<String> gameIdList1j = [
    //a
    "1j-a01",
    "1j-a02",
    "1j-a03",
    "1j-a04",
    "1j-a05",
    "1j-a06",
    "1j-a07",
    "1j-a08",
    "1j-a09",
    "1j-a10",
    //b
    "1j-b01",
    "1j-b02",
    "1j-b03",
    "1j-b04",
    "1j-b05",
    "1j-b06",
    "1j-b07",
    "1j-b08",
    "1j-b09",
    "1j-b10",
    "1j-b11",
    "1j-b12",
    "1j-b13",
    "1j-b14",
    "1j-b15",
    //f
    "1j-f01",
    "1j-f02",
    "1j-f03",
    "1j-f04",
    //l
    "1j-l01",
    "1j-l02",
    "1j-l03",
    "1j-l04",
    "1j-l05",
    "1j-l06",
  ];
  static const List<String> gameIdList1k = [
    //a
    "1k-a01",
    "1k-a02",
    "1k-a03",
    "1k-a04",
    "1k-a05",
    "1k-a06",
    "1k-a07",
    "1k-a08",
    "1k-a09",
    "1k-a10",
    //b
    "1k-b01",
    "1k-b02",
    "1k-b03",
    "1k-b04",
    "1k-b05",
    "1k-b06",
    "1k-b07",
    "1k-b08",
    "1k-b09",
    "1k-b10",
    //f
    "1k-f01",
    "1k-f02",
    "1k-f03",
    "1k-f04",
    //l
    "1k-l01",
    "1k-l02",
    "1k-l03",
    "1k-l04",
    "1k-l05",
  ];
  static const List<String> gameIdList2d = [
    //a
    "2d-a01",
    "2d-a02",
    "2d-a03",
    "2d-a04",
    "2d-a05",
    "2d-a06",
    //b
    "2d-b01",
    "2d-b02",
    "2d-b03",
    "2d-b04",
    "2d-b05",
    "2d-b06",
    "2d-b07",
    "2d-b08",
    "2d-b09",
    "2d-b10",
    //f
    "2d-f01",
    "2d-f02",
    "2d-f03",
    "2d-f04",
    //l
    "2d-l01",
    "2d-l02",
    "2d-l03",
    "2d-l04",
    "2d-l05",
  ];
  static const List<String> gameIdList2j = [
    //a
    "2j-a01",
    "2j-a02",
    "2j-a03",
    "2j-a04",
    "2j-a05",
    "2j-a06",
    "2j-a07",
    "2j-a08",
    "2j-a09",
    "2j-a10",
    //b
    "2j-b01",
    "2j-b02",
    "2j-b03",
    "2j-b04",
    "2j-b05",
    "2j-b06",
    "2j-b07",
    "2j-b08",
    "2j-b09",
    "2j-b10",
    "2j-b11",
    "2j-b12",
    "2j-b13",
    "2j-b14",
    "2j-b15",
    //f
    "2j-f01",
    "2j-f02",
    "2j-f03",
    "2j-f04",
    //l
    "2j-l01",
    "2j-l02",
    "2j-l03",
    "2j-l04",
    "2j-l05",
    "2j-l06",
  ];
  static const List<String> gameIdList2k = [
    //a
    "2k-a01",
    "2k-a02",
    "2k-a03",
    "2k-a04",
    "2k-a05",
    "2k-a06",
    "2k-a07",
    "2k-a08",
    "2k-a09",
    "2k-a10",
    //b
    "2k-b01",
    "2k-b02",
    "2k-b03",
    "2k-b04",
    "2k-b05",
    "2k-b06",
    "2k-b07",
    "2k-b08",
    "2k-b09",
    "2k-b10",
    //f
    "2k-f01",
    "2k-f02",
    "2k-f03",
    "2k-f04",
    //l
    "2k-l01",
    "2k-l02",
    "2k-l03",
    "2k-l04",
    "2k-l05",
  ];

  //classを設定
  static const List<String> class1da = ["101", "102", "105", "108"];
  static const List<String> class1db = ["103", "104", "106", "107", "109"];
  static const List<String> class1ja = ["101", "102", "105", "108", "110a"];
  static const List<String> class1jb = ["103", "104", "106", "107", "109", "110b"];
  static const List<String> class1ka = ["101", "102", "105", "108", "110"];
  static const List<String> class1kb = ["103", "104", "106", "107", "109"];
  static const List<String> class2da = ["201", "202", "204", "207"];
  static const List<String> class2db = ["203", "205", "206", "208", "209"];
  static const List<String> class2ja = ["201", "202", "204", "207", "210a"];
  static const List<String> class2jb = ["203", "205", "206", "208", "209", "210b"];
  static const List<String> class2ka = ["201", "202", "204", "207", "210"];
  static const List<String> class2kb = ["203", "205", "206", "208", "209"];

  //トーナメントを設定
  static const Map<String, TournamentType> tournamentTypeMap = {
    "1d-f": TournamentType.four,
    "1d-l": TournamentType.five2,
    "1j-f": TournamentType.four,
    "1j-l": TournamentType.seven,
    "1k-f": TournamentType.four,
    "1k-l": TournamentType.six,
    "2d-f": TournamentType.four,
    "2d-l": TournamentType.five2,
    "2j-f": TournamentType.four,
    "2j-l": TournamentType.seven,
    "2k-f": TournamentType.four,
    "2k-l": TournamentType.six,
  };

  //確認をして、更新をする
  static const updateOk = false;

  static const List<String> allGameIdList = [
    ...gameIdList1d,
    ...gameIdList1j,
    ...gameIdList1k,
    ...gameIdList2d,
    ...gameIdList2j,
    ...gameIdList2k,
  ];

  static Future<void> setData() async {
    //dataForInit関連
    final Map<String, String> sportsMapToSet = {};
    sportsTypeMap.forEach((id, sportsType) {
      sportsMapToSet[id] = sportsType.name;
    });
    final Map<String, String> tournamentMapToSet = {};
    tournamentTypeMap.forEach((id, tournamentType) {
      tournamentMapToSet[id] = tournamentType.name;
    });
    if (updateOk) {
      await FirebaseFirestore.instance.collection("dataForInit").doc("dataForInitDoc").set(
        {
          "sports": sportsMapToSet,
          "tournament": tournamentMapToSet,
        },
        SetOptions(merge: true),
      );
    }

    //gameData関連
    final String collection = semester == Semester.zenki ? "gameDataZenki" : "gameDataKouki";
    final String collectionToDelete1 = semester == Semester.zenki ? "gameDataToReadZenki" : "gameDataToReadKouki";
    final String collectionToDelete2 = semester == Semester.zenki ? "classGameDataToReadZenki" : "classGameDataToReadKouki";

    if (updateOk) {
      //今あるcollectionを消去
      _deleteColection(collection);
      _deleteColection(collectionToDelete1);
      _deleteColection(collectionToDelete2);

      for (String gameId in allGameIdList) {
        final List<String> classList = _getClassList(gameId);
        final String sport = sportsTypeMap[gameId.substring(0, 2)]!.name;

        await FirebaseFirestore.instance.collection(collection).doc(gameId).set({
          "team": {"0": classList[0], "1": classList[1]},
          "score": [0, 0],
          "referee": ["審判A", "審判B", "審判C", ""],
          "place": "鯱光館",
          "sport": sport,
          "gameId": gameId,
          "gameStatus": GameStatus.before.name,
          "startTime": {"date": "1", "hour": "12", "minute": "00"},
          "extraTime": "",
          "scoreDetail": {
            "0": [0, 0],
            "1": [0, 0],
            "2": [0, 0],
          }
        });
      }
    }
  }

  static int _getIdWhereSameBlock(String gameId) {
    final l = allGameIdList.where((String id) => id.contains(gameId.substring(0, 4))).toList();
    return l.length;
  }

  static Future<void> _deleteColection(String oldCollection) async {
    final collection = FirebaseFirestore.instance.collection(oldCollection);
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return collection.get().then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        batch.delete(document.reference);
      }

      return batch.commit();
    });
  }

  static List<String> _getClassListOfBlock(String gameId) {
    final String block = gameId.substring(0, 4);
    if (block == "1d-a") {
      return class1da;
    } else if (block == "1d-b") {
      return class1db;
    } else if (block == "1j-a") {
      return class1ja;
    } else if (block == "1j-b") {
      return class1jb;
    } else if (block == "1k-a") {
      return class1ka;
    } else if (block == "1k-b") {
      return class1kb;
    } else if (block == "2d-a") {
      return class2da;
    } else if (block == "2d-b") {
      return class2db;
    } else if (block == "2j-a") {
      return class2ja;
    } else if (block == "2j-b") {
      return class2jb;
    } else if (block == "2k-a") {
      return class2ka;
    } else if (block == "2k-b") {
      return class2kb;
    }
    return [];
  }

  static List<String> _getClassList(String gameId) {
    //トーナメントの場合
    if (gameId[3] == "f") {
      if (gameId.substring(4) == "01") {
        return ["A1", "B2"];
      } else if (gameId.substring(4) == "02") {
        return ["B1", "A2"];
      } else if (gameId.substring(4) == "03") {
        return ["f1", "f2"];
      } else {
        return ["F1", "F2"];
      }
    } else if (gameId[3] == "l") {
      final TournamentType tournamentType = tournamentTypeMap[gameId.substring(0, 4)]!;
      switch (tournamentType) {
        case TournamentType.four:
          return ["", ""];
        case TournamentType.four2:
          if (gameId.substring(4) == "01") {
            return ["A3", "B4"];
          } else if (gameId.substring(4) == "02") {
            return ["B3", "A4"];
          } else if (gameId.substring(4) == "03") {
            return ["l1", "l2"];
          } else {
            return ["L1", "L2"];
          }
        case TournamentType.five:
          if (gameId.substring(4) == "01") {
            return ["B5", "A3"];
          } else if (gameId.substring(4) == "02") {
            return ["B4", "A4"];
          } else if (gameId.substring(4) == "03") {
            return ["L2", "B3"];
          } else {
            return ["L1", "L3"];
          }
        case TournamentType.five2:
          if (gameId.substring(4) == "01") {
            return ["B5", "A3"];
          } else if (gameId.substring(4) == "02") {
            return ["B4", "A4"];
          } else if (gameId.substring(4) == "03") {
            return ["l1", "l2"];
          } else if (gameId.substring(4) == "04") {
            return ["L2", "B3"];
          } else {
            return ["L1", "L4"];
          }
        case TournamentType.six:
          if (gameId.substring(4) == "01") {
            return ["B5", "A4"];
          } else if (gameId.substring(4) == "02") {
            return ["B4", "A5"];
          } else if (gameId.substring(4) == "03") {
            return ["A3", "L1"];
          } else if (gameId.substring(4) == "04") {
            return ["L2", "B3"];
          } else {
            return ["L3", "L4"];
          }
        case TournamentType.seven:
          if (gameId.substring(4) == "01") {
            return ["B6", "A3"];
          } else if (gameId.substring(4) == "02") {
            return ["B5", "A4"];
          } else if (gameId.substring(4) == "03") {
            return ["B4", "A5"];
          } else if (gameId.substring(4) == "04") {
            return ["L1", "L2"];
          } else if (gameId.substring(4) == "05") {
            return ["L3", "B3"];
          } else {
            return ["L4", "L5"];
          }
      }
    }

    //リーグの場合
    final List<String> classListOfBlock = _getClassListOfBlock(gameId);
    String class1 = "";
    String class2 = "";
    final int gameNumber = int.parse(gameId.substring(4));
    if (_getIdWhereSameBlock(gameId) == 6) {
      if (gameNumber <= 3) {
        class1 = classListOfBlock[0];
      } else if (gameNumber <= 5) {
        class1 = classListOfBlock[1];
      } else {
        class1 = classListOfBlock[2];
      }

      if (gameNumber == 1) {
        class2 = classListOfBlock[1];
      } else if (gameNumber == 2 || gameNumber == 4) {
        class2 = classListOfBlock[2];
      } else {
        class2 = classListOfBlock[3];
      }
    } else if (_getIdWhereSameBlock(gameId) == 10) {
      if (gameNumber <= 4) {
        class1 = classListOfBlock[0];
      } else if (gameNumber <= 7) {
        class1 = classListOfBlock[1];
      } else if (gameNumber <= 9) {
        class1 = classListOfBlock[2];
      } else {
        class1 = classListOfBlock[3];
      }

      if (gameNumber == 1) {
        class2 = classListOfBlock[1];
      } else if (gameNumber == 2 || gameNumber == 5) {
        class2 = classListOfBlock[2];
      } else if (gameNumber == 3 || gameNumber == 6 || gameNumber == 8) {
        class2 = classListOfBlock[3];
      } else {
        class2 = classListOfBlock[4];
      }
    } else if (_getIdWhereSameBlock(gameId) == 15) {
      if (gameNumber <= 5) {
        class1 = classListOfBlock[0];
      } else if (gameNumber <= 9) {
        class1 = classListOfBlock[1];
      } else if (gameNumber <= 12) {
        class1 = classListOfBlock[2];
      } else if (gameNumber <= 14) {
        class1 = classListOfBlock[3];
      } else {
        class1 = classListOfBlock[4];
      }

      if (gameNumber == 1) {
        class2 = classListOfBlock[1];
      } else if (gameNumber == 2 || gameNumber == 6) {
        class2 = classListOfBlock[2];
      } else if (gameNumber == 3 || gameNumber == 7 || gameNumber == 10) {
        class2 = classListOfBlock[3];
      } else if (gameNumber == 4 || gameNumber == 8 || gameNumber == 11 || gameNumber == 13) {
        class2 = classListOfBlock[4];
      } else {
        class2 = classListOfBlock[5];
      }
    }
    return [class1, class2];
  }
}
