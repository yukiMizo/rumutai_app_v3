import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumutai_app/providers/sign_in_data_provider.dart';
import 'package:rumutai_app/themes/app_color.dart';

import 'admin_edit_screen.dart';
import 'rumutai_staff_screen.dart';
import '../providers/game_data_provider.dart';

import '../utilities/lable_utilities.dart';

import '../widgets/main_pop_up_menu.dart';

class DetailScreen extends ConsumerStatefulWidget {
  static const routeName = "/detail-screen";

  const DetailScreen({super.key});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool _isExpanded = false;
  late bool _isInit = true;
  late bool _isLoading = false;

  Column _refereesAsColumn(Map gameData) {
    List<Widget> refereeList = [];
    int count = 0;
    List refereeLableList = LableUtilities.refereeLableList(gameData["sport"]);
    gameData["referee"].forEach((referee) {
      if (referee == "") {
        return;
      }
      refereeList.add(Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              referee,
              maxLines: 1,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Text(
            " ( ${refereeLableList[count]} )",
            maxLines: 1,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ));
      count++;
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: refereeList,
    );
  }

  Widget _scoreDetailPartWidget({required Map gameData, required String index, required String lable, bool isReverse = false}) {
    return SizedBox(
      width: 300,
      child: Stack(
        alignment: const Alignment(-1, 0),
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$lable：",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                height: 1.0,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  gameData["scoreDetail"][index][isReverse ? 1 : 0].toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Text(
                " - ",
                style: TextStyle(
                  fontSize: 20,
                  height: 1.0,
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  gameData["scoreDetail"][index][isReverse ? 0 : 1].toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreDetailWidget({required Map gameData, bool isReverse = false}) {
    List<String> scoreDetailLableList = LableUtilities.scoreDetailLableList(gameData["sport"]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _scoreDetailPartWidget(
          gameData: gameData,
          index: "0",
          isReverse: isReverse,
          lable: scoreDetailLableList[0],
        ),
        _scoreDetailPartWidget(
          gameData: gameData,
          index: "1",
          isReverse: isReverse,
          lable: scoreDetailLableList[1],
        ),
        if (gameData["sport"] == "volleyball" || gameData["sport"] == "basketball")
          _scoreDetailPartWidget(
            gameData: gameData,
            index: "2",
            isReverse: isReverse,
            lable: scoreDetailLableList[2],
          ),
      ],
    );
  }

  GameDataCategory? _categoryToGet(String gameDataId) {
    if (gameDataId.contains("1d")) {
      return GameDataCategory.d1;
    } else if (gameDataId.contains("1j")) {
      return GameDataCategory.j1;
    } else if (gameDataId.contains("1k")) {
      return GameDataCategory.k1;
    } else if (gameDataId.contains("2d")) {
      return GameDataCategory.d2;
    } else if (gameDataId.contains("2j")) {
      return GameDataCategory.j2;
    } else if (gameDataId.contains("2k")) {
      return GameDataCategory.k2;
    } else if (gameDataId.contains("3d")) {
      return GameDataCategory.d3;
    } else if (gameDataId.contains("3j")) {
      return GameDataCategory.j3;
    } else if (gameDataId.contains("3k")) {
      return GameDataCategory.k3;
    }
    return null;
  }

//ルム対スタッフが自分の担当のゲーム一覧からこの画面を開いた時だけロードされる。
  Future _loadData(GameDataCategory categoryToGet) async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await GameDataManager.loadGameDataForResult(gameDataCategory: categoryToGet, ref: ref);
      setState(() {
        _isLoading = false;
      });
      _isInit = false;
    }
  }

  String _sport(String sport) {
    if (sport == "futsal") {
      return "フットサル";
    } else if (sport == "volleyball") {
      return "バレーボール";
    } else if (sport == "basketball") {
      return "バスケットボール";
    } else if (sport == "dodgebee") {
      return "ドッチビー";
    } else if (sport == "dodgeball") {
      return "ドッジボール";
    }
    return "";
  }

  Widget _lable(lable) {
    return SizedBox(
      width: 100,
      child: Row(
        children: [
          Expanded(
            child: Text(
              lable,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 25),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DataToPass gotData = ModalRoute.of(context)!.settings.arguments as DataToPass;

    Map gameData = {};
    final bool isReverse = gotData.isReverse;
    if (gotData.isMyGame == true) {
      if ((GameDataManager.getGameDataByCategory(category: _categoryToGet(gotData.gameDataId)!, ref: ref)) == {}) {
        _loadData(_categoryToGet(gotData.gameDataId)!);
      } else if (!_isLoading) {
        gameData = (GameDataManager.getGameDataByCategory(category: _categoryToGet(gotData.gameDataId)!, ref: ref))[gotData.gameDataId[3]][gotData.gameDataId];
      }
    } else if (gotData.classNumber != null) {
      gameData = (GameDataManager.getGameDataByClassNumber(ref: ref, classNumber: gotData.classNumber!))[gotData.gameDataId[1]][gotData.gameDataId];
    } else {
      gameData = (GameDataManager.getGameDataByCategory(ref: ref, category: _categoryToGet(gotData.gameDataId)!))[gotData.gameDataId[3]][gotData.gameDataId];
    }
    final bool isLoggedInAdmin = ref.watch(isLoggedInAdminProvider);
    final bool isLoggedInRumutaiStaff = ref.watch(isLoggedInRumutaiStaffProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("詳細"), actions: [MainPopUpMenu(place: gameData["place"])]),
      floatingActionButton: _isLoading
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isLoggedInRumutaiStaff || isLoggedInAdmin)
                  FloatingActionButton.extended(
                    heroTag: "hero1",
                    backgroundColor: AppColors.accentColor,
                    onPressed: () => Navigator.of(context).pushNamed(
                      RumutaiStaffScreen.routeName,
                      arguments: DataToPass(
                        classNumber: gotData.classNumber,
                        gameDataId: gameData["gameId"],
                        isReverse: isReverse,
                      ),
                    ),
                    icon: const Icon(Icons.sports),
                    label: const Text("試合"),
                  ),
                if (isLoggedInAdmin) const SizedBox(height: 10),
                if (isLoggedInAdmin)
                  FloatingActionButton.extended(
                    heroTag: "hero2",
                    backgroundColor: AppColors.accentColor,
                    onPressed: () => Navigator.of(context).pushNamed(AdminEditScreen.routeName, arguments: GameDataToPassAdmin(gameData: gameData, isReverse: isReverse)),
                    icon: const Icon(Icons.edit),
                    label: const Text("編集"),
                  ),
              ],
            ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "試合結果",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    gameData["team"][isReverse ? "1" : "0"],
                                    style: const TextStyle(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 90,
                              child: Text(
                                gameData["score"][isReverse ? 1 : 0].toString(),
                                style: const TextStyle(fontSize: 45),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Text(
                              "-",
                              style: TextStyle(fontSize: 40),
                            ),
                            SizedBox(
                              width: 90,
                              child: Text(
                                gameData["score"][isReverse ? 0 : 1].toString(),
                                style: const TextStyle(fontSize: 45),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Column(
                              children: [
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    gameData["team"][isReverse ? "0" : "1"],
                                    style: const TextStyle(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Column(
                              children: [
                                if (gameData["gameStatus"] == "after")
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: !_isExpanded ? 0 : 70,
                                    curve: Curves.linearToEaseOut,
                                    child: SingleChildScrollView(
                                      child: _scoreDetailWidget(
                                        gameData: gameData,
                                        isReverse: isReverse,
                                      ),
                                    ),
                                  ),
                                if (gameData["gameStatus"] == "before")
                                  const Text(
                                    "試合前",
                                    style: TextStyle(fontSize: 16),
                                  )
                                else if (gameData["gameStatus"] == "now")
                                  Text(
                                    "試合中",
                                    style: TextStyle(
                                      color: Colors.deepPurpleAccent.shade700,
                                      fontSize: 16,
                                    ),
                                  )
                                else if (gameData["gameStatus"] == "after")
                                  Stack(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(
                                                () => _isExpanded = !_isExpanded,
                                              );
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(
                                              _isExpanded ? Icons.expand_less : Icons.expand_more,
                                            ),
                                            color: Colors.grey.shade800,
                                          ),
                                          const SizedBox(width: 15),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          if (gameData["extraTime"] != "")
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  LableUtilities.extraTimeLable(
                                                    gameData["sport"],
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    height: 1.0,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                Text(
                                                  gameData["extraTime"],
                                                  style: const TextStyle(
                                                    fontSize: 23,
                                                    height: 1.0,
                                                  ),
                                                ),
                                                const Text(
                                                  " 勝利",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          if (gameData["extraTime"] != "") const SizedBox(height: 10),
                                          const Center(
                                            child: Text(
                                              "試合終了",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                        const Divider(),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "試合情報",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                        const SizedBox(height: 35),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _lable("日時："),
                                Text(
                                  "${gameData["startTime"]["date"]}",
                                  style: const TextStyle(fontSize: 25, height: 1.0),
                                ),
                                const Text("日目　", style: TextStyle(fontSize: 16)),
                                Text(
                                  "${gameData["startTime"]["hour"]}:${gameData["startTime"]["minute"]}〜",
                                  style: const TextStyle(fontSize: 25, height: 1.0),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _lable("場所："),
                                Text("${gameData["place"]}", style: const TextStyle(fontSize: 20)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _lable("競技："),
                                Text(_sport(gameData["sport"]), style: const TextStyle(fontSize: 20)),
                              ],
                            ),
                            const SizedBox(height: 35),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _lable("審判："),
                                _refereesAsColumn(gameData),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
