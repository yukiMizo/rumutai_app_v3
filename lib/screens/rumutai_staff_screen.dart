import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:provider/provider.dart';
import 'package:rumutai_app/utilities/lable_utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utilities/tournament_type_utilities.dart';

import '../providers/game_data.dart';

class RumutaiStaffScreen extends StatefulWidget {
  static const routeName = "/game-rumutai-staff-screen";

  const RumutaiStaffScreen({super.key});

  @override
  State<RumutaiStaffScreen> createState() => _RumutaiStaffScreenState();
}

class _RumutaiStaffScreenState extends State<RumutaiStaffScreen> {
  bool _isLoadingDialog = false;
  bool _isInit = true;
  bool _isReverse = false;
  late Map _gameData;
  late Map<String, dynamic> data;

  final TextEditingController _scoreDetail1Controller = TextEditingController();
  final TextEditingController _scoreDetail2Controller = TextEditingController();
  final TextEditingController _scoreDetail3Controller = TextEditingController();
  final TextEditingController _scoreDetail4Controller = TextEditingController();
  final TextEditingController _scoreDetail5Controller = TextEditingController();
  final TextEditingController _scoreDetail6Controller = TextEditingController();

  late String _selectedExtraTime;

  late DateTime dateTime;

  Widget _textField({
    required double width,
    required TextEditingController controller,
    InputDecoration? inputDecoration,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
          keyboardType: Platform.isAndroid ? TextInputType.number : const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: inputDecoration ?? const InputDecoration(isDense: true),
          style: const TextStyle(fontSize: 30),
          onChanged: (text) {
            setState(() {});
          },
          controller: controller),
    );
  }

//not flexible
  List<String> get _scoreDetailLableList {
    if (_gameData["sport"] == "futsal" || _gameData["sport"] == "dodgebee" || _gameData["sport"] == "dodgeball") {
      return ["前半", "後半"];
    } else if (_gameData["sport"] == "volleyball") {
      if ((_scoreList[0] == "1" && _scoreList[1] == "1") || (int.parse(_scoreList[0]) + int.parse(_scoreList[1]) == 3)) {
        return ["セット１", "セット２", "セット３"];
      }
      _scoreDetail5Controller.text = "0";
      _scoreDetail6Controller.text = "0";
      return ["セット１", "セット２"];
    } else if (_gameData["sport"] == "basketball") {
      return ["ピリオド１", "ピリオド２", "ピリオド３"];
    } /*else if (_gameData["gameId"][1] == "m") {
      if ((_scoreList[0] == "1" && _scoreList[1] == "1") ||
          (int.parse(_scoreList[0]) + int.parse(_scoreList[1]) == 3)) {
        return ["セット１", "セット２", "セット３"];
      }
      _scoreDetail5Controller.text = "0";
      _scoreDetail6Controller.text = "0";
      return ["セット１", "セット２"];
    } else if (_gameData["gameId"][0] == "1") {
      return ["ピリオド１", "ピリオド２", "ピリオド３"];
    } else if (_gameData["gameId"][0] == "2") {
      return ["前半", "後半"];
    }*/
    return [];
  }

  Column _scoreInputWidget() {
    List<Widget> widgetList = [];
    int count = 1;
    for (var lable in _scoreDetailLableList) {
      widgetList.add(
        Stack(
          alignment: const Alignment(-1, 0),
          children: [
            _lable("$lable："),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (count == 1) _textField(width: 40, controller: _isReverse ? _scoreDetail2Controller : _scoreDetail1Controller),
                if (count == 2) _textField(width: 40, controller: _isReverse ? _scoreDetail4Controller : _scoreDetail3Controller),
                if (count == 3) _textField(width: 40, controller: _isReverse ? _scoreDetail6Controller : _scoreDetail5Controller),
                const SizedBox(width: 20),
                const Text("-", style: TextStyle(fontSize: 30)),
                const SizedBox(width: 20),
                if (count == 1) _textField(width: 40, controller: _isReverse ? _scoreDetail1Controller : _scoreDetail2Controller),
                if (count == 2) _textField(width: 40, controller: _isReverse ? _scoreDetail3Controller : _scoreDetail4Controller),
                if (count == 3) _textField(width: 40, controller: _isReverse ? _scoreDetail5Controller : _scoreDetail6Controller),
              ],
            ),
          ],
        ),
      );
      count++;
    }
    widgetList.add(const SizedBox(height: 40));
    List<String> scoreList = _scoreList;
    widgetList.add(
      Stack(
        alignment: const Alignment(-1, 0),
        children: [
          if (_gameData["sport"] == "volleyball") _lable("セット数：") else _lable("点数："),
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

    if (_gameData["sport"] == "volleyball") {
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

  Widget _gameStatus(String status) {
    if (status == "before") {
      return const Text(
        "試合前",
        style: TextStyle(fontSize: 16),
      );
    } else if (status == "now") {
      return Text(
        "試合中",
        style: TextStyle(
          color: Colors.deepPurpleAccent.shade700,
          fontSize: 16,
        ),
      );
    } else if (status == "after") {
      return const Text(
        "試合終了",
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      );
    }
    return const Text("");
  }

  CategoryToGet? _gameDataToGet(String gameDataId) {
    if (gameDataId.contains("1d")) {
      return CategoryToGet.d1;
    } else if (gameDataId.contains("1j")) {
      return CategoryToGet.j1;
    } else if (gameDataId.contains("1k")) {
      return CategoryToGet.k1;
    } else if (gameDataId.contains("2d")) {
      return CategoryToGet.d2;
    } else if (gameDataId.contains("2j")) {
      return CategoryToGet.j2;
    } else if (gameDataId.contains("2k")) {
      return CategoryToGet.k2;
    } else if (gameDataId.contains("3d")) {
      return CategoryToGet.d3;
    } else if (gameDataId.contains("3j")) {
      return CategoryToGet.j3;
    } else if (gameDataId.contains("3k")) {
      return CategoryToGet.k3;
    }
    return null;
  }

  Widget _scoreDetailPartWidget({
    required Map scoreData,
    required String index,
    required String lable,
  }) {
    return SizedBox(
      width: 300,
      child: Stack(
        alignment: const Alignment(-1, 0),
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$lable：",
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
    List<String> scoreDetailLableList = _scoreDetailLableList;
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
                    _gameData["team"][_isReverse ? "1" : "0"],
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
                    _gameData["team"][_isReverse ? "0" : "1"],
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
          lable: scoreDetailLableList[0],
        ),
        _scoreDetailPartWidget(
          scoreData: scoreData,
          index: "1",
          lable: scoreDetailLableList[1],
        ),
        if ((_gameData["sport"] == "volleyball" || _gameData["sport"] == "basketball") && scoreDetailLableList.length == 3)
          _scoreDetailPartWidget(
            scoreData: scoreData,
            index: "2",
            lable: scoreDetailLableList[2],
          ),
      ],
    );
  }

/*{"gameId":{"0":"team"}}
*/

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

  Widget _lable(text) {
    return SizedBox(
      width: 100,
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

  Widget _extraTimeInputWidget({
    required String team1,
    required String team2,
    required String sport,
  }) {
    return Row(
      children: [
        _lable(LableUtilities.extraTimeLable(sport)),
        SizedBox(
          width: 150,
          child: DropdownButton(
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

  Widget _extraTimeWidget(String sport) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LableUtilities.extraTimeLable(sport),
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
    required gameDataProvider,
    required String gameId,
  }) async {
    final TournamentType tournamentType = TournamentTypeUtilities.tournamentType(gameId);
    final Map<String, Map<String, String>> dataToUpdate = _dataToUpdateTournament(
      gameData: _gameData,
      tournamentType: tournamentType,
    );

    if (dataToUpdate == {}) {
      return;
    }

    dataToUpdate.forEach((gameId, teamDataToUpdate) async {
      await gameDataProvider.updateData(
          doc: gameId,
          newData: {
            "team": teamDataToUpdate,
          },
          teams: _gameData["team"],
          setMerge: true);
    });
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
    if (_gameData["sport"] == "volleyball") {
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

  @override
  Widget build(BuildContext context) {
    Provider.of<GameData>(context);
    final gameDataProvider = Provider.of<GameData>(context, listen: false);
    final DataToPass gotData = ModalRoute.of(context)!.settings.arguments as DataToPass;
    final String gameDataId = gotData.gameDataId;
    final bool isTournament = gameDataId.contains("f") || gameDataId.contains("l");
    _isReverse = gotData.isReverse;

    if (gotData.classNumber != null) {
      _gameData = (Provider.of<GameData>(context).getGameDataForSchedule(classNumber: gotData.classNumber!) as Map)[gotData.gameDataId[1]][gotData.gameDataId];
    } else {
      _gameData = (Provider.of<GameData>(context).getGameDataForResult(categoryToGet: _gameDataToGet(gotData.gameDataId)!) as Map)[gotData.gameDataId[3]][gotData.gameDataId];
    }

    if (_isInit) {
      _scoreDetail1Controller.text = _gameData["scoreDetail"]["0"][0].toString();
      _scoreDetail2Controller.text = _gameData["scoreDetail"]["0"][1].toString();
      _scoreDetail3Controller.text = _gameData["scoreDetail"]["1"][0].toString();
      _scoreDetail4Controller.text = _gameData["scoreDetail"]["1"][1].toString();
      _scoreDetail5Controller.text = _gameData["scoreDetail"]["2"][0].toString();
      _scoreDetail6Controller.text = _gameData["scoreDetail"]["2"][1].toString();
      _selectedExtraTime = _gameData["extraTime"];
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_gameData["team"][_isReverse ? "1" : "0"], style: const TextStyle(fontSize: 40)),
                  const Text(" vs ", style: TextStyle(fontSize: 30)),
                  Text(_gameData["team"][_isReverse ? "0" : "1"], style: const TextStyle(fontSize: 40)),
                ],
              ),
              Text("${_gameData["startTime"]["date"]}日目　${_gameData["startTime"]["hour"]}:${_gameData["startTime"]["minute"]}〜　${_gameData["place"]}"),
              const Divider(),
              Column(
                children: [
                  _gameStatus(_gameData["gameStatus"]),
                  const SizedBox(height: 30),
                  if (_gameData["gameStatus"] == "now") _scoreInputWidget(),
                  const SizedBox(height: 30),
                  if (_gameData["gameStatus"] == "now" && _gameData["sport"] != "volleyball" && isTournament)
                    _extraTimeInputWidget(
                      team1: _gameData["team"]["0"],
                      team2: _gameData["team"]["1"],
                      sport: _gameData["sport"],
                    ),
                ],
              ),
            ]),
          ),
        ),
        persistentFooterAlignment: AlignmentDirectional.bottomCenter,
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //戻るボタン
              if (_gameData["gameStatus"] != "before")
                TextButton.icon(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (_) {
                        final String currentGameStatus = _gameData["gameStatus"];

                        return StatefulBuilder(
                          builder: (context, setState) => AlertDialog(
                            title: const Text("確認"),
                            content: _isLoadingDialog
                                ? const SizedBox(
                                    height: 180,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : (currentGameStatus == "now" ? const Text("試合前に戻します。") : const Text("試合中に戻します。")),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: <Widget>[
                              if (!_isLoadingDialog)
                                SizedBox(
                                  width: 110,
                                  height: 40,
                                  child: OutlinedButton(
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty.all(Colors.black),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("キャンセル"),
                                  ),
                                ),
                              if (!_isLoadingDialog)
                                SizedBox(
                                  width: 110,
                                  height: 40,
                                  child: FilledButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    child: const Text("戻す"),
                                    onPressed: () async {
                                      setState(() {
                                        _isLoadingDialog = true;
                                      });
                                      await gameDataProvider.updateData(
                                          doc: gameDataId,
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
                                          teams: _gameData["team"]);
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
                  label: const Text(
                    "戻す",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  icon: const Icon(Icons.arrow_back),
                ),
              const SizedBox(width: 10),
              //試合開始ボタン
              if (_gameData["gameStatus"] == "before")
                ElevatedButton.icon(
                  onPressed: () {
                    dateTime = DateTime.now();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
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
                                                      setState(() => {dateTime = DateTime.utc(0, 0, 0, value[0], value[1], 0)});
                                                    }).showModal(context);
                                              })
                                        ],
                                      ),
                                    ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: <Widget>[
                                if (!_isLoadingDialog)
                                  SizedBox(
                                    width: 110,
                                    height: 40,
                                    child: OutlinedButton(
                                      style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all(Colors.black),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("キャンセル"),
                                    ),
                                  ),
                                if (!_isLoadingDialog)
                                  SizedBox(
                                    width: 110,
                                    height: 40,
                                    child: FilledButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                      child: const Text("開始"),
                                      onPressed: () async {
                                        setState(() {
                                          _isLoadingDialog = true;
                                        });

                                        data = {
                                          "title": "${_gameData["place"]}) ${dateTime.hour.toString()}時${dateTime.minute.toString()}分 ${gameDataId.toUpperCase()} 開始",
                                          "timeStamp": DateTime.now()
                                        };
                                        await gameDataProvider.updateData(doc: gameDataId, newData: {"gameStatus": "now"}, teams: _gameData["team"]);

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
                ),
              //試合終了ボタン
              if (_gameData["gameStatus"] == "now")
                ElevatedButton.icon(
                  onPressed: !_canFinishGame(isTournament)
                      ? null
                      : () {
                          dateTime = DateTime.now();
                          showDialog(
                              context: context,
                              builder: (_) {
                                return StatefulBuilder(
                                  builder: (context, setState) => AlertDialog(
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
                                                  if (_selectedExtraTime != "") _extraTimeWidget(_gameData["sport"]),
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
                                                            setState(() => {dateTime = DateTime.utc(0, 0, 0, value[0], value[1], 0)});
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
                                          width: 110,
                                          height: 40,
                                          child: OutlinedButton(
                                            style: ButtonStyle(
                                              foregroundColor: MaterialStateProperty.all(Colors.black),
                                            ),
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text("キャンセル"),
                                          ),
                                        ),
                                      if (!_isLoadingDialog)
                                        SizedBox(
                                          width: 110,
                                          height: 40,
                                          child: FilledButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            child: const Text("終了"),
                                            onPressed: () async {
                                              setState(() {
                                                _isLoadingDialog = true;
                                              });

                                              data = {
                                                "title": "${_gameData["place"]}) ${dateTime.hour.toString()}時${dateTime.minute.toString()}分 ${gameDataId.toUpperCase()} 終了",
                                                "timeStamp": DateTime.now()
                                              };
                                              await gameDataProvider.updateData(
                                                  doc: gameDataId,
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
                                                  teams: _gameData["team"]);

                                              //トーナメントの更新
                                              if (isTournament) {
                                                _updateTournament(
                                                  gameDataProvider: gameDataProvider,
                                                  gameId: gameDataId,
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
                ),
            ],
          ),
        ]);
  }
}
