class LableUtilities {
  static List<String> refereeLableList(String sport) {
    if (sport == "futsal" || sport == "volleyball") {
      return ["主審", "線審", "線審"];
    } else if (sport == "basketball") {
      return ["主審", "副審", "副審", "オフィシャル"];
    } else {
      return ["主審", "副審", "副審"];
    }
  }

  static List<String> scoreDetailLableList(String sport) {
    if (sport == "futsal" || sport == "dodgebee" || sport == "dodgeball") {
      return ["前半", "後半"];
    } else if (sport == "volleyball") {
      return ["セット１", "セット２", "セット３"];
    } else if (sport == "basketball") {
      return ["ピリオド１", "ピリオド２", "ピリオド３"];
    }
    return [];
  }

  static String extraTimeLable(String sport) {
    if (sport == "futsal") {
      return "PK：";
    }
    return "延長：";
  }
}
