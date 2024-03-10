import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumutai_app/providers/init_data_provider.dart';
import 'package:rumutai_app/themes/app_color.dart';

import 'package:rumutai_app/utilities/label_utilities.dart';

import '../detail_screen.dart';
import '../../widgets/game_admin_dialog_widget.dart';
import '../../providers/game_data_provider.dart';

class AdminEditScreen extends ConsumerStatefulWidget {
  static const routeName = "/game-admin-screen";

  const AdminEditScreen({super.key});

  @override
  ConsumerState<AdminEditScreen> createState() => _AdminEditScreenState();
}

class _AdminEditScreenState extends ConsumerState<AdminEditScreen> {
  final TextEditingController _team1Controller = TextEditingController();
  final TextEditingController _team2Controller = TextEditingController();
  final TextEditingController _timeDateController = TextEditingController();
  final TextEditingController _timeHourController = TextEditingController();
  final TextEditingController _timeMinuteController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _referee1Controller = TextEditingController();
  final TextEditingController _referee2Controller = TextEditingController();
  final TextEditingController _referee3Controller = TextEditingController();
  final TextEditingController _referee4Controller = TextEditingController();
  final TextEditingController _score1Controller = TextEditingController();
  final TextEditingController _score2Controller = TextEditingController();
  final TextEditingController _scoreDetail1Controller = TextEditingController();
  final TextEditingController _scoreDetail2Controller = TextEditingController();
  final TextEditingController _scoreDetail3Controller = TextEditingController();
  final TextEditingController _scoreDetail4Controller = TextEditingController();
  final TextEditingController _scoreDetail5Controller = TextEditingController();
  final TextEditingController _scoreDetail6Controller = TextEditingController();

  bool _isInit = true;
  String? _selectedGameStatus;
  String? _selectedExtraTime;
  String? _selectedExtraTimeOnDropButton;

  List<String> _dirtyList = [];
  late Map _thisGameData;
  late SportsType _thisGameSportsType;
  late String _thisGameId;

  bool _dialogIsLoading = false;
  bool _isReverse = false;

  Widget _textField({
    required double width,
    required TextEditingController controller,
    String? saffixLabel,
    bool canEnterOnlyNumber = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
          keyboardType: !canEnterOnlyNumber ? null : (Platform.isAndroid ? TextInputType.number : const TextInputType.numberWithOptions(decimal: true)),
          inputFormatters: !canEnterOnlyNumber ? null : [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            border: const UnderlineInputBorder(),
            fillColor: AppColors.themeColor.shade50,
            contentPadding: const EdgeInsets.only(left: 5),
            filled: true,
            isDense: true,
            isCollapsed: true,
            suffixText: saffixLabel,
            suffixStyle: const TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(fontSize: 20),
          onChanged: (_) {
            _dirtyCheck();
            setState(() {});
          },
          controller: controller),
    );
  }

  void _dirtyCheck() {
    _dirtyList = [];
    if (_thisGameData["team"]["0"] != _team1Controller.text) {
      _dirtyList.add("team1");
    }
    if (_thisGameData["team"]["1"] != _team2Controller.text) {
      _dirtyList.add("team2");
    }
    if (_thisGameData["startTime"]["date"] != _timeDateController.text) {
      _dirtyList.add("timeDate");
    }
    if (_thisGameData["startTime"]["hour"] != _timeHourController.text) {
      _dirtyList.add("timeHour");
    }
    if (_thisGameData["startTime"]["minute"] != _timeMinuteController.text) {
      _dirtyList.add("timeMinute");
    }
    if (_thisGameData["place"] != _placeController.text) {
      _dirtyList.add("place");
    }
    if (_thisGameData["referee"][0] != _referee1Controller.text) {
      _dirtyList.add("referee1");
    }
    if (_thisGameData["referee"][1] != _referee2Controller.text) {
      _dirtyList.add("referee2");
    }
    if (_thisGameData["referee"][2] != _referee3Controller.text) {
      _dirtyList.add("referee3");
    }
    if ((_thisGameData["referee"].length >= 4 && _thisGameData["referee"][3] != _referee4Controller.text)) {
      _dirtyList.add("referee4");
    }
    if (_thisGameData["gameStatus"] != _newGameStatus) {
      _dirtyList.add("gameStatus");
    }
    if (_thisGameData["extraTime"] != _newExtraTime) {
      _dirtyList.add("extraTime");
    }
    if (_thisGameData["score"][0].toString() != _score1Controller.text) {
      _dirtyList.add("score1");
    }
    if (_thisGameData["score"][1].toString() != _score2Controller.text) {
      _dirtyList.add("score2");
    }
    if (_thisGameData["scoreDetail"]["0"][0].toString() != _scoreDetail1Controller.text) {
      _dirtyList.add("scoreDetail1");
    }
    if (_thisGameData["scoreDetail"]["0"][1].toString() != _scoreDetail2Controller.text) {
      _dirtyList.add("scoreDetail2");
    }
    if (_thisGameData["scoreDetail"]["1"][0].toString() != _scoreDetail3Controller.text) {
      _dirtyList.add("scoreDetail3");
    }
    if (_thisGameData["scoreDetail"]["1"][1].toString() != _scoreDetail4Controller.text) {
      _dirtyList.add("scoreDetail4");
    }
    if (_thisGameData["scoreDetail"]["2"][0].toString() != _scoreDetail5Controller.text) {
      _dirtyList.add("scoreDetail5");
    }
    if (_thisGameData["scoreDetail"]["2"][1].toString() != _scoreDetail6Controller.text) {
      _dirtyList.add("scoreDetail6");
    }
  }

  Map<String, Object> get _newDataForUpdate {
    Map<String, Object> newData = {};
    for (var data in _dirtyList) {
      if (data.contains("team")) {
        newData["team"] = {
          "0": _team1Controller.text,
          "1": _team2Controller.text,
        };
      } else if (data.contains("time")) {
        newData["startTime"] = {
          "date": _timeDateController.text,
          "hour": _timeHourController.text,
          "minute": _timeMinuteController.text,
        };
      } else if (data == "place") {
        newData["place"] = _placeController.text;
      } else if (data.contains("referee")) {
        newData["referee"] = (_thisGameId.contains("1g")
            ? [
                _referee1Controller.text,
                _referee2Controller.text,
                _referee3Controller.text,
                _referee4Controller.text,
              ]
            : [
                _referee1Controller.text,
                _referee2Controller.text,
                _referee3Controller.text,
              ]);
      } else if (data == "gameStatus") {
        newData["gameStatus"] = _newGameStatus;
      } else if (data == "extraTime") {
        newData["extraTime"] = _newExtraTime;
      } else if (data.contains("Detail")) {
        newData["scoreDetail"] = {
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
        };
      } else if (data.contains("score")) {
        newData["score"] = [
          int.parse(_score1Controller.text),
          int.parse(_score2Controller.text),
        ];
      }
    }
    return newData;
  }

  String get _newGameStatus {
    late String newGameStatus;
    if (_selectedGameStatus == "試合前") {
      newGameStatus = "before";
    } else if (_selectedGameStatus == "試合中") {
      newGameStatus = "now";
    } else if (_selectedGameStatus == "試合終了") {
      newGameStatus = "after";
    }
    return newGameStatus;
  }

  String get _newExtraTime {
    if (_selectedExtraTime == "なし") {
      return "";
    } else {
      return _selectedExtraTime!;
    }
  }

  int _toInt(String intString) {
    if (intString == "") {
      return 0;
    }
    return int.parse(intString);
  }

  Map get _newDataForDialog {
    return {
      "team": {"0": _team1Controller.text, "1": _team2Controller.text},
      "place": _placeController.text,
      "startTime": {
        "date": _timeDateController.text,
        "hour": _timeHourController.text,
        "minute": _timeMinuteController.text,
      },
      "referee": [
        _referee1Controller.text,
        _referee2Controller.text,
        _referee3Controller.text,
        _referee4Controller.text,
      ],
      "gameStatus": _newGameStatus,
      "extraTime": _newExtraTime,
      "score": [
        _toInt(_score1Controller.text),
        _toInt(_score2Controller.text),
      ],
      "scoreDetail": {
        "0": [
          _toInt(_scoreDetail1Controller.text),
          _toInt(_scoreDetail2Controller.text),
        ],
        "1": [
          _toInt(_scoreDetail3Controller.text),
          _toInt(_scoreDetail4Controller.text),
        ],
        "2": [
          _toInt(_scoreDetail5Controller.text),
          _toInt(_scoreDetail6Controller.text),
        ],
      },
      "gameId": _thisGameId,
    };
  }

  List<Widget> get _scoreDetailList {
    List<Widget> scoreDetailList = [];
    int count = 1;
    for (var label in LabelUtilities.scoreDetailLabelList(_thisGameSportsType)) {
      scoreDetailList.add(
        Row(
          children: [
            _label("$label："),
            if (count == 1)
              _textField(
                width: 40,
                controller: _isReverse ? _scoreDetail2Controller : _scoreDetail1Controller,
                canEnterOnlyNumber: true,
              )
            else if (count == 2)
              _textField(
                width: 40,
                controller: _isReverse ? _scoreDetail4Controller : _scoreDetail3Controller,
                canEnterOnlyNumber: true,
              )
            else if (count == 3)
              _textField(
                width: 40,
                controller: _isReverse ? _scoreDetail6Controller : _scoreDetail5Controller,
                canEnterOnlyNumber: true,
              ),
            const SizedBox(width: 20),
            const Text("-", style: TextStyle(fontSize: 20)),
            const SizedBox(width: 20),
            if (count == 1)
              _textField(
                width: 40,
                controller: _isReverse ? _scoreDetail1Controller : _scoreDetail2Controller,
                canEnterOnlyNumber: true,
              )
            else if (count == 2)
              _textField(
                width: 40,
                controller: _isReverse ? _scoreDetail3Controller : _scoreDetail4Controller,
                canEnterOnlyNumber: true,
              )
            else if (count == 3)
              _textField(
                width: 40,
                controller: _isReverse ? _scoreDetail5Controller : _scoreDetail6Controller,
                canEnterOnlyNumber: true,
              ),
          ],
        ),
      );
      count++;
    }
    return scoreDetailList;
  }

  Column get _refereeInputColumn {
    List<Widget> refereeDetailList = [];
    int count = 1;
    for (var label in LabelUtilities.refereeLabelList(_thisGameSportsType)) {
      late TextEditingController teController;
      if (count == 1) {
        teController = _referee1Controller;
      } else if (count == 2) {
        teController = _referee2Controller;
      } else if (count == 3) {
        teController = _referee3Controller;
      } else if (count == 4) {
        teController = _referee4Controller;
      }
      refereeDetailList.add(
        _textField(
          width: 180,
          controller: teController,
          saffixLabel: "($label)",
        ),
      );
      count++;
    }
    return Column(children: refereeDetailList);
  }

  Widget _label(label) {
    return SizedBox(
      width: 100,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _dialog() {
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        title: _dialogIsLoading ? const Text("試合情報を変更中") : const Text("変更内容を確認"),
        backgroundColor: AppColors.scaffoldBackgroundColor,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: _dialogIsLoading
                  ? const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Column(children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          " 変更前",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      GameAdminDialogWidget(
                        gameData: _thisGameData,
                        sportType: _thisGameSportsType,
                        isReverse: _isReverse,
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          " 変更後",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      GameAdminDialogWidget(
                        gameData: _newDataForDialog,
                        sportType: _thisGameSportsType,
                        dartyList: _dirtyList,
                        isReverse: _isReverse,
                      ),
                    ]),
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          if (!_dialogIsLoading)
            SizedBox(
              width: 140,
              height: 40,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("キャンセル"),
              ),
            ),
          if (!_dialogIsLoading)
            SizedBox(
              width: 140,
              height: 40,
              child: FilledButton(
                child: const Text("変更"),
                onPressed: () async {
                  setState(() {
                    _dialogIsLoading = true;
                  });
                  final Map<String, Object> newData = _newDataForUpdate;
                  await GameDataManager.updateData(
                    ref: ref,
                    gameId: _thisGameId,
                    newData: newData,
                    teams: {"0": _team1Controller.text, "1": _team2Controller.text},
                  );

                  _dialogIsLoading = false;
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('試合情報を変更しました。'),
                    ),
                  );
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(DetailScreen.routeName),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    GameDataToPassAdmin gotData = ModalRoute.of(context)!.settings.arguments as GameDataToPassAdmin;
    _thisGameData = gotData.thisGameData;
    _thisGameSportsType = SportsType.values.byName(_thisGameData["sport"]);
    _thisGameId = _thisGameData["gameId"];
    _isReverse = gotData.isReverse;

    if (_isInit) {
      _team1Controller.text = _thisGameData["team"]["0"];
      _team2Controller.text = _thisGameData["team"]["1"];
      _timeDateController.text = _thisGameData["startTime"]["date"];
      _timeHourController.text = _thisGameData["startTime"]["hour"];
      _timeMinuteController.text = _thisGameData["startTime"]["minute"];
      _placeController.text = _thisGameData["place"];
      _referee1Controller.text = _thisGameData["referee"][0];
      _referee2Controller.text = _thisGameData["referee"][1];
      _referee3Controller.text = _thisGameData["referee"][2];
      if (_thisGameData["referee"].length >= 4) {
        _referee4Controller.text = _thisGameData["referee"][3];
      } else {
        _referee4Controller.text = "";
      }
      _score1Controller.text = _thisGameData["score"][0].toString();
      _score2Controller.text = _thisGameData["score"][1].toString();
      _scoreDetail1Controller.text = _thisGameData["scoreDetail"]["0"][0].toString();
      _scoreDetail2Controller.text = _thisGameData["scoreDetail"]["0"][1].toString();
      _scoreDetail3Controller.text = _thisGameData["scoreDetail"]["1"][0].toString();
      _scoreDetail4Controller.text = _thisGameData["scoreDetail"]["1"][1].toString();
      _scoreDetail5Controller.text = _thisGameData["scoreDetail"]["2"][0].toString();
      _scoreDetail6Controller.text = _thisGameData["scoreDetail"]["2"][1].toString();

      if (_thisGameData["gameStatus"] == "before") {
        _selectedGameStatus = "試合前";
      } else if (_thisGameData["gameStatus"] == "now") {
        _selectedGameStatus = "試合中";
      } else if (_thisGameData["gameStatus"] == "after") {
        _selectedGameStatus = "試合終了";
      }
      if (_thisGameData["extraTime"] == _thisGameData["team"]["0"]) {
        _selectedExtraTime = _thisGameData["team"]["0"];
        _selectedExtraTimeOnDropButton = "team0";
      } else if (_thisGameData["extraTime"] == _thisGameData["team"]["1"]) {
        _selectedExtraTime = _thisGameData["team"]["1"];
        _selectedExtraTimeOnDropButton = "team1";
      } else {
        _selectedExtraTime = "なし";
        _selectedExtraTimeOnDropButton = "なし";
      }
      _isInit = false;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("編集")),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: FittedBox(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              _label("チーム："),
                              _textField(
                                width: 65,
                                controller: _isReverse ? _team2Controller : _team1Controller,
                              ),
                              const SizedBox(width: 10),
                              const Text("vs", style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 10),
                              _textField(
                                width: 65,
                                controller: _isReverse ? _team1Controller : _team2Controller,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              _label("開始時間："),
                              _textField(width: 40, controller: _timeDateController),
                              const Text("日目　"),
                              _textField(width: 40, controller: _timeHourController),
                              const Text("："),
                              _textField(width: 40, controller: _timeMinuteController),
                              const Text("から"),
                            ],
                          ),
                          Row(
                            children: [
                              _label("場所："),
                              _textField(width: 180, controller: _placeController),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(children: [const SizedBox(height: 10), _label("審判：")]),
                              _refereeInputColumn,
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          Row(
                            children: [
                              _label("試合状況："),
                              DropdownButton(
                                dropdownColor: Colors.white,
                                items: const [
                                  DropdownMenuItem(
                                    value: "試合前",
                                    child: Text("試合前"),
                                  ),
                                  DropdownMenuItem(
                                    value: "試合中",
                                    child: Text("試合中"),
                                  ),
                                  DropdownMenuItem(
                                    value: "試合終了",
                                    child: Text("試合終了"),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedGameStatus = value as String;
                                  });
                                  _dirtyCheck();
                                  setState(() {});
                                },
                                value: _selectedGameStatus,
                              ),
                              if ((_thisGameSportsType != SportsType.volleyball) && (_thisGameId.contains("f") || _thisGameId.contains("l"))) const SizedBox(width: 20),
                              if ((_thisGameSportsType != SportsType.volleyball) && (_thisGameId.contains("f") || _thisGameId.contains("l")))
                                Text(
                                  LabelUtilities.extraTimeLabel(_thisGameSportsType),
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              if ((_thisGameSportsType != SportsType.volleyball) && (_thisGameId.contains("f") || _thisGameId.contains("l")))
                                DropdownButton(
                                  items: [
                                    DropdownMenuItem(
                                      value: "team0",
                                      child: SizedBox(
                                        width: 80,
                                        child: Text(
                                          "${_team1Controller.text} 勝利",
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "team1",
                                      child: SizedBox(
                                        width: 80,
                                        child: Text(
                                          "${_team2Controller.text} 勝利",
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    const DropdownMenuItem(
                                      value: "なし",
                                      child: Text("なし"),
                                    ),
                                  ],
                                  onChanged: (String? value) {
                                    late String valueToSet;
                                    if (value == "team0") {
                                      valueToSet = _team1Controller.text;
                                    } else if (value == "team1") {
                                      valueToSet = _team2Controller.text;
                                    } else {
                                      valueToSet = "なし";
                                    }
                                    setState(() {
                                      _selectedExtraTimeOnDropButton = value;
                                      _selectedExtraTime = valueToSet;
                                    });
                                    _dirtyCheck();
                                    setState(() {});
                                  },
                                  value: _selectedExtraTimeOnDropButton,
                                )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const SizedBox(width: 100),
                              SizedBox(
                                width: 85,
                                child: Text(
                                  _isReverse ? _team2Controller.text : _team1Controller.text,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 18,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 85,
                                child: Text(
                                  _isReverse ? _team1Controller.text : _team2Controller.text,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 18,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _label("点数："),
                                  _textField(
                                    width: 40,
                                    controller: _isReverse ? _score2Controller : _score1Controller,
                                    canEnterOnlyNumber: true,
                                  ),
                                  const SizedBox(width: 20),
                                  const Text("-", style: TextStyle(fontSize: 20)),
                                  const SizedBox(width: 20),
                                  _textField(
                                    width: 40,
                                    controller: _isReverse ? _score1Controller : _score2Controller,
                                    canEnterOnlyNumber: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: _scoreDetailList,
                          ),
                          const SizedBox(height: 10),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterAlignment: AlignmentDirectional.bottomCenter,
      persistentFooterButtons: [
        SizedBox(
          width: 350,
          child: FilledButton(
            onPressed: (_dirtyList.isEmpty ||
                    ((_thisGameId.contains("f") || _thisGameId.contains("l")) && (_newGameStatus == "after") && (_score1Controller.text == _score2Controller.text) && (_newExtraTime == "")))
                ? null
                : () => showDialog(
                      context: context,
                      builder: (_) {
                        return _dialog();
                      },
                    ),
            child: const Text(
              "内容を変更",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
