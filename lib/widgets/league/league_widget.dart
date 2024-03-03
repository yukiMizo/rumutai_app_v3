import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rumutai_app/providers/init_data_provider.dart';

import 'league_block.dart';
import 'rank_widget.dart';

class LeagueWidget extends StatelessWidget {
  final String _title;
  final Map _leagueData;
  const LeagueWidget({super.key, required String title, required Map<dynamic, dynamic> leagueData})
      : _leagueData = leagueData,
        _title = title;

  LeagueBlock _convertToOpposite(LeagueBlock leagueBlock) {
    LeagueBlock block = leagueBlock;
    if (leagueBlock.block == Block.win) {
      block = LeagueBlock(
        block: Block.lose,
        gameData: leagueBlock.gameData,
        blockSize: leagueBlock.blockSize,
        isReverse: true,
      );
    } else if (leagueBlock.block == Block.lose) {
      block = LeagueBlock(
        block: Block.win,
        gameData: leagueBlock.gameData,
        blockSize: leagueBlock.blockSize,
        isReverse: true,
      );
    } else if (leagueBlock.block == Block.tie) {
      block = LeagueBlock(
        block: Block.tie,
        gameData: leagueBlock.gameData,
        blockSize: leagueBlock.blockSize,
        isReverse: true,
      );
    } else {
      block = LeagueBlock(
        block: Block.text,
        text: leagueBlock.text,
        textColor: leagueBlock.textColor,
        gameData: leagueBlock.gameData,
        blockSize: leagueBlock.blockSize,
        isReverse: true,
      );
    }
    return block;
  }

  List<LeagueBlock> _leagueBlocks(Map leagueData, blockSize) {
    Map<String, LeagueBlock> leagueBlocksDataMap = {};

    void setTextLeagueBlock({
      required String coordinate,
      required String text,
    }) {
      leagueBlocksDataMap[coordinate] = LeagueBlock(
        block: Block.text,
        text: text,
        blockSize: blockSize,
      );
    }

    void setLeagueTeams({
      required String gameIdNumber,
      required Map teams,
    }) {
      if (gameIdNumber == "01") {
        setTextLeagueBlock(coordinate: "10", text: teams["0"]!);
        setTextLeagueBlock(coordinate: "20", text: teams["1"]!);
      } else {
        setTextLeagueBlock(coordinate: "${int.parse(gameIdNumber) + 1}0", text: teams["1"]!);
      }
    }

    //Block.noneの設置
    //最初だけdoShade = true
    leagueBlocksDataMap["00"] = LeagueBlock(
      block: Block.none,
      blockSize: blockSize,
      doShade: true,
    );
    if (leagueData.length == 6) {
      for (int i = 1; i < 5; i++) {
        leagueBlocksDataMap["$i$i"] = LeagueBlock(
          block: Block.none,
          blockSize: blockSize,
        );
      }
    } else if (leagueData.length == 10) {
      for (int i = 1; i < 6; i++) {
        leagueBlocksDataMap["$i$i"] = LeagueBlock(
          block: Block.none,
          blockSize: blockSize,
        );
      }
    } else if (leagueData.length == 15) {
      for (int i = 1; i < 7; i++) {
        leagueBlocksDataMap["$i$i"] = LeagueBlock(
          block: Block.none,
          blockSize: blockSize,
        );
      }
    }

    //座標のマップを設定
    late Map coordinateMap;
    if (leagueData.length == 6) {
      coordinateMap = {
        "01": "21",
        "02": "31",
        "03": "41",
        "04": "32",
        "05": "42",
        "06": "43",
      };
    } else if (leagueData.length == 10) {
      coordinateMap = {
        "01": "21",
        "02": "31",
        "03": "41",
        "04": "51",
        "05": "32",
        "06": "42",
        "07": "52",
        "08": "43",
        "09": "53",
        "10": "54",
      };
    } else if (leagueData.length == 15) {
      coordinateMap = {
        "01": "21",
        "02": "31",
        "03": "41",
        "04": "51",
        "05": "61",
        "06": "32",
        "07": "42",
        "08": "52",
        "09": "62",
        "10": "43",
        "11": "53",
        "12": "63",
        "13": "54",
        "14": "64",
        "15": "65",
      };
    }

    String? textOfBlock;
    Block block = Block.text;
    String coordinate = "";
    bool doSetLeagueTeam = false;
    String gameIdNumber = "";
    Color? textColorOfBlock;

    leagueData.forEach((gameId, gameData) {
      textOfBlock = null;
      textColorOfBlock = null;
      block = Block.text;
      gameIdNumber = gameId.substring(4);

      //リーグのチームを設定
      if (leagueData.length == 6) {
        doSetLeagueTeam = (gameIdNumber == "01" || gameIdNumber == "02" || gameIdNumber == "03");
      } else if (leagueData.length == 10) {
        doSetLeagueTeam = (gameIdNumber == "01" || gameIdNumber == "02" || gameIdNumber == "03" || gameIdNumber == "04");
      } else if (leagueData.length == 15) {
        doSetLeagueTeam = (gameIdNumber == "01" || gameIdNumber == "02" || gameIdNumber == "03" || gameIdNumber == "04" || gameIdNumber == "05");
      }
      if (doSetLeagueTeam) {
        setLeagueTeams(gameIdNumber: gameIdNumber, teams: gameData["team"]);
      }

      //試合状況ごとにテキスト設定
      if (gameData["gameStatus"] == "before") {
        textOfBlock = "${gameData["startTime"]["date"]}日目\n${gameData["startTime"]["hour"]}:${gameData["startTime"]["minute"]}〜";
      } else if (gameData["gameStatus"] == "now") {
        textOfBlock = "試合中";
        textColorOfBlock = Colors.deepPurpleAccent.shade700;
      } else if (gameData["gameStatus"] == "after") {
        if (gameData["score"][0] > gameData["score"][1]) {
          block = Block.win;
        } else if (gameData["score"][0] < gameData["score"][1]) {
          block = Block.lose;
        } else {
          block = Block.tie;
        }
      }

      coordinate = coordinateMap[gameIdNumber];

      leagueBlocksDataMap[coordinate] = LeagueBlock(
        block: block,
        text: textOfBlock,
        gameData: gameData,
        textColor: textColorOfBlock,
        blockSize: blockSize,
      );
    });
    //leagueBlocksDataToReturn の設定
    List<LeagueBlock> leagueBlocksDataToReturn = [];
    if (leagueData.length == 6) {
      leagueBlocksDataToReturn = [
        leagueBlocksDataMap["00"] as LeagueBlock,
        leagueBlocksDataMap["10"] as LeagueBlock,
        leagueBlocksDataMap["20"] as LeagueBlock,
        leagueBlocksDataMap["30"] as LeagueBlock,
        leagueBlocksDataMap["40"] as LeagueBlock,
        leagueBlocksDataMap["10"] as LeagueBlock,
        leagueBlocksDataMap["11"] as LeagueBlock,
        leagueBlocksDataMap["21"] as LeagueBlock,
        leagueBlocksDataMap["31"] as LeagueBlock,
        leagueBlocksDataMap["41"] as LeagueBlock,
        leagueBlocksDataMap["20"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["21"] as LeagueBlock),
        leagueBlocksDataMap["22"] as LeagueBlock,
        leagueBlocksDataMap["32"] as LeagueBlock,
        leagueBlocksDataMap["42"] as LeagueBlock,
        leagueBlocksDataMap["30"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["31"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["32"] as LeagueBlock),
        leagueBlocksDataMap["33"] as LeagueBlock,
        leagueBlocksDataMap["43"] as LeagueBlock,
        leagueBlocksDataMap["40"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["41"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["42"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["43"] as LeagueBlock),
        leagueBlocksDataMap["44"] as LeagueBlock,
      ];
    } else if (leagueData.length == 10) {
      leagueBlocksDataToReturn = [
        leagueBlocksDataMap["00"] as LeagueBlock,
        leagueBlocksDataMap["10"] as LeagueBlock,
        leagueBlocksDataMap["20"] as LeagueBlock,
        leagueBlocksDataMap["30"] as LeagueBlock,
        leagueBlocksDataMap["40"] as LeagueBlock,
        leagueBlocksDataMap["50"] as LeagueBlock,
        leagueBlocksDataMap["10"] as LeagueBlock,
        leagueBlocksDataMap["11"] as LeagueBlock,
        leagueBlocksDataMap["21"] as LeagueBlock,
        leagueBlocksDataMap["31"] as LeagueBlock,
        leagueBlocksDataMap["41"] as LeagueBlock,
        leagueBlocksDataMap["51"] as LeagueBlock,
        leagueBlocksDataMap["20"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["21"] as LeagueBlock),
        leagueBlocksDataMap["22"] as LeagueBlock,
        leagueBlocksDataMap["32"] as LeagueBlock,
        leagueBlocksDataMap["42"] as LeagueBlock,
        leagueBlocksDataMap["52"] as LeagueBlock,
        leagueBlocksDataMap["30"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["31"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["32"] as LeagueBlock),
        leagueBlocksDataMap["33"] as LeagueBlock,
        leagueBlocksDataMap["43"] as LeagueBlock,
        leagueBlocksDataMap["53"] as LeagueBlock,
        leagueBlocksDataMap["40"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["41"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["42"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["43"] as LeagueBlock),
        leagueBlocksDataMap["44"] as LeagueBlock,
        leagueBlocksDataMap["54"] as LeagueBlock,
        leagueBlocksDataMap["50"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["51"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["52"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["53"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["54"] as LeagueBlock),
        leagueBlocksDataMap["55"] as LeagueBlock,
      ];
    } else if (leagueData.length == 15) {
      leagueBlocksDataToReturn = [
        leagueBlocksDataMap["00"] as LeagueBlock,
        leagueBlocksDataMap["10"] as LeagueBlock,
        leagueBlocksDataMap["20"] as LeagueBlock,
        leagueBlocksDataMap["30"] as LeagueBlock,
        leagueBlocksDataMap["40"] as LeagueBlock,
        leagueBlocksDataMap["50"] as LeagueBlock,
        leagueBlocksDataMap["60"] as LeagueBlock,
        leagueBlocksDataMap["10"] as LeagueBlock,
        leagueBlocksDataMap["11"] as LeagueBlock,
        leagueBlocksDataMap["21"] as LeagueBlock,
        leagueBlocksDataMap["31"] as LeagueBlock,
        leagueBlocksDataMap["41"] as LeagueBlock,
        leagueBlocksDataMap["51"] as LeagueBlock,
        leagueBlocksDataMap["61"] as LeagueBlock,
        leagueBlocksDataMap["20"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["21"] as LeagueBlock),
        leagueBlocksDataMap["22"] as LeagueBlock,
        leagueBlocksDataMap["32"] as LeagueBlock,
        leagueBlocksDataMap["42"] as LeagueBlock,
        leagueBlocksDataMap["52"] as LeagueBlock,
        leagueBlocksDataMap["62"] as LeagueBlock,
        leagueBlocksDataMap["30"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["31"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["32"] as LeagueBlock),
        leagueBlocksDataMap["33"] as LeagueBlock,
        leagueBlocksDataMap["43"] as LeagueBlock,
        leagueBlocksDataMap["53"] as LeagueBlock,
        leagueBlocksDataMap["63"] as LeagueBlock,
        leagueBlocksDataMap["40"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["41"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["42"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["43"] as LeagueBlock),
        leagueBlocksDataMap["44"] as LeagueBlock,
        leagueBlocksDataMap["54"] as LeagueBlock,
        leagueBlocksDataMap["64"] as LeagueBlock,
        leagueBlocksDataMap["50"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["51"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["52"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["53"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["54"] as LeagueBlock),
        leagueBlocksDataMap["55"] as LeagueBlock,
        leagueBlocksDataMap["65"] as LeagueBlock,
        leagueBlocksDataMap["60"] as LeagueBlock,
        _convertToOpposite(leagueBlocksDataMap["61"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["62"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["63"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["64"] as LeagueBlock),
        _convertToOpposite(leagueBlocksDataMap["65"] as LeagueBlock),
        leagueBlocksDataMap["66"] as LeagueBlock,
      ];
    }

    return leagueBlocksDataToReturn;
  }

  List<String> _rankList(Map leagueData) {
    Map teamPointDifference = {};
    Map teamSetDifference = {};
    Map teamPointAll = {};
    List<String> rankList = [];

    //勝ち点の設定
    Map teamWinPoint = {};
    leagueData.forEach((gameId, gameData) {
      //試合終了以外は無視
      if (gameData["gameStatus"] != "after") {
        return;
      }

      //null check
      if (teamWinPoint[gameData["team"]["0"]] == null) {
        teamWinPoint[gameData["team"]["0"]] = 0;
      }
      if (teamWinPoint[gameData["team"]["1"]] == null) {
        teamWinPoint[gameData["team"]["1"]] = 0;
      }

      //勝ったチームを設定
      String? winTeam;
      if (gameData["score"][0] > gameData["score"][1]) {
        winTeam = "0";
      } else if (gameData["score"][0] < gameData["score"][1]) {
        winTeam = "1";
      }

      //勝ち　　　→　＋３
      //負け　　　→　＋０
      //引き分け　→　＋１
      if (winTeam == null) {
        teamWinPoint[gameData["team"]["0"]] += 1;
        teamWinPoint[gameData["team"]["1"]] += 1;
      } else {
        teamWinPoint[gameData["team"][winTeam]] += 3;
      }
    });

    //総得点、得失点差、得失セット数の設定
    leagueData.forEach((gameId, gameData) {
      //試合終了以外は無視
      if (gameData["gameStatus"] != "after") {
        return;
      }

      //null check
      if (teamPointDifference[gameData["team"]["0"]] == null) {
        teamPointDifference[gameData["team"]["0"]] = 0;
      }
      if (teamPointDifference[gameData["team"]["1"]] == null) {
        teamPointDifference[gameData["team"]["1"]] = 0;
      }
      //バレーの場合
      if (gameData["sport"] == SportsType.volleyball.name) {
        if (teamSetDifference[gameData["team"]["0"]] == null) {
          teamSetDifference[gameData["team"]["0"]] = 0;
        }
        if (teamSetDifference[gameData["team"]["1"]] == null) {
          teamSetDifference[gameData["team"]["1"]] = 0;
        }
      }
      if (teamPointAll[gameData["team"]["0"]] == null) {
        teamPointAll[gameData["team"]["0"]] = 0;
      }
      if (teamPointAll[gameData["team"]["1"]] == null) {
        teamPointAll[gameData["team"]["1"]] = 0;
      }

      final int team1score = (gameData["scoreDetail"]["0"][0] + gameData["scoreDetail"]["1"][0] + gameData["scoreDetail"]["2"][0]);
      final int team2score = (gameData["scoreDetail"]["0"][1] + gameData["scoreDetail"]["1"][1] + gameData["scoreDetail"]["2"][1]);

      //バレーの場合
      if (gameData["sport"] == SportsType.volleyball.name) {
        final int team1set = gameData["score"][0];
        final int team2set = gameData["score"][1];
        teamSetDifference[gameData["team"]["0"]] += (team1set - team2set);
        teamSetDifference[gameData["team"]["1"]] += (team2set - team1set);
      }

      //総得点と得失点差数を計算
      teamPointAll[gameData["team"]["0"]] += team1score;
      teamPointAll[gameData["team"]["1"]] += team2score;
      teamPointDifference[gameData["team"]["0"]] += (team1score - team2score);
      teamPointDifference[gameData["team"]["1"]] += (team2score - team1score);
    });

    //勝ち点、得失点差、総得点をもとに、マップとソート
    teamWinPoint = SplayTreeMap.of(teamWinPoint, (teamA, teamB) {
      int compare = teamWinPoint[teamB]!.compareTo(teamWinPoint[teamA]!);
      //a>b -1
      //a<b 1
      //a=b 0

      //勝ち点が同じ場合
      if (compare == 0) {
        //バレーの場合
        if (leagueData.values.first["sport"] == SportsType.volleyball.name) {
          if (teamSetDifference[teamA] > teamSetDifference[teamB]) {
            return -1;
          } else if (teamSetDifference[teamA] < teamSetDifference[teamB]) {
            return 1;
          } else {
            if (teamPointDifference[teamA] > teamPointDifference[teamB]) {
              return -1;
            } else if (teamPointDifference[teamA] < teamPointDifference[teamB]) {
              return 1;
            } else {
              return 1;
            }
          }
        } else {
          if (teamPointDifference[teamA] > teamPointDifference[teamB]) {
            return -1;
          } else if (teamPointDifference[teamA] < teamPointDifference[teamB]) {
            return 1;
          } else {
            if (teamPointAll[teamA] > teamPointAll[teamB]) {
              return -1;
            } else if (teamPointAll[teamA] < teamPointAll[teamB]) {
              return 1;
            } else {
              return 1;
            }
          }
        }
      }
      return compare;
    });

    teamWinPoint.forEach((team, point) {
      rankList.add(team);
    });
    return rankList;
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = MediaQuery.of(context).size.width * 7 / 10;
    final rankWidgetWidth = MediaQuery.of(context).size.width * 2.4 / 10;
    late int crossAxisCount;
    if (_leagueData.length == 6) {
      crossAxisCount = 5;
    } else if (_leagueData.length == 10) {
      crossAxisCount = 6;
    } else if (_leagueData.length == 15) {
      crossAxisCount = 7;
    }

    return Column(
      children: [
        Text(
          _title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: gridSize,
              height: gridSize,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                children: _leagueBlocks(_leagueData, gridSize / crossAxisCount),
              ),
            ),
            SizedBox(
              height: gridSize,
              width: rankWidgetWidth,
              child: RankWidget(_rankList(_leagueData)),
            ),
          ],
        ),
        SizedBox(
          width: 280,
          child: Text(
            "※タップで詳細を確認できます。",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ],
    );
  }
}
