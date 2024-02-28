import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllNumberNotificationNotifier extends StateNotifier<Map> {
  AllNumberNotificationNotifier() : super({});

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

final unreadNotificationNumberProvider = StateProvider<int>((ref) => 0);
final a = StateNotifierProvider<AllNumberNotificationNotifier, Map>((ref) => AllNumberNotificationNotifier());

final gameDataForResultProvider = StateNotifierProvider<AllNumberNotificationNotifier, Map>((ref) => AllNumberNotificationNotifier());
