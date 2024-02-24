enum TournamentType { four, four2, five, six, seven }

class TournamentTypeUtilities {
  //not flexible
  static TournamentType tournamentType(String gameId) {
    if (gameId[3] == "f") {
      return TournamentType.four;
    } else if (gameId.contains("3d")) {
      return TournamentType.four2;
    } else if (gameId.contains("2d")) {
      return TournamentType.five;
    } else if (gameId.contains("1b") || gameId.contains("2m")) {
      return TournamentType.five;
    } else if (gameId.contains("1m") || gameId.contains("2g")) {
      return TournamentType.six;
    } else {
      return TournamentType.seven;
    }
  }
}
