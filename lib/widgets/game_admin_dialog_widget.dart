import 'package:flutter/material.dart';
import 'package:rumutai_app/providers/init_data_provider.dart';

import '../utilities/label_utilities.dart';

class GameAdminDialogWidget extends StatelessWidget {
  final Map _thisGameData;
  final bool _isReverse;
  final List<String> _dartyList;
  final SportsType _thisGameSportType;
  const GameAdminDialogWidget({
    super.key,
    required Map<dynamic, dynamic> gameData,
    required SportsType sportType,
    List<String> dartyList = const [],
    bool isReverse = false,
  })  : _dartyList = dartyList,
        _isReverse = isReverse,
        _thisGameData = gameData,
        _thisGameSportType = sportType;

  String get _gameStatus {
    late String gameStatus;
    if (_thisGameData["gameStatus"] == "before") {
      gameStatus = "試合前";
    } else if (_thisGameData["gameStatus"] == "now") {
      gameStatus = "試合中";
    } else if (_thisGameData["gameStatus"] == "after") {
      gameStatus = "試合終了";
    }
    return gameStatus;
  }

  String get _extraTime {
    if (_thisGameData["extraTime"] == "") {
      return "なし";
    } else {
      return "${_thisGameData["extraTime"]} 勝利";
    }
  }

//index 0〜2
  Widget _widgetForScoreDetailWidgetList({required int index, required bool isReverse}) {
    final int firstIndexForDirtyList = index * 2 + 1;
    final int secondIndexForDirtyList = firstIndexForDirtyList + 1;
    return Row(
      children: [
        Text(
          _thisGameData["scoreDetail"][index.toString()][isReverse ? 1 : 0].toString(),
          style: _dartyList.contains("scoreDetail${isReverse ? secondIndexForDirtyList : firstIndexForDirtyList}") ? const TextStyle(color: Colors.red) : null,
        ),
        const SizedBox(width: 10),
        const Text("-"),
        const SizedBox(width: 10),
        Text(
          _thisGameData["scoreDetail"][index.toString()][isReverse ? 0 : 1].toString(),
          style: _dartyList.contains("scoreDetail${isReverse ? firstIndexForDirtyList : secondIndexForDirtyList}") ? const TextStyle(color: Colors.red) : null,
        ),
      ],
    );
  }

  List<Widget> get _scoreDetailWidgetList {
    List<Widget> scoreDetailList = [];
    int index = 0;
    for (var label in LabelUtilities.scoreDetailLabelList(_thisGameSportType)) {
      // index = 0〜2
      if (index >= 3) {
        break;
      }
      scoreDetailList.add(
        Row(
          children: [
            _text("$label："),
            _widgetForScoreDetailWidgetList(index: index, isReverse: _isReverse),
          ],
        ),
      );
      index++;
    }
    return scoreDetailList;
  }

  Widget _text(text) {
    return SizedBox(
      width: 100,
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _text("チーム："),
                    Text(
                      _thisGameData["team"][_isReverse ? "1" : "0"],
                      style: _dartyList.contains("team${_isReverse ? 2 : 1}") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const Text(" vs "),
                    Text(
                      _thisGameData["team"][_isReverse ? "0" : "1"],
                      style: _dartyList.contains("team${_isReverse ? 1 : 2}") ? const TextStyle(color: Colors.red) : null,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _text("開始時間："),
                    Text(
                      "${_thisGameData["startTime"]["date"]}日目　",
                      style: _dartyList.contains("timeDate") ? const TextStyle(color: Colors.red) : null,
                    ),
                    Text(
                      _thisGameData["startTime"]["hour"],
                      style: _dartyList.contains("timeHour") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const Text(":"),
                    Text(
                      _thisGameData["startTime"]["minute"],
                      style: _dartyList.contains("timeMinute") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const Text("〜"),
                  ],
                ),
                Row(
                  children: [
                    _text("場所："),
                    Text(
                      _thisGameData["place"],
                      style: _dartyList.contains("place") ? const TextStyle(color: Colors.red) : null,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _text("審判："),
                    Text(
                      _thisGameData["referee"][0],
                      style: _dartyList.contains("referee1") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const Text("、"),
                    Text(
                      _thisGameData["referee"][1],
                      style: _dartyList.contains("referee2") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const Text("、"),
                    Text(
                      _thisGameData["referee"][2],
                      style: _dartyList.contains("referee3") ? const TextStyle(color: Colors.red) : null,
                    ),
                    if ((_thisGameData["referee"].length >= 4 && _thisGameData["referee"][3] != "")) const Text("、"),
                    if ((_thisGameData["referee"].length >= 4 && _thisGameData["referee"][3] != ""))
                      Text(
                        _thisGameData["referee"][3],
                        style: _dartyList.contains("referee4") ? const TextStyle(color: Colors.red) : null,
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _text("試合状況："),
                    Text(
                      _gameStatus,
                      style: _dartyList.contains("gameStatus") ? const TextStyle(color: Colors.red) : null,
                    ),
                  ],
                ),
                Row(children: [
                  _text(LabelUtilities.extraTimeLabel(_thisGameSportType)),
                  Text(
                    _extraTime,
                    style: _dartyList.contains("extraTime") ? const TextStyle(color: Colors.red) : null,
                  ),
                ]),
                Row(
                  children: [
                    _text("点数："),
                    Text(
                      _thisGameData["score"][_isReverse ? 1 : 0].toString(),
                      style: _dartyList.contains("score${_isReverse ? 2 : 1}") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const SizedBox(width: 10),
                    const Text("-"),
                    const SizedBox(width: 10),
                    Text(
                      _thisGameData["score"][_isReverse ? 0 : 1].toString(),
                      style: _dartyList.contains("score${_isReverse ? 1 : 2}") ? const TextStyle(color: Colors.red) : null,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: _scoreDetailWidgetList,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
