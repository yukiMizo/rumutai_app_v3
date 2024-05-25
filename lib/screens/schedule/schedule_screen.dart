import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../themes/app_color.dart';
import '../../widgets/schedule_widget.dart';

import '../../providers/game_data_provider.dart';
import '../../widgets/main_pop_up_menu.dart';
import '../../utilities/label_utilities.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  static const routeName = "/schedule-detail-screen";

  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  late Map _gameDataForThisClass;

  Future _loadData(String classNumber) async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _gameDataForThisClass = await GameDataManager.getGameDataByClassNumber(
        classNumber: classNumber,
        ref: ref,
        load: true, //毎回ロードする
      );
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

    List<Widget> scheduleWidgetList = [];
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

    scheduleWidgetList.add(
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
    scheduleWidgetList.add(_dividerWithText("1日目"));
    for (var element in day1sortedGameData) {
      bool isReverse = false;
      if (classNumber != element["data"]["team"]["0"]) {
        isReverse = true;
      }
      scheduleWidgetList.add(ScheduleWidget(
        gameData: element["data"],
        classNumber: classNumber,
        isReverse: isReverse,
      ));
    }

    scheduleWidgetList.add(_dividerWithText("2日目"));
    for (var element in day2sortedGameData) {
      bool isReverse = false;
      if (classNumber != element["data"]["team"]["0"]) {
        isReverse = true;
      }
      scheduleWidgetList.add(ScheduleWidget(
        gameData: element["data"],
        classNumber: classNumber,
        isReverse: isReverse,
      ));
    }

    return scheduleWidgetList;
  }

  List<String> _tabStrings(String classNumber) {
    final String sport1d = LabelUtilities.gameDataCategoryToSportLabel(ref, GameDataCategory.d1);
    final String sport1j = LabelUtilities.gameDataCategoryToSportLabel(ref, GameDataCategory.j1);
    final String sport1k = LabelUtilities.gameDataCategoryToSportLabel(ref, GameDataCategory.k1);
    final String sport2d = LabelUtilities.gameDataCategoryToSportLabel(ref, GameDataCategory.d2);
    final String sport2j = LabelUtilities.gameDataCategoryToSportLabel(ref, GameDataCategory.j2);
    final String sport2k = LabelUtilities.gameDataCategoryToSportLabel(ref, GameDataCategory.k2);
    final String sport3d = LabelUtilities.gameDataCategoryToSportLabel(ref, GameDataCategory.d3);
    final String sport3j = LabelUtilities.gameDataCategoryToSportLabel(ref, GameDataCategory.j3);
    final String sport3k = LabelUtilities.gameDataCategoryToSportLabel(ref, GameDataCategory.k3);

    if (classNumber[0] == "1") {
      return [sport1d, sport1j, sport1k, "全体"];
    } else if (classNumber[0] == "2") {
      return [sport2d, sport2j, sport2k, "全体"];
    } else if (classNumber[0] == "3") {
      return [sport3d, sport3j, sport3k, "全体"];
    }
    return ["", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    final String classNumber = ModalRoute.of(context)!.settings.arguments as String;

    ref.watch(gameDataForResultProvider); //データの変更を監視

    _loadData(classNumber);
    final List<String> tabStrings = _tabStrings(classNumber);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("$classNumber スケジュール"),
          actions: const [MainPopUpMenu()],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: AppColors.lightText1.withOpacity(0.5),
            labelColor: AppColors.lightText1,
            labelPadding: const EdgeInsets.all(3),
            tabs: [
              Tab(text: tabStrings[0]),
              Tab(text: tabStrings[1]),
              Tab(text: tabStrings[2]),
              Tab(text: tabStrings[3]),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _scheduleList(classNumber: classNumber, gameData: _gameDataForThisClass["d"]),
                      ),
                    ),
                  ),
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _scheduleList(classNumber: classNumber, gameData: _gameDataForThisClass["j"]),
                      ),
                    ),
                  ),
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _scheduleList(classNumber: classNumber, gameData: _gameDataForThisClass["k"]),
                      ),
                    ),
                  ),
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        ..._scheduleList(
                          classNumber: classNumber,
                          gameData: {}
                            ..addAll(_gameDataForThisClass["d"] ?? {})
                            ..addAll(_gameDataForThisClass["j"] ?? {})
                            ..addAll(_gameDataForThisClass["k"] ?? {}),
                        ),
                        const SizedBox(height: 60),
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
