import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumutai_app/providers/init_data_provider.dart';

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
  late GameStatus _gameStatus;

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
    } else if (classNumber == "310") {
      if (team.containsValue("310a")) {
        return "310a";
      } else if (team.containsValue("310b")) {
        return "310b";
      } else {
        return classNumber;
      }
    } else {
      return classNumber;
    }
  }

  Widget _buildInfoSection() {
    switch (_gameStatus) {
      case GameStatus.before:
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        );
      case GameStatus.now:
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "試合中",
                style: TextStyle(fontSize: 20, height: 1.0, color: Colors.deepPurpleAccent.shade700),
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
        );
      case GameStatus.after:
        return const Expanded(
          child: Center(
            child: Text(
              "試合終了",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            ),
          ),
        );
    }
  }

  Widget _buildLocNotificationButton() {
    return SizedBox(
      width: 70,
      child: _gameStatus == GameStatus.after
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
                      sportsType: SportsType.values.byName(widget.gameData["sport"]),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    _gameStatus = GameStatus.values.byName(widget.gameData["gameStatus"]);
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
            elevation: 1,
            color: _gameStatus == GameStatus.after ? Colors.grey.shade300 : null,
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
                  _buildInfoSection(),
                  _buildLocNotificationButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
