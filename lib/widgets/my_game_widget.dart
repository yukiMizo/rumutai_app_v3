import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumutai_app/providers/init_data_provider.dart';

import '../screens/detail_screen.dart';
import '../providers/game_data_provider.dart';

import '../local_data.dart';
import '../notification_manager.dart';

class MyGameWidget extends ConsumerStatefulWidget {
  final Map gameData;
  final bool isReverse;
  const MyGameWidget({
    super.key,
    required this.gameData,
    this.isReverse = false,
  });

  @override
  ConsumerState<MyGameWidget> createState() => _MyGameWidgetState();
}

class _MyGameWidgetState extends ConsumerState<MyGameWidget> {
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
              isMyGame: true,
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
                      "${widget.gameData["team"]["0"]} vs ${widget.gameData["team"]["1"]}",
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
