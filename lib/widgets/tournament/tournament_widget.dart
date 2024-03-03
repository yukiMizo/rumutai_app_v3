import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tournament_block.dart';

import '../../providers/init_data_provider.dart';

class TournamentWidget extends ConsumerWidget {
  final String _title;
  final Map _tournamentData;
  const TournamentWidget({super.key, required Map<dynamic, dynamic> tournamentData, required String title})
      : _title = title,
        _tournamentData = tournamentData;

//not flexible
  Map _teamMap(Map tournamentData, TournamentType tournamentType) {
    final Map mapToReturn = {};
    switch (tournamentType) {
      case TournamentType.four:
        tournamentData.forEach((gameId, gameData) {
          if (gameId.substring(4) == "01") {
            mapToReturn["0"] = gameData["team"]["0"];
            mapToReturn["1"] = gameData["team"]["1"];
          } else if (gameId.substring(4) == "02") {
            mapToReturn["2"] = gameData["team"]["0"];
            mapToReturn["3"] = gameData["team"]["1"];
          }
        });
        return mapToReturn;
      case TournamentType.four2:
        tournamentData.forEach((gameId, gameData) {
          if (gameId.substring(4) == "01") {
            mapToReturn["0"] = gameData["team"]["0"];
            mapToReturn["1"] = gameData["team"]["1"];
          } else if (gameId.substring(4) == "02") {
            mapToReturn["2"] = gameData["team"]["0"];
            mapToReturn["3"] = gameData["team"]["1"];
          }
        });
        return mapToReturn;
      case TournamentType.five:
        tournamentData.forEach((gameId, gameData) {
          if (gameId.substring(4) == "03") {
            mapToReturn["4"] = gameData["team"]["1"];
          } else if (gameId.substring(4) == "01") {
            mapToReturn["0"] = gameData["team"]["0"];
            mapToReturn["1"] = gameData["team"]["1"];
          } else if (gameId.substring(4) == "02") {
            mapToReturn["2"] = gameData["team"]["0"];
            mapToReturn["3"] = gameData["team"]["1"];
          }
        });
        return mapToReturn;
      case TournamentType.six:
        tournamentData.forEach((gameId, gameData) {
          if (gameId.substring(4) == "02") {
            mapToReturn["0"] = gameData["team"]["0"];
          } else if (gameId.substring(4) == "03") {
            mapToReturn["5"] = gameData["team"]["1"];
          } else if (gameId.substring(4) == "04") {
            mapToReturn["1"] = gameData["team"]["0"];
            mapToReturn["2"] = gameData["team"]["1"];
          } else if (gameId.substring(4) == "05") {
            mapToReturn["3"] = gameData["team"]["0"];
            mapToReturn["4"] = gameData["team"]["1"];
          }
        });
        return mapToReturn;
      case TournamentType.seven:
        tournamentData.forEach((gameId, gameData) {
          if (gameId.substring(4) == "03") {
            mapToReturn["6"] = gameData["team"]["1"];
          } else if (gameId.substring(4) == "04") {
            mapToReturn["0"] = gameData["team"]["0"];
            mapToReturn["1"] = gameData["team"]["1"];
          } else if (gameId.substring(4) == "05") {
            mapToReturn["2"] = gameData["team"]["0"];
            mapToReturn["3"] = gameData["team"]["1"];
          } else if (gameId.substring(4) == "06") {
            mapToReturn["4"] = gameData["team"]["0"];
            mapToReturn["5"] = gameData["team"]["1"];
          }
        });
        return mapToReturn;
    }
  }

  Map _tournamentDataMap(Map tournamentData) {
    final Map mapToReturn = {};
    tournamentData.forEach((gameId, gameData) {
      mapToReturn[gameId.substring(4)] = gameData;
    });
    return mapToReturn;
  }

  Widget _teamCard(String text) {
    return SizedBox(
      width: 55,
      height: 35,
      child: Card(
        elevation: 1,
        color: Colors.brown.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          child: FittedBox(
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tournamentTypeFour(Map tournamentDataMap, Map teamMap) {
    return Column(
      children: [
        const Text(
          "優勝",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                const SizedBox(height: 160),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _teamCard(teamMap["0"]),
                    const SizedBox(width: 40),
                    _teamCard(teamMap["1"]),
                    const SizedBox(width: 30),
                    _teamCard(teamMap["2"]),
                    const SizedBox(width: 40),
                    _teamCard(teamMap["3"]),
                  ],
                )
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TournamentBlock.normal(
                      armHeight: 55,
                      handHeight: 50,
                      width: 100,
                      spaceHeight: 40,
                      otherHeight: 50,
                      gameData: tournamentDataMap["01"],
                      buttonHeight: 50,
                    ),
                    const SizedBox(width: 80),
                    TournamentBlock.normal(
                      armHeight: 55,
                      handHeight: 50,
                      width: 100,
                      spaceHeight: 40,
                      otherHeight: 50,
                      gameData: tournamentDataMap["02"],
                      buttonHeight: 50,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                TournamentBlock.cover(
                  height: 50,
                  width: 180,
                  gameData: tournamentDataMap["04"],
                  buttonHeight: 50,
                ),
                const SizedBox(height: 92),
                TournamentBlock.cover(
                  height: 50,
                  width: 180,
                  isDown: true,
                  gameData: tournamentDataMap["03"],
                  buttonHeight: 50,
                ),
              ],
            ),
          ],
        ),
        const Text(
          "３位",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ],
    );
  }

  Widget _tournamentTypeFour2(Map tournamentDataMap, Map teamMap) {
    return Column(
      children: [
        const Text(
          "5位",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                const SizedBox(height: 160),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _teamCard(teamMap["0"]),
                    const SizedBox(width: 40),
                    _teamCard(teamMap["1"]),
                    const SizedBox(width: 30),
                    _teamCard(teamMap["2"]),
                    const SizedBox(width: 40),
                    _teamCard(teamMap["3"]),
                  ],
                )
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TournamentBlock.normal(
                      armHeight: 55,
                      handHeight: 50,
                      width: 100,
                      spaceHeight: 40,
                      otherHeight: 50,
                      gameData: tournamentDataMap["01"],
                      buttonHeight: 40,
                    ),
                    const SizedBox(width: 80),
                    TournamentBlock.normal(
                      armHeight: 55,
                      handHeight: 50,
                      width: 100,
                      spaceHeight: 40,
                      otherHeight: 50,
                      gameData: tournamentDataMap["02"],
                      buttonHeight: 40,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                TournamentBlock.cover(
                  height: 50,
                  width: 180,
                  gameData: tournamentDataMap["04"],
                  buttonHeight: 40,
                ),
                const SizedBox(height: 112),
                TournamentBlock.cover(
                  height: 50,
                  width: 180,
                  isDown: true,
                  gameData: tournamentDataMap["03"],
                  buttonHeight: 40,
                ),
              ],
            ),
          ],
        ),
        const Text(
          "７位",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ],
    );
  }

  Widget _tournamentTypeFive(Map tournamentDataMap, Map teamMap) {
    return Column(
      children: [
        const Row(
          children: [
            Text(
              "５位",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 18),
          ],
        ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                const SizedBox(height: 200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _teamCard(teamMap["0"]),
                    const SizedBox(width: 15),
                    _teamCard(teamMap["1"]),
                    const SizedBox(width: 25),
                    _teamCard(teamMap["2"]),
                    const SizedBox(width: 25),
                    _teamCard(teamMap["3"]),
                    const SizedBox(width: 20),
                    _teamCard(teamMap["4"]),
                  ],
                )
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TournamentBlock.normal(
                      armHeight: 100,
                      handHeight: 45,
                      width: 100,
                      spaceHeight: 40,
                      gameData: tournamentDataMap["01"],
                      buttonHeight: 40,
                    ),
                    const SizedBox(width: 60),
                    Column(
                      children: [
                        const SizedBox(height: 50),
                        TournamentBlock.normal(
                          armHeight: 50,
                          handHeight: 45,
                          width: 100,
                          spaceHeight: 40,
                          gameData: tournamentDataMap["02"],
                          buttonHeight: 40,
                        ),
                      ],
                    ),
                    const SizedBox(width: 80),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    const SizedBox(width: 200),
                    TournamentBlock.seed(
                      armHeight: 50,
                      fingerHeight: 95,
                      width: 120,
                      seedBlockSide: SeedBlockSide.right,
                      gameData: tournamentDataMap["03"],
                      buttonHeight: 40,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    TournamentBlock.cover(
                      height: 50,
                      width: 220,
                      gameData: tournamentDataMap["04"],
                      buttonHeight: 40,
                    ),
                    const SizedBox(width: 20),
                  ],
                ), /*
                const SizedBox(height: 153),
                Row(
                  children: [
                    TournamentBlock.cover(
                      height: 50,
                      width: 163,
                      isDown: true,
                      gameData: tournamentDataMap["04"],
                      buttonHeight: 40,
                    ),
                    const SizedBox(width: 80),
                  ],
                ),*/
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _tournamentTypeSix(Map tournamentDataMap, Map teamMap) {
    return Column(
      children: [
        const Text(
          "５位",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                const SizedBox(height: 200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _teamCard(teamMap["0"]),
                    const SizedBox(width: 8),
                    _teamCard(teamMap["1"]),
                    _teamCard(teamMap["2"]),
                    const SizedBox(width: 8),
                    _teamCard(teamMap["3"]),
                    _teamCard(teamMap["4"]),
                    const SizedBox(width: 8),
                    _teamCard(teamMap["5"]),
                  ],
                )
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TournamentBlock.normal(
                      armHeight: 50,
                      handHeight: 45,
                      width: 100,
                      gameData: tournamentDataMap["03"],
                      buttonHeight: 40,
                    ),
                    const SizedBox(width: 20),
                    TournamentBlock.normal(
                      armHeight: 50,
                      handHeight: 45,
                      width: 100,
                      gameData: tournamentDataMap["04"],
                      buttonHeight: 40,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    TournamentBlock.seed(
                      armHeight: 50,
                      fingerHeight: 95,
                      width: 100,
                      seedBlockSide: SeedBlockSide.left,
                      gameData: tournamentDataMap["01"],
                      buttonHeight: 40,
                    ),
                    const SizedBox(width: 120),
                    TournamentBlock.seed(
                      armHeight: 50,
                      fingerHeight: 95,
                      width: 100,
                      seedBlockSide: SeedBlockSide.right,
                      gameData: tournamentDataMap["02"],
                      buttonHeight: 40,
                    ),
                  ],
                ),
              ],
            ),
            TournamentBlock.cover(
              height: 50,
              width: 220,
              gameData: tournamentDataMap["00"],
              buttonHeight: 40,
            ),
          ],
        ),
      ],
    );
  }

  Widget _tournamentTypeSeven(Map tournamentDataMap, Map teamMap) {
    return Column(
      children: [
        const Row(
          children: [
            SizedBox(width: 40),
            Text(
              "５位",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                const SizedBox(height: 200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _teamCard(teamMap["0"]),
                    _teamCard(teamMap["1"]),
                    const SizedBox(width: 2),
                    _teamCard(teamMap["2"]),
                    _teamCard(teamMap["3"]),
                    const SizedBox(width: 2),
                    _teamCard(teamMap["4"]),
                    _teamCard(teamMap["5"]),
                    const SizedBox(width: 2),
                    _teamCard(teamMap["6"]),
                  ],
                )
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TournamentBlock.normal(
                      armHeight: 50,
                      handHeight: 45,
                      width: 80,
                      gameData: tournamentDataMap["03"],
                      buttonHeight: 40,
                    ),
                    const SizedBox(width: 30),
                    TournamentBlock.normal(
                      armHeight: 50,
                      handHeight: 45,
                      width: 80,
                      gameData: tournamentDataMap["04"],
                      buttonHeight: 40,
                    ),
                    const SizedBox(width: 30),
                    TournamentBlock.normal(
                      armHeight: 50,
                      handHeight: 45,
                      width: 80,
                      gameData: tournamentDataMap["05"],
                      buttonHeight: 40,
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 30),
                    TournamentBlock.cover(
                      height: 50,
                      width: 110,
                      gameData: tournamentDataMap["01"],
                      buttonHeight: 40,
                    ),
                    const SizedBox(width: 110),
                    TournamentBlock.seed(
                      armHeight: 50,
                      fingerHeight: 95,
                      width: 90,
                      seedBlockSide: SeedBlockSide.right,
                      gameData: tournamentDataMap["02"],
                      buttonHeight: 40,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 40),
                TournamentBlock.cover(
                  height: 50,
                  width: 210,
                  gameData: tournamentDataMap["00"],
                  buttonHeight: 40,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    final String id = _tournamentData.values.first["gameId"].substring(0, 4);
    final TournamentType tournamentType = ref.watch(tournamentTypeMapProvider)[id] ?? TournamentType.four;

    final Map tournamentDataMap = _tournamentDataMap(_tournamentData);
    final Map teamMap = _teamMap(_tournamentData, tournamentType);

    late Widget tournament;
    switch (tournamentType) {
      case TournamentType.four:
        tournament = _tournamentTypeFour(tournamentDataMap, teamMap);
        break;
      case TournamentType.four2:
        tournament = _tournamentTypeFour2(tournamentDataMap, teamMap);
        break;
      case TournamentType.five:
        tournament = _tournamentTypeFive(tournamentDataMap, teamMap);
        break;
      case TournamentType.six:
        tournament = _tournamentTypeSix(tournamentDataMap, teamMap);
        break;
      case TournamentType.seven:
        tournament = _tournamentTypeSeven(tournamentDataMap, teamMap);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              _title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          SizedBox(width: screenWidth, child: FittedBox(child: tournament)),
        ],
      ),
    );
  }
}
