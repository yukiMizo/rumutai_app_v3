import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:rumutai_app/themes/app_color.dart';
import 'package:rumutai_app/utilities/label_utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/init_data_provider.dart';

import '../providers/game_data_provider.dart';

class RumutaiStaffScreen extends ConsumerStatefulWidget {
  static const routeName = "/game-rumutai-staff-screen";

  const RumutaiStaffScreen({super.key});

  @override
  ConsumerState<RumutaiStaffScreen> createState() => _RumutaiStaffScreenState();
}

class _RumutaiStaffScreenState extends ConsumerState<RumutaiStaffScreen> {
  bool _isLoadingDialog = false;
  bool _isInit = true;
  bool _isReverse = false;
  late Map _thisGameData;
  late SportsType _thisGameSportType;
  late String _gameDataId;
  late bool _isTournament;
  late Map<String, dynamic> data;

  final TextEditingController _scoreDetail1Controller = TextEditingController();
  final TextEditingController _scoreDetail2Controller = TextEditingController();
  final TextEditingController _scoreDetail3Controller = TextEditingController();
  final TextEditingController _scoreDetail4Controller = TextEditingController();
  final TextEditingController _scoreDetail5Controller = TextEditingController();
  final TextEditingController _scoreDetail6Controller = TextEditingController();

  late String _selectedExtraTime;

  late DateTime dateTime;

  Widget _textField({required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 50,
        child: TextField(
          keyboardType: Platform.isAndroid ? TextInputType.number : const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            border: const UnderlineInputBorder(),
            fillColor: AppColors.themeColor.shade50,
            contentPadding: const EdgeInsets.only(left: 5),
            filled: true,
            isDense: true,
            isCollapsed: true,
          ),
          style: const TextStyle(fontSize: 30),
          onChanged: (text) {
            setState(() {});
          },
          controller: controller,
        ),
      ),
    );
  }

  List<String> get _scoreDetailLabelList {
    switch (_thisGameSportType) {
      case SportsType.futsal:
        return ["前半", "後半"];
      case SportsType.basketball:
        return ["ピリオド１", "ピリオド２", "ピリオド３"];
      case SportsType.volleyball:
        if ((_scoreList[0] == "1" && _scoreList[1] == "1") || (int.parse(_scoreList[0]) + int.parse(_scoreList[1]) == 3)) {
          return ["セット１", "セット２", "セット３"];
        }
        _scoreDetail5Controller.text = "0";
        _scoreDetail6Controller.text = "0";
        return ["セット１", "セット２"];
      case SportsType.dodgeball:
        return ["前半", "後半"];
      case SportsType.dodgebee:
        return ["前半", "後半"];
    }
  }

  Column _scoreInputWidget() {
    List<Widget> widgetList = [];
    int count = 1;
    for (var label in _scoreDetailLabelList) {
      widgetList.add(
        Stack(
          alignment: const Alignment(-1, 0),
          children: [
            _label("$label："),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 5),
                if (count == 1) _textField(controller: _isReverse ? _scoreDetail2Controller : _scoreDetail1Controller),
                if (count == 2) _textField(controller: _isReverse ? _scoreDetail4Controller : _scoreDetail3Controller),
                if (count == 3) _textField(controller: _isReverse ? _scoreDetail6Controller : _scoreDetail5Controller),
                const SizedBox(width: 15),
                const Text("-", style: TextStyle(fontSize: 30)),
                const SizedBox(width: 15),
                if (count == 1) _textField(controller: _isReverse ? _scoreDetail1Controller : _scoreDetail2Controller),
                if (count == 2) _textField(controller: _isReverse ? _scoreDetail3Controller : _scoreDetail4Controller),
                if (count == 3) _textField(controller: _isReverse ? _scoreDetail5Controller : _scoreDetail6Controller),
                const SizedBox(width: 5),
              ],
            ),
          ],
        ),
      );
      count++;
    }
    widgetList.add(const SizedBox(height: 30));
    List<String> scoreList = _scoreList;
    widgetList.add(
      Stack(
        alignment: const Alignment(-1, 0),
        children: [
          if (_thisGameSportType == SportsType.volleyball) _label("セット数：") else _label("点数："),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  scoreList[_isReverse ? 1 : 0],
                  style: const TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              const Text(
                "-",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  scoreList[_isReverse ? 0 : 1],
                  style: const TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return Column(
      children: widgetList,
    );
  }

  List<String> get _scoreList {
    List<String> scoreList = [];

    if (_thisGameSportType == SportsType.volleyball) {
      Map winCount = {"0": 0, "1": 0};
      if (_strToInt(_scoreDetail1Controller.text) > _strToInt(_scoreDetail2Controller.text)) {
        winCount["0"] += 1;
      } else if (_strToInt(_scoreDetail1Controller.text) < _strToInt(_scoreDetail2Controller.text)) {
        winCount["1"] += 1;
      }
      if (_strToInt(_scoreDetail3Controller.text) > _strToInt(_scoreDetail4Controller.text)) {
        winCount["0"] += 1;
      } else if (_strToInt(_scoreDetail3Controller.text) < _strToInt(_scoreDetail4Controller.text)) {
        winCount["1"] += 1;
      }
      if (_strToInt(_scoreDetail5Controller.text) > _strToInt(_scoreDetail6Controller.text)) {
        winCount["0"] += 1;
      } else if (_strToInt(_scoreDetail5Controller.text) < _strToInt(_scoreDetail6Controller.text)) {
        winCount["1"] += 1;
      }
      scoreList.add(winCount["0"].toString());
      scoreList.add(winCount["1"].toString());
    } else {
      scoreList.add((_strToInt(_scoreDetail1Controller.text) + _strToInt(_scoreDetail3Controller.text) + _strToInt(_scoreDetail5Controller.text)).toString());
      scoreList.add((_strToInt(_scoreDetail2Controller.text) + _strToInt(_scoreDetail4Controller.text) + _strToInt(_scoreDetail6Controller.text)).toString());
    }
    return scoreList;
  }

  int _strToInt(String str) {
    if (str == "") {
      return 0;
    }
    return int.parse(str);
  }

  Widget _gameStatus(GameStatus gameStatus) {
    switch (gameStatus) {
      case GameStatus.before:
        return const Text(
          "試合前",
          style: TextStyle(fontSize: 16),
        );
      case GameStatus.now:
        return Text(
          "試合中",
          style: TextStyle(
            color: Colors.deepPurpleAccent.shade700,
            fontSize: 16,
          ),
        );
      case GameStatus.after:
        return const Text(
          "試合終了",
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        );
    }
  }

  Widget _scoreDetailPartWidget({
    required Map scoreData,
    required String index,
    required String label,
  }) {
    return SizedBox(
      width: 300,
      child: Stack(
        alignment: const Alignment(-1, 0),
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label：",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                height: 1.0,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  scoreData["scoreDetail"][index][_isReverse ? 1 : 0].toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Text(
                " - ",
                style: TextStyle(
                  fontSize: 18,
                  height: 1.0,
                ),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  scoreData["scoreDetail"][index][_isReverse ? 0 : 1].toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreDetailWidget(Map scoreData) {
    List<String> scoreDetailLabelList = _scoreDetailLabelList;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  width: 45,
                  child: Text(
                    _thisGameData["team"][_isReverse ? "1" : "0"],
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 65,
              child: Text(
                scoreData["score"][_isReverse ? 1 : 0].toString(),
                style: const TextStyle(fontSize: 35),
                textAlign: TextAlign.center,
              ),
            ),
            const Text(
              "-",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              width: 65,
              child: Text(
                scoreData["score"][_isReverse ? 0 : 1].toString(),
                style: const TextStyle(fontSize: 35),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  width: 45,
                  child: Text(
                    _thisGameData["team"][_isReverse ? "0" : "1"],
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        _scoreDetailPartWidget(
          scoreData: scoreData,
          index: "0",
          label: scoreDetailLabelList[0],
        ),
        _scoreDetailPartWidget(
          scoreData: scoreData,
          index: "1",
          label: scoreDetailLabelList[1],
        ),
        if ((_thisGameSportType == SportsType.volleyball || _thisGameSportType == SportsType.basketball) && scoreDetailLabelList.length == 3)
          _scoreDetailPartWidget(
            scoreData: scoreData,
            index: "2",
            label: scoreDetailLabelList[2],
          ),
      ],
    );
  }

  Map<String, Map<String, String>> _dataToUpdateTournament({
    required Map gameData,
    required TournamentType tournamentType,
  }) {
    late String winTeam;
    late String loseTeam;
    if (gameData["score"][0] > gameData["score"][1]) {
      winTeam = gameData["team"]["0"];
      loseTeam = gameData["team"]["1"];
    } else if (gameData["score"][0] < gameData["score"][1]) {
      winTeam = gameData["team"]["1"];
      loseTeam = gameData["team"]["0"];
    } else if (gameData["team"]["0"] == _selectedExtraTime) {
      winTeam = gameData["team"]["0"];
      loseTeam = gameData["team"]["1"];
    } else if (gameData["team"]["1"] == _selectedExtraTime) {
      winTeam = gameData["team"]["1"];
      loseTeam = gameData["team"]["0"];
    }

    final Map<String, Map<String, String>> dataToReturn = {};
    switch (tournamentType) {
      case TournamentType.four:
        if (gameData["gameId"].substring(4) == "01") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}04"] = {"0": winTeam};
          dataToReturn["${gameData["gameId"].substring(0, 4)}03"] = {"0": loseTeam};
        } else if (gameData["gameId"].substring(4) == "02") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}04"] = {"1": winTeam};
          dataToReturn["${gameData["gameId"].substring(0, 4)}03"] = {"1": loseTeam};
        }
        break;
      case TournamentType.four2:
        if (gameData["gameId"].substring(4) == "01") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}04"] = {"0": winTeam};
          dataToReturn["${gameData["gameId"].substring(0, 4)}03"] = {"0": loseTeam};
        } else if (gameData["gameId"].substring(4) == "02") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}04"] = {"1": winTeam};
          dataToReturn["${gameData["gameId"].substring(0, 4)}03"] = {"1": loseTeam};
        }
        break;
      case TournamentType.five:
        if (gameData["gameId"].substring(4) == "01") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}04"] = {"0": winTeam};
        } else if (gameData["gameId"].substring(4) == "02") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}03"] = {"0": winTeam};
        } else if (gameData["gameId"].substring(4) == "03") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}04"] = {"1": winTeam};
        }
        break;
      case TournamentType.five2:
        if (gameData["gameId"].substring(4) == "01") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}05"] = {"0": winTeam};
          dataToReturn["${gameData["gameId"].substring(0, 4)}03"] = {"0": loseTeam};
        } else if (gameData["gameId"].substring(4) == "02") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}04"] = {"0": winTeam};
          dataToReturn["${gameData["gameId"].substring(0, 4)}03"] = {"1": loseTeam};
        } else if (gameData["gameId"].substring(4) == "04") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}05"] = {"1": winTeam};
        }
        break;
      case TournamentType.six:
        if (gameData["gameId"].substring(4) == "01") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}00"] = {"0": winTeam};
        } else if (gameData["gameId"].substring(4) == "02") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}00"] = {"1": winTeam};
        } else if (gameData["gameId"].substring(4) == "03") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}01"] = {"1": winTeam};
        } else if (gameData["gameId"].substring(4) == "04") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}02"] = {"0": winTeam};
        }
        break;
      case TournamentType.seven:
        if (gameData["gameId"].substring(4) == "01") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}00"] = {"0": winTeam};
        } else if (gameData["gameId"].substring(4) == "02") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}00"] = {"1": winTeam};
        } else if (gameData["gameId"].substring(4) == "03") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}01"] = {"0": winTeam};
        } else if (gameData["gameId"].substring(4) == "04") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}01"] = {"1": winTeam};
        } else if (gameData["gameId"].substring(4) == "05") {
          dataToReturn["${gameData["gameId"].substring(0, 4)}02"] = {"0": winTeam};
        }
        break;
    }

    return dataToReturn;
  }

  Widget _label(text) {
    return SizedBox(
      width: 110,
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.0,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _extraTimeInputWidget({required String team1, required String team2}) {
    return Row(
      children: [
        _label(LabelUtilities.extraTimeLabel(_thisGameSportType)),
        SizedBox(
          width: 150,
          child: DropdownButton(
            dropdownColor: Colors.white,
            style: const TextStyle(fontSize: 20, color: Colors.black),
            isExpanded: true,
            items: [
              DropdownMenuItem(
                value: team1,
                child: Text("$team1 勝利"),
              ),
              DropdownMenuItem(
                value: team2,
                child: Text("$team2 勝利"),
              ),
              const DropdownMenuItem(
                value: "",
                child: Text("なし"),
              ),
            ],
            onChanged: (String? value) {
              setState(() {
                _selectedExtraTime = value as String;
              });
            },
            value: _selectedExtraTime,
          ),
        )
      ],
    );
  }

  Widget _extraTimeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LabelUtilities.extraTimeLabel(_thisGameSportType),
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 18,
          ),
        ),
        Text(
          "$_selectedExtraTime 勝利",
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Future _updateTournament({
    required String gameId,
  }) async {
    final String id = gameId.substring(0, 4);
    final TournamentType tournamentType = ref.watch(tournamentTypeMapProvider)[id] ?? TournamentType.four;
    final Map<String, Map<String, String>> dataToUpdate = _dataToUpdateTournament(
      gameData: _thisGameData,
      tournamentType: tournamentType,
    );

    if (dataToUpdate == {}) {
      return;
    }

    dataToUpdate.forEach(
      (gameId, teamDataToUpdate) async {
        await GameDataManager.updateData(
            ref: ref,
            gameId: gameId,
            newData: {
              "team": teamDataToUpdate,
            },
            teams: _thisGameData["team"],
            setMerge: true);
      },
    );
  }

  bool _canFinishGame(bool isTournament) {
    //点数が入力されていない時false
    if (_scoreDetail1Controller.text == "" ||
        _scoreDetail2Controller.text == "" ||
        _scoreDetail3Controller.text == "" ||
        _scoreDetail4Controller.text == "" ||
        _scoreDetail5Controller.text == "" ||
        _scoreDetail6Controller.text == "") {
      return false;
    }
    //バレーの場合
    if (_thisGameSportType == SportsType.volleyball) {
      //フルセットでない時、勝敗がついていない場合false
      if (int.parse(_scoreList[0]) + int.parse(_scoreList[1]) < 2) {
        return false;
      }
      //フルセットの時、勝敗がついていない場合false
      if (_scoreList[0] == "1" && _scoreList[1] == "1") {
        return false;
      }
    }
    //トーナメントで点数が同じかつ延長の勝敗がついてない場合false
    if (isTournament && (_scoreList[0] == _scoreList[1]) && _selectedExtraTime == "") {
      return false;
    }
    return true;
  }

  Widget _buildTopSection() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_thisGameData["team"][_isReverse ? "1" : "0"], style: const TextStyle(fontSize: 40)),
          const Text(" vs ", style: TextStyle(fontSize: 30)),
          Text(_thisGameData["team"][_isReverse ? "0" : "1"], style: const TextStyle(fontSize: 40)),
        ],
      ),
      Text("${_thisGameData["startTime"]["date"]}日目　${_thisGameData["startTime"]["hour"]}:${_thisGameData["startTime"]["minute"]}〜　${_thisGameData["place"]}"),
    ]);
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      onPressed: () => showDialog(
          context: context,
          builder: (_) {
            final String currentGameStatus = _thisGameData["gameStatus"];
            return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                title: const Text("確認"),
                content: _isLoadingDialog
                    ? const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()))
                    : (currentGameStatus == "now" ? const Text("試合前に戻します。") : const Text("試合中に戻します。")),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  if (!_isLoadingDialog)
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("キャンセル"),
                      ),
                    ),
                  if (!_isLoadingDialog)
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: FilledButton(
                        child: const Text("戻す"),
                        onPressed: () async {
                          setState(() {
                            _isLoadingDialog = true;
                          });
                          await GameDataManager.updateData(
                            ref: ref,
                            gameId: _gameDataId,
                            newData: currentGameStatus == "now"
                                ? {"gameStatus": "before"}
                                : {
                                    "gameStatus": "now",
                                    "score": [0, 0],
                                    "scoreDetail": {
                                      "0": [0, 0],
                                      "1": [0, 0],
                                      "2": [0, 0],
                                    },
                                    "extraTime": ""
                                  },
                            teams: _thisGameData["team"],
                          );
                          setState(() {
                            _isLoadingDialog = false;
                          });
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(currentGameStatus == "after" ? '試合中に戻しました。' : "試合前に戻しました。"),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                ],
              ),
            );
          }),
      label: const Text("戻す", style: TextStyle(fontSize: 16)),
      style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black)),
      icon: const Icon(Icons.arrow_back),
    );
  }

  Widget _buildStartGameButton() {
    return ElevatedButton.icon(
      onPressed: () {
        dateTime = DateTime.now();
        showDialog(
            context: context,
            builder: (_) {
              return StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  insetPadding: const EdgeInsets.all(10),
                  title: const Text("確認"),
                  content: _isLoadingDialog
                      ? const SizedBox(
                          height: 180,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              const Text("試合を開始します。"),
                              Text("開始時刻 ${dateTime.hour.toString()}時${dateTime.minute.toString()}分"),
                              TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 15),
                                  ),
                                  child: const Text("開始時間変更"),
                                  onPressed: () async {
                                    Picker(
                                        adapter: DateTimePickerAdapter(type: PickerDateTimeType.kHM, value: dateTime, customColumnType: [3, 4]),
                                        title: const Text("時間選択"),
                                        onConfirm: (Picker picker, List value) {
                                          setState(() {
                                            dateTime = DateTime.utc(0, 0, 0, value[0], value[1], 0);
                                          });
                                        }).showModal(context);
                                  })
                            ],
                          ),
                        ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: <Widget>[
                    if (!_isLoadingDialog)
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("キャンセル"),
                        ),
                      ),
                    if (!_isLoadingDialog)
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: FilledButton(
                          child: const Text("開始"),
                          onPressed: () async {
                            setState(() {
                              _isLoadingDialog = true;
                            });

                            data = {"title": "${_thisGameData["place"]}) ${dateTime.hour.toString()}時${dateTime.minute.toString()}分 ${_gameDataId.toUpperCase()} 開始", "timeStamp": DateTime.now()};

                            await GameDataManager.updateData(
                              ref: ref,
                              gameId: _gameDataId,
                              newData: {"gameStatus": "now"},
                              teams: _thisGameData["team"],
                            );

                            await FirebaseFirestore.instance.collection('Timeline').add(data);

                            setState(() {
                              _isLoadingDialog = false;
                            });
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("試合を開始しました。")),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                  ],
                ),
              );
            });
      },
      label: const Text("試合開始"),
      icon: const Icon(Icons.sports),
    );
  }

  Widget _buildEndGameButton() {
    return ElevatedButton.icon(
      onPressed: !_canFinishGame(_isTournament)
          ? null
          : () {
              dateTime = DateTime.now();
              showDialog(
                  context: context,
                  builder: (_) {
                    return StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                        insetPadding: const EdgeInsets.all(10),
                        title: const Text("確認"),
                        content: _isLoadingDialog
                            ? const SizedBox(
                                height: 180,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : SizedBox(
                                height: 220,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      _scoreDetailWidget({
                                        "score": [
                                          _scoreList[0],
                                          _scoreList[1],
                                        ],
                                        "scoreDetail": {
                                          "0": [
                                            _scoreDetail1Controller.text,
                                            _scoreDetail2Controller.text,
                                          ],
                                          "1": [
                                            _scoreDetail3Controller.text,
                                            _scoreDetail4Controller.text,
                                          ],
                                          "2": [
                                            _scoreDetail5Controller.text,
                                            _scoreDetail6Controller.text,
                                          ],
                                        },
                                      }),
                                      const SizedBox(height: 10),
                                      if (_selectedExtraTime != "") _extraTimeWidget(),
                                      const Divider(),
                                      const SizedBox(height: 10),
                                      const Text("試合を終了します。"),
                                      Text("終了時刻 ${dateTime.hour.toString()}時${dateTime.minute.toString()}分"),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: const TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () async {
                                          Picker(
                                              adapter: DateTimePickerAdapter(type: PickerDateTimeType.kHM, value: dateTime, customColumnType: [3, 4]),
                                              title: const Text("時間選択"),
                                              onConfirm: (Picker picker, List value) {
                                                setState(() {
                                                  dateTime = DateTime.utc(0, 0, 0, value[0], value[1], 0);
                                                });
                                              }).showModal(context);
                                        },
                                        child: const Text("終了時刻変更"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: <Widget>[
                          if (!_isLoadingDialog)
                            SizedBox(
                              width: 120,
                              height: 40,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("キャンセル"),
                              ),
                            ),
                          if (!_isLoadingDialog)
                            SizedBox(
                              width: 120,
                              height: 40,
                              child: FilledButton(
                                child: const Text("終了"),
                                onPressed: () async {
                                  setState(() {
                                    _isLoadingDialog = true;
                                  });

                                  data = {
                                    "title": "${_thisGameData["place"]}) ${dateTime.hour.toString()}時${dateTime.minute.toString()}分 ${_gameDataId.toUpperCase()} 終了",
                                    "timeStamp": DateTime.now()
                                  };
                                  await GameDataManager.updateData(
                                      ref: ref,
                                      gameId: _gameDataId,
                                      newData: _selectedExtraTime == ""
                                          ? {
                                              "gameStatus": "after",
                                              "score": [
                                                int.parse(_scoreList[0]),
                                                int.parse(_scoreList[1]),
                                              ],
                                              "scoreDetail": {
                                                "0": [
                                                  int.parse(_scoreDetail1Controller.text),
                                                  int.parse(_scoreDetail2Controller.text),
                                                ],
                                                "1": [
                                                  int.parse(_scoreDetail3Controller.text),
                                                  int.parse(_scoreDetail4Controller.text),
                                                ],
                                                "2": [
                                                  int.parse(_scoreDetail5Controller.text),
                                                  int.parse(_scoreDetail6Controller.text),
                                                ],
                                              },
                                            }
                                          : {
                                              "gameStatus": "after",
                                              "score": [
                                                int.parse(_scoreList[0]),
                                                int.parse(_scoreList[1]),
                                              ],
                                              "scoreDetail": {
                                                "0": [
                                                  int.parse(_scoreDetail1Controller.text),
                                                  int.parse(_scoreDetail2Controller.text),
                                                ],
                                                "1": [
                                                  int.parse(_scoreDetail3Controller.text),
                                                  int.parse(_scoreDetail4Controller.text),
                                                ],
                                                "2": [
                                                  int.parse(_scoreDetail5Controller.text),
                                                  int.parse(_scoreDetail6Controller.text),
                                                ],
                                              },
                                              "extraTime": _selectedExtraTime,
                                            },
                                      teams: _thisGameData["team"]);

                                  //トーナメントの更新
                                  if (_isTournament) {
                                    _updateTournament(
                                      gameId: _gameDataId,
                                    );
                                  }

                                  await FirebaseFirestore.instance.collection('Timeline').add(data);

                                  setState(() {
                                    _isLoadingDialog = false;
                                  });
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("試合を終了しました。")),
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  });
            },
      label: const Text("試合終了"),
      icon: const Icon(Icons.sports),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gotData = ModalRoute.of(context)!.settings.arguments as GameDataToPass;
    if (gotData.classNumber == null) {
      _thisGameData = ref.watch(gameDataForResultProvider)[gotData.gameDataId.substring(0, 2)][gotData.gameDataId[3]][gotData.gameDataId];
    } else {
      _thisGameData = ref.watch(gameDataForScheduleProvider)[gotData.classNumber][gotData.gameDataId[1]][gotData.gameDataId];
    }
    _thisGameSportType = SportsType.values.byName(_thisGameData["sport"]);
    _gameDataId = _thisGameData["gameId"];
    _isTournament = _gameDataId.contains("f") || _gameDataId.contains("l");
    _isReverse = gotData.isReverse;

    if (_isInit) {
      _scoreDetail1Controller.text = _thisGameData["scoreDetail"]["0"][0].toString();
      _scoreDetail2Controller.text = _thisGameData["scoreDetail"]["0"][1].toString();
      _scoreDetail3Controller.text = _thisGameData["scoreDetail"]["1"][0].toString();
      _scoreDetail4Controller.text = _thisGameData["scoreDetail"]["1"][1].toString();
      _scoreDetail5Controller.text = _thisGameData["scoreDetail"]["2"][0].toString();
      _scoreDetail6Controller.text = _thisGameData["scoreDetail"]["2"][1].toString();
      _selectedExtraTime = _thisGameData["extraTime"];
      _isInit = false;
    }

    return Scaffold(
        appBar: AppBar(title: const Text("試合")),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            final FocusScopeNode currentScope = FocusScope.of(context);
            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              _buildTopSection(),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _gameStatus(GameStatus.values.byName(_thisGameData["gameStatus"])),
                      const SizedBox(height: 30),
                      if (_thisGameData["gameStatus"] == "now") _scoreInputWidget(),
                      const SizedBox(height: 20),
                      if (_thisGameData["gameStatus"] == "now" && _thisGameSportType != SportsType.volleyball && _isTournament)
                        _extraTimeInputWidget(
                          team1: _thisGameData["team"]["0"],
                          team2: _thisGameData["team"]["1"],
                        ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
        persistentFooterAlignment: AlignmentDirectional.bottomCenter,
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_thisGameData["gameStatus"] != "before") _buildBackButton(),
              const SizedBox(width: 10),
              if (_thisGameData["gameStatus"] == "before") _buildStartGameButton(),
              if (_thisGameData["gameStatus"] == "now") _buildEndGameButton(),
            ],
          ),
        ]);
  }
}
