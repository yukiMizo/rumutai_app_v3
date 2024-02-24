import 'package:flutter/material.dart';

import '../screens/detail_screen.dart';
import '../providers/game_data.dart';

import '../providers/local_data.dart';
import '../utilities/local_notification.dart';

class MyGameWidget extends StatefulWidget {
  final Map gameData;
  final bool isReverse;
  const MyGameWidget({
    super.key,
    required this.gameData,
    this.isReverse = false,
  });

  @override
  State<MyGameWidget> createState() => _MyGameWidgetState();
}

class _MyGameWidgetState extends State<MyGameWidget> {
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
            arguments: DataToPass(
              gameDataId: widget.gameData["gameId"],
              isMyGame: true,
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
                      "${widget.gameData["team"]["0"]} vs ${widget.gameData["team"]["1"]}",
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
                                  LocalNotification.registerLocNotification(
                                    place: widget.gameData["place"],
                                    gameId: widget.gameData["gameId"],
                                    sport: widget.gameData["sport"],
                                    day: widget.gameData["startTime"]["date"],
                                    hour: widget.gameData["startTime"]["hour"],
                                    minute: widget.gameData["startTime"]["minute"],
                                    team1: widget.gameData["team"]["0"],
                                    team2: widget.gameData["team"]["1"],
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
                                  LocalNotification.cancelLocNotification(
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
