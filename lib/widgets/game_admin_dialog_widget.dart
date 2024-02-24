import 'package:flutter/material.dart';

import '../utilities/lable_utilities.dart';

class GameAdminDialogWidget extends StatelessWidget {
  final Map _gameData;
  final bool _isReverse;
  final List<String> _dartyList;
  const GameAdminDialogWidget({super.key, required Map<dynamic, dynamic> gameData, List<String> dartyList = const [], bool isReverse = false})
      : _dartyList = dartyList,
        _isReverse = isReverse,
        _gameData = gameData;

  String get _gameStatus {
    late String gameStatus;
    if (_gameData["gameStatus"] == "before") {
      gameStatus = "試合前";
    } else if (_gameData["gameStatus"] == "now") {
      gameStatus = "試合中";
    } else if (_gameData["gameStatus"] == "after") {
      gameStatus = "試合終了";
    }
    return gameStatus;
  }

  String get _extraTime {
    if (_gameData["extraTime"] == "") {
      return "なし";
    } else {
      return "${_gameData["extraTime"]} 勝利";
    }
  }

//index 0〜2
  Widget _widgetForScoreDetailWidgetList({required int index, required bool isReverse}) {
    final int firstIndexForDirtyList = index * 2 + 1;
    final int secondIndexForDirtyList = firstIndexForDirtyList + 1;
    return Row(
      children: [
        Text(
          _gameData["scoreDetail"][index.toString()][isReverse ? 1 : 0].toString(),
          style: _dartyList.contains("scoreDetail${isReverse ? secondIndexForDirtyList : firstIndexForDirtyList}") ? const TextStyle(color: Colors.red) : null,
        ),
        const SizedBox(width: 10),
        const Text("-"),
        const SizedBox(width: 10),
        Text(
          _gameData["scoreDetail"][index.toString()][isReverse ? 0 : 1].toString(),
          style: _dartyList.contains("scoreDetail${isReverse ? firstIndexForDirtyList : secondIndexForDirtyList}") ? const TextStyle(color: Colors.red) : null,
        ),
      ],
    );
  }

  List<Widget> get _scoreDetailWidgetList {
    List<Widget> scoreDetailList = [];
    int index = 0;
    for (var lable in LableUtilities.scoreDetailLableList(_gameData["gameId"])) {
      // index = 0〜2
      if (index >= 3) {
        break;
      }
      scoreDetailList.add(
        Row(
          children: [
            _text("$lable："),
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
      elevation: 3,
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
                      _gameData["team"][_isReverse ? "1" : "0"],
                      style: _dartyList.contains("team${_isReverse ? 2 : 1}") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const Text(" vs "),
                    Text(
                      _gameData["team"][_isReverse ? "0" : "1"],
                      style: _dartyList.contains("team${_isReverse ? 1 : 2}") ? const TextStyle(color: Colors.red) : null,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _text("開始時間："),
                    Text(
                      "${_gameData["startTime"]["date"]}日目　",
                      style: _dartyList.contains("timeDate") ? const TextStyle(color: Colors.red) : null,
                    ),
                    Text(
                      _gameData["startTime"]["hour"],
                      style: _dartyList.contains("timeHour") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const Text(":"),
                    Text(
                      _gameData["startTime"]["minute"],
                      style: _dartyList.contains("timeMinute") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const Text("〜"),
                  ],
                ),
                Row(
                  children: [
                    _text("場所："),
                    Text(
                      _gameData["place"],
                      style: _dartyList.contains("place") ? const TextStyle(color: Colors.red) : null,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _text("審判："),
                    Text(
                      _gameData["referee"][0],
                      style: _dartyList.contains("referee1") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const Text("、"),
                    Text(
                      _gameData["referee"][1],
                      style: _dartyList.contains("referee2") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const Text("、"),
                    Text(
                      _gameData["referee"][2],
                      style: _dartyList.contains("referee3") ? const TextStyle(color: Colors.red) : null,
                    ),
                    if ((_gameData["referee"].length >= 4 && _gameData["referee"][3] != "")) const Text("、"),
                    if ((_gameData["referee"].length >= 4 && _gameData["referee"][3] != ""))
                      Text(
                        _gameData["referee"][3],
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
                  _text(LableUtilities.extraTimeLable(_gameData["gameId"])),
                  Text(
                    _extraTime,
                    style: _dartyList.contains("extraTime") ? const TextStyle(color: Colors.red) : null,
                  ),
                ]),
                Row(
                  children: [
                    _text("点数："),
                    Text(
                      _gameData["score"][_isReverse ? 1 : 0].toString(),
                      style: _dartyList.contains("score${_isReverse ? 2 : 1}") ? const TextStyle(color: Colors.red) : null,
                    ),
                    const SizedBox(width: 10),
                    const Text("-"),
                    const SizedBox(width: 10),
                    Text(
                      _gameData["score"][_isReverse ? 0 : 1].toString(),
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
