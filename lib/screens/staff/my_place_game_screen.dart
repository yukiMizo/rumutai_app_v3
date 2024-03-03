import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/init_data_provider.dart';

import '../../widgets/my_game_widget.dart';
import '../../widgets/main_pop_up_menu.dart';

class MyPlaceGameScreen extends ConsumerStatefulWidget {
  static const routeName = "/my-place_game-screen";

  const MyPlaceGameScreen({super.key});

  @override
  ConsumerState<MyPlaceGameScreen> createState() => _MyPlaceGameScreenState();
}

class _MyPlaceGameScreenState extends ConsumerState<MyPlaceGameScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  List<Map> _gameDataList = [];

  String? _targetPlace;

  Future _loadData() async {
    if ((_isInit && _targetPlace != null)) {
      setState(() {
        _isLoading = true;
      });
      _gameDataList = [];

      final String collection = ref.read(semesterProvider) == Semester.zenki ? "gameDataZenki" : "gameDataKouki";

      debugPrint("loadedDataForMyPlaceGameScreen");
      await FirebaseFirestore.instance.collection(collection).where('place', isEqualTo: _targetPlace).where("gameStatus", isNotEqualTo: "after").get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          _gameDataList.add(doc.data() as Map);
        }
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _dividerWithText(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          SizedBox(
              width: 40,
              child: Divider(
                thickness: 1,
                color: Colors.brown.shade800,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.brown.shade800,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.brown.shade800,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _myGameListWidget({required List<Map> gameDataList}) {
    List<Widget> myGameListWidget = [];
    List day1sortedMyGameData = [];
    List day2sortedMyGameData = [];
    for (var gameData in gameDataList) {
      if (gameData["startTime"]["date"] == "1") {
        day1sortedMyGameData.add({
          "createdAt": DateTime(
            2023,
            6,
            28,
            int.parse(gameData["startTime"]["hour"]),
            int.parse(gameData["startTime"]["minute"]),
          ),
          "data": gameData
        });
      } else if (gameData["startTime"]["date"] == "2") {
        day2sortedMyGameData.add({
          "createdAt": DateTime(
            2023,
            6,
            29,
            int.parse(gameData["startTime"]["hour"]),
            int.parse(gameData["startTime"]["minute"]),
          ),
          "data": gameData
        });
      }
    }
    if (day1sortedMyGameData.isEmpty && day2sortedMyGameData.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "試合なし",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              color: Colors.brown.shade900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ];
    }

    day1sortedMyGameData.sort((a, b) => a['createdAt'].compareTo(b['createdAt']));
    day2sortedMyGameData.sort((a, b) => a['createdAt'].compareTo(b['createdAt']));

    myGameListWidget.add(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Text(
          "※タップで詳細を確認できます。",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.brown.shade700,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );

    myGameListWidget.add(_dividerWithText("1日目"));
    for (var element in day1sortedMyGameData) {
      myGameListWidget.add(MyGameWidget(
        gameData: element["data"],
      ));
    }
    myGameListWidget.add(_dividerWithText("2日目"));
    for (var element in day2sortedMyGameData) {
      myGameListWidget.add(MyGameWidget(
        gameData: element["data"],
      ));
    }
    return myGameListWidget;
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('担当を開始しました'),
          )));
    }
    _targetPlace = ModalRoute.of(context)!.settings.arguments as String;
    _loadData();
    _isInit = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("担当の試合"),
        actions: const [MainPopUpMenu()],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.brown.shade100,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _targetPlace == null ? "担当場所：" : "担当場所：$_targetPlace",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(children: _myGameListWidget(gameDataList: _gameDataList)),
                ),
              ],
            ),
    );
  }
}
