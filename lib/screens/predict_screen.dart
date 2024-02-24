/*import 'package:flutter/material.dart';

import '../providers/local_data.dart';

class DataToPassPredictScreen {
  final Map teamMap;
  final String gameId;
  final bool isReverse;
  final String gameStatus;

  DataToPassPredictScreen({
    required this.gameId,
    required this.teamMap,
    required this.isReverse,
    required this.gameStatus,
  });
}

enum PredictScreenType { beforePredict, afterPredict, afterGame }

class PredictScreen extends StatefulWidget {
  static const routeName = "/predict-screen";
  const PredictScreen({super.key});

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  String? _choosedPredict;
  bool _isInit = true;
  bool _isLoading = false;
  bool _shouldSetLocalPredict = true;

  late bool _isReverse;
  late String _team1;
  late String _team2;
  late String _gameStatus;
  late String _gameId;

  String? _localMyPredict;

  Widget _circleButtonForClass({
    required String classStr,
  }) {
    return SizedBox(
      width: 100,
      height: 100,
      child: FilledButton(
        onPressed: () {
          setState(() {
            if (_choosedPredict == classStr) {
              _choosedPredict = null;
            } else {
              _choosedPredict = classStr;
            }
          });
        },
        style: FilledButton.styleFrom(
          backgroundColor: _choosedPredict == classStr
              ? Colors.brown.shade300
              : Colors.brown.shade100,
          foregroundColor: Colors.brown.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Center(
          child: Text(
            classStr,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButtonDraw() {
    return SizedBox(
      width: 100,
      height: 100,
      child: FilledButton(
        onPressed: () {
          setState(() {
            if (_choosedPredict == "引き分け") {
              _choosedPredict = null;
            } else {
              _choosedPredict = "引き分け";
            }
          });
        },
        style: FilledButton.styleFrom(
          backgroundColor: _choosedPredict == "引き分け"
              ? Colors.brown.shade300
              : Colors.brown.shade100,
          foregroundColor: Colors.brown.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Center(
          child: Text(
            "引き分け",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  String get _myPredict {
    if (_choosedPredict == null) {
      return "";
    }
    if (_choosedPredict == "引き分け") {
      return "引き分け";
    }
    return "$_choosedPredictが勝つ";
  }

  Widget _dialog() {
    bool dialogIsLoading = false;
    return StatefulBuilder(
      builder: (context, setStateInDialog) => AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        title: const Text("確認"),
        content: SizedBox(
          height: 160,
          child: dialogIsLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "注意：",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "予想は後で変更できません",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    Text(
                      "自分の予想：$_myPredict",
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          if (!dialogIsLoading)
            SizedBox(
              width: 140,
              height: 40,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                onPressed: () => Navigator.pop(context),
                child: const Text("キャンセル"),
              ),
            ),
          if (!dialogIsLoading)
            SizedBox(
              width: 140,
              height: 40,
              child: FilledButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: const Text("確定"),
                onPressed: () async {
                  setStateInDialog(() {
                    dialogIsLoading = true;
                  });
                  await LocalData.saveLocalData<String>(
                      "myPredictOf$_gameId", _choosedPredict!);
                  _shouldSetLocalPredict = true;
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget? _screen(PredictScreenType screenType) {
    switch (screenType) {
      case PredictScreenType.beforePredict:
        return Column(children: [
          const SizedBox(height: 40),
          Text(
            "$_team1 vs $_team2",
            style: TextStyle(
              fontSize: 40,
              height: 1.0,
              fontWeight: FontWeight.w500,
              color: Colors.brown.shade900,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.brown.shade900)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "試合結果を予想する",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.brown.shade900,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.brown.shade900)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleButtonForClass(classStr: _team1),
              const SizedBox(width: 10),
              _circleButtonDraw(),
              const SizedBox(width: 10),
              _circleButtonForClass(classStr: _team2),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                const SizedBox(width: 60),
                Text(
                  "自分の予想：$_myPredict",
                  style: TextStyle(
                    color: Colors.brown.shade900,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 45,
            child: FilledButton(
              onPressed: _choosedPredict == null
                  ? null
                  : () => showDialog(
                        context: context,
                        builder: (_) {
                          return _dialog();
                        },
                      ),
              child: const Text(
                "予想を確定",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ]);
    }
  }

  Future _setlocalMyPredict() async {
    if (_shouldSetLocalPredict) {
      setState(() {
        _isLoading = true;
      });
      _localMyPredict =
          await LocalData.readLocalData<String>("myPredictOf$_gameId");
      setState(() {
        _isLoading = false;
      });
      _shouldSetLocalPredict = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit) {
      final DataToPassPredictScreen gotData =
          ModalRoute.of(context)!.settings.arguments as DataToPassPredictScreen;
      _isReverse = gotData.isReverse;
      _team1 = _isReverse ? gotData.teamMap["1"] : gotData.teamMap["0"];
      _team2 = _isReverse ? gotData.teamMap["0"] : gotData.teamMap["1"];
      _gameStatus = gotData.gameStatus;
      _gameId = gotData.gameId;

      _isInit = false;
    }
    _setlocalMyPredict();

    late PredictScreenType screenType;
    if (_gameStatus == "before") {
      if (_localMyPredict == null) {
        screenType = PredictScreenType.beforePredict;
      } else {
        screenType = PredictScreenType.afterPredict;
      }
    } else if (_gameStatus == "now") {
      screenType = PredictScreenType.afterPredict;
    } else if (_gameStatus == "after") {
      screenType = PredictScreenType.afterGame;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("予想")),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _screen(screenType),
        ),
      ),
    );
  }
}
*/