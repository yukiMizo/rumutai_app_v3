import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../themes/app_color.dart';
import '../../widgets/schedule_widget.dart';

import '../../providers/game_data_provider.dart';
import '../../widgets/main_pop_up_menu.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  static const routeName = "/schedule-detail-screen";

  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  late Map _gameData;

  Future _loadData(String classNumber) async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await GameDataManager.loadGameDataForSchedule(classNumber: classNumber, ref: ref);
      setState(() {
        _isLoading = false;
      });
      _isInit = false;
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
                color: AppColors.themeColor.shade800,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.themeColor.shade800,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: AppColors.themeColor.shade800,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _scheduleList({
    required String classNumber,
    required Map? gameData,
  }) {
    if (gameData == null) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "試合なし",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.themeColor.shade900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ];
    }

    List<Widget> scheduleList = [];
    List day1sortedGameData = [];
    List day2sortedGameData = [];
    gameData.forEach((gameId, data) {
      if (data["startTime"]["date"] == "1") {
        day1sortedGameData.add({
          "createdAt": DateTime(
            2023,
            3,
            15,
            int.parse(data["startTime"]["hour"]),
            int.parse(data["startTime"]["minute"]),
          ),
          "data": data
        });
      } else if (data["startTime"]["date"] == "2") {
        day2sortedGameData.add({
          "createdAt": DateTime(
            2023,
            3,
            16,
            int.parse(data["startTime"]["hour"]),
            int.parse(data["startTime"]["minute"]),
          ),
          "data": data
        });
      }
    });

    if (day1sortedGameData.isEmpty && day2sortedGameData.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "試合なし",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.themeColor.shade900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ];
    }
    day1sortedGameData.sort((a, b) => a['createdAt'].compareTo(b['createdAt']));
    day2sortedGameData.sort((a, b) => a['createdAt'].compareTo(b['createdAt']));

    scheduleList.add(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Text(
          "※タップで詳細を確認できます。",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.themeColor.shade700,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
    scheduleList.add(_dividerWithText("1日目"));
    for (var element in day1sortedGameData) {
      bool isReverse = false;
      if (classNumber != element["data"]["team"]["0"]) {
        isReverse = true;
      }
      scheduleList.add(ScheduleWidget(
        gameData: element["data"],
        classNumber: classNumber,
        isReverse: isReverse,
      ));
    }

    scheduleList.add(_dividerWithText("2日目"));
    for (var element in day2sortedGameData) {
      bool isReverse = false;
      if (classNumber != element["data"]["team"]["0"]) {
        isReverse = true;
      }
      scheduleList.add(ScheduleWidget(
        gameData: element["data"],
        classNumber: classNumber,
        isReverse: isReverse,
      ));
    }

    return scheduleList;
  }

//not flexible
  List<String> _tabStrings(String classNumber) {
    if (classNumber[0] == "1") {
      return ["フットサル", "バレーボール", "ドッジボール", "全体"];
    } else if (classNumber[0] == "2") {
      return ["フットサル", "バスケットボール", "バレーボール", "全体"];
    } else if (classNumber[0] == "3") {
      return ["フットサル", "ドッジビー", "バレーボール", "全体"];
    }
    return ["", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    final String classNumber = ModalRoute.of(context)!.settings.arguments as String;
    _loadData(classNumber);
    final List<String> tabStrings = _tabStrings(classNumber);

    if (!_isLoading) {
      _gameData = GameDataManager.getGameDataByClassNumber(ref: ref, classNumber: classNumber);
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("$classNumber　スケジュール"),
          actions: const [MainPopUpMenu()],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.lightText1,
            unselectedLabelColor: AppColors.lightText1,
            labelColor: AppColors.lightText1,
            isScrollable: true,
            tabs: [
              Tab(text: tabStrings[0]),
              Tab(text: tabStrings[1]),
              Tab(text: tabStrings[2]),
              Tab(text: tabStrings[3]),
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _scheduleList(classNumber: classNumber, gameData: _gameData["d"]),
                      ),
                    ),
                  ),
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _scheduleList(classNumber: classNumber, gameData: _gameData["j"]),
                      ),
                    ),
                  ),
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _scheduleList(classNumber: classNumber, gameData: _gameData["k"]),
                      ),
                    ),
                  ),
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _scheduleList(
                          classNumber: classNumber,
                          gameData: {}
                            ..addAll(_gameData["d"])
                            ..addAll(_gameData["j"])
                            ..addAll(_gameData["k"]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
