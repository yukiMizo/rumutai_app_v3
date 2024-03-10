import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumutai_app/providers/init_data_provider.dart';

import '../../widgets/my_game_widget.dart';
import '../../widgets/main_pop_up_menu.dart';

class PlaceScheduleScreen extends ConsumerStatefulWidget {
  static const routeName = "/place-schedule-screen";

  const PlaceScheduleScreen({super.key});

  @override
  ConsumerState<PlaceScheduleScreen> createState() => _PlaceScheduleScreenState();
}

class _PlaceScheduleScreenState extends ConsumerState<PlaceScheduleScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  List<Map> _gameDataList = [];

  String? targetPlace;

  Future _loadData() async {
    if ((_isInit && targetPlace != null)) {
      setState(() {
        _isLoading = true;
      });
      final String collection = ref.read(semesterProvider) == Semester.zenki ? "gameDataZenki" : "gameDataKouki";
      _gameDataList = [];
      await FirebaseFirestore.instance.collection(collection).where('place', isEqualTo: targetPlace).get().then((QuerySnapshot querySnapshot) {
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

  Future _onRefresh() async {
    setState(() {
      _isInit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    targetPlace = ModalRoute.of(context)!.settings.arguments as String;
    _loadData();
    _isInit = false;

    return Scaffold(
      appBar: AppBar(
        title: Text(targetPlace!),
        actions: const [MainPopUpMenu()],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: _myGameListWidget(gameDataList: _gameDataList),
              ),
            ),
    );
  }
}
