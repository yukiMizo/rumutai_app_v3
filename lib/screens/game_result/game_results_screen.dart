import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../themes/app_color.dart';
import '../../widgets/league/league_widget.dart';
import '../../widgets/tournament/tournament_widget.dart';

import '../../providers/game_data_provider.dart';
import '../../widgets/main_pop_up_menu.dart';

class GameResultsScreen extends ConsumerStatefulWidget {
  static const routeName = "/game-info-detail-screen";

  const GameResultsScreen({super.key});

  @override
  ConsumerState<GameResultsScreen> createState() => _GameResultsScreenState();
}

class _GameResultsScreenState extends ConsumerState<GameResultsScreen> {
  late bool _isInit = true;
  late bool _isLoading;
  late Map _gameDataForThisCategory;

  Future _loadData(GameDataCategory gameDataCategory) async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _gameDataForThisCategory = await GameDataManager.getGameDataByCategory(
        category: gameDataCategory,
        ref: ref,
        load: true, //毎回ロードする
      );
      setState(() {
        _isLoading = false;
      });
      _isInit = false;
    }
  }

//not flexible
  String _title(GameDataCategory gameInfoDetail) {
    switch (gameInfoDetail) {
      case GameDataCategory.d1:
        return "1年　男子　フットサル";
      case GameDataCategory.j1:
        return "1年　女子　バレー";
      case GameDataCategory.k1:
        return "1年　混合　ドッジボール";
      case GameDataCategory.d2:
        return "2年　男子　フットサル";
      case GameDataCategory.j2:
        return "2年　女子　バスケット";
      case GameDataCategory.k2:
        return "2年　混合　バレー";
      case GameDataCategory.d3:
        return "3年　男子　フットサル";
      case GameDataCategory.j3:
        return "3年　女子　ドッジビー";
      case GameDataCategory.k3:
        return "3年　混合　バレー";
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryToGet = ModalRoute.of(context)!.settings.arguments;

    ref.watch(gameDataForResultProvider); //データの変更を監視
    _loadData(categoryToGet as GameDataCategory);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title(categoryToGet)),
          actions: const [MainPopUpMenu()],
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.lightText1,
            unselectedLabelColor: AppColors.lightText1,
            labelColor: AppColors.lightText1,
            tabs: [
              Tab(text: "リーグ"),
              Tab(text: "トーナメント"),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: InteractiveViewer(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                LeagueWidget(
                                  title: "リーグA",
                                  leagueData: _gameDataForThisCategory["a"],
                                ),
                                const SizedBox(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 5),
                                    child: Divider(),
                                  ),
                                ),
                                LeagueWidget(
                                  title: "リーグB",
                                  leagueData: _gameDataForThisCategory["b"],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: InteractiveViewer(
                        child: Card(
                          child: Column(
                            children: [
                              TournamentWidget(
                                title: "決勝",
                                tournamentData: _gameDataForThisCategory["f"],
                              ),
                              if (categoryToGet == GameDataCategory.d2 || categoryToGet == GameDataCategory.d3)
                                Column(
                                  children: [
                                    const SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Divider(),
                                      ),
                                    ),
                                    TournamentWidget(
                                      title: "下位",
                                      tournamentData: _gameDataForThisCategory["l"],
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                            ],
                          ),
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
