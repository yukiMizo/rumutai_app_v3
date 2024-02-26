import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/detail_screen.dart';
import '../providers/game_data_provider.dart';

import '../local_data.dart';

import '../notification_manager.dart';

class ScheduleWidget extends ConsumerStatefulWidget {
  final Map gameData;
  final String classNumber;
  final bool isReverse;
  const ScheduleWidget({
    super.key,
    required this.gameData,
    required this.classNumber,
    this.isReverse = false,
  });

  @override
  ConsumerState<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends ConsumerState<ScheduleWidget> {
  bool _notify = false;
  bool _gameIsDone = false;

  @override
  void initState() {
    super.initState();
    readNotify().then((value) {
      setState(() {
        _notify = value;
      });
    });
  }

  //通知on,offの再読み込み
  Future<bool> readNotify() async {
    bool isNotify = await LocalData.readLocalData<bool>(widget.gameData["gameId"]) ?? false;
    return Future<bool>.value(isNotify);
  }

  String _otherTeam(Map team, String classNumber) {
    if (team["0"] == _myTeam(team, classNumber)) {
      return team["1"];
    }
    return team["0"];
  }

  String _myTeam(Map team, String classNumber) {
    if (classNumber == "110") {
      if (team.containsValue("110a")) {
        return "110a";
      } else if (team.containsValue("110b")) {
        return "110b";
      } else {
        return classNumber;
      }
    } else if (classNumber == "210") {
      if (team.containsValue("210a")) {
        return "210a";
      } else if (team.containsValue("210b")) {
        return "210b";
      } else {
        return classNumber;
      }
    } else if (classNumber == "309") {
      if (team.containsValue("309a")) {
        return "309a";
      } else if (team.containsValue("309b")) {
        return "309b";
      } else {
        return classNumber;
      }
    } else {
      return classNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gameData["gameStatus"] == "after") {
      _gameIsDone = true;
    }
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            DetailScreen.routeName,
            arguments: GameDataToPass(
              gameDataId: widget.gameData["gameId"],
              classNumber: widget.classNumber,
              isReverse: widget.classNumber == widget.gameData["team"]["0"] ? false : true,
            ),
          ),
          child: Card(
            elevation: _gameIsDone ? 1 : 3,
            color: _gameIsDone ? Colors.grey.shade300 : null,
            child: SizedBox(
              height: 75,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "${_myTeam(widget.gameData["team"], widget.classNumber)} vs ${_otherTeam(widget.gameData["team"], widget.classNumber)}",
                      style: const TextStyle(
                        fontSize: 28,
                        height: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _gameIsDone
                          ? [
                              const Text(
                                "試合終了",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                ),
                              )
                            ]
                          : [
                              Text(
                                "${widget.gameData["startTime"]["hour"]}:${widget.gameData["startTime"]["minute"]}〜",
                                style: const TextStyle(fontSize: 20, height: 1.0),
                              ),
                              const SizedBox(height: 6),
                              FittedBox(
                                child: Text(
                                  widget.gameData["place"],
                                  style: const TextStyle(fontSize: 20, height: 1.0),
                                ),
                              ),
                            ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: _gameIsDone
                        ? null
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                _notify = !_notify;
                                if (_notify) {
                                  //通知予約
                                  NotificationManager.registerLocNotification(
                                    ref: ref,
                                    place: widget.gameData["place"],
                                    gameId: widget.gameData["gameId"],
                                    sport: widget.gameData["sport"],
                                    day: widget.gameData["startTime"]["date"],
                                    hour: widget.gameData["startTime"]["hour"],
                                    minute: widget.gameData["startTime"]["minute"],
                                    team1: _myTeam(widget.gameData["team"], widget.classNumber),
                                    team2: _otherTeam(widget.gameData["team"], widget.classNumber),
                                  ).then((_) {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(milliseconds: 1500),
                                        content: Text("通知オン　試合10分前に通知します。"),
                                      ),
                                    );
                                  });
                                } else {
                                  NotificationManager.cancelLocNotification(
                                    widget.gameData["gameId"],
                                  ).then((_) {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(milliseconds: 1500),
                                        content: Text("通知オフ"),
                                      ),
                                    );
                                  });
                                }
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 5),
                                Icon(
                                  Icons.notifications,
                                  size: 28,
                                  color: _notify ? Theme.of(context).colorScheme.secondary : Colors.grey,
                                ),
                                Text(
                                  _notify ? "on" : "off",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: _notify ? Theme.of(context).colorScheme.secondary : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
