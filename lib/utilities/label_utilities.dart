import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumutai_app/providers/game_data_provider.dart';

import '../providers/init_data_provider.dart';

class LabelUtilities {
  static String gameDataCategoryToSportLabel(WidgetRef ref, GameDataCategory gameDataCategory) {
    final String id = gameDataCategory.asString;
    final SportsType sportsType = ref.watch(sportsTypeMapProvider)[id] ?? SportsType.futsal;
    return sportsType.asShortJapanse();
  }

  static List<String> refereeLabelList(SportsType sportsType) {
    switch (sportsType) {
      case SportsType.futsal:
        return ["主審", "線審", "線審"];
      case SportsType.basketball:
        return ["主審", "副審", "副審", "オフィシャル"];
      case SportsType.volleyball:
        return ["主審", "線審", "線審"];
      case SportsType.dodgeball:
        return ["主審", "副審", "副審"];
      case SportsType.dodgebee:
        return ["主審", "副審", "副審"];
    }
  }

  static List<String> scoreDetailLabelList(SportsType sportsType) {
    switch (sportsType) {
      case SportsType.futsal:
        return ["前半", "後半"];
      case SportsType.basketball:
        return ["ピリオド１", "ピリオド２", "ピリオド３"];
      case SportsType.volleyball:
        return ["セット１", "セット２", "セット３"];
      case SportsType.dodgeball:
        return ["前半", "後半"];
      case SportsType.dodgebee:
        return ["前半", "後半"];
    }
  }

  static String extraTimeLabel(SportsType sportsType) {
    if (sportsType == SportsType.futsal) {
      return "PK：";
    }
    return "延長：";
  }
}
