import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../widgets/league/league_widget.dart';
import '../../widgets/tournament/tournament_widget.dart';

import '../../providers/game_data.dart';
import '../../widgets/main_pop_up_menu.dart';

class GameResultsScreen extends StatefulWidget {
  static const routeName = "/game-info-detail-screen";

  const GameResultsScreen({super.key});

  @override
  State<GameResultsScreen> createState() => _GameResultsScreenState();
}

class _GameResultsScreenState extends State<GameResultsScreen> {
  late bool _isInit = true;
  late bool _isLoading;
  late Map _gameDataAll;

  Future _loadData(CategoryToGet categoryToGet) async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<GameData>(context, listen: false).loadGameDataForResult(categoryToGet: categoryToGet);
      setState(() {
        _isLoading = false;
      });
      _isInit = false;
    }
  }

//not flexible
  String _title(CategoryToGet gameInfoDetail) {
    switch (gameInfoDetail) {
      case CategoryToGet.d1:
        return "1年　男子　フットサル";
      case CategoryToGet.j1:
        return "1年　女子　バレー";
      case CategoryToGet.k1:
        return "1年　混合　ドッジボール";
      case CategoryToGet.d2:
        return "2年　男子　フットサル";
      case CategoryToGet.j2:
        return "2年　女子　バスケット";
      case CategoryToGet.k2:
        return "2年　混合　バレー";
      case CategoryToGet.d3:
        return "3年　男子　フットサル";
      case CategoryToGet.j3:
        return "3年　女子　ドッジビー";
      case CategoryToGet.k3:
        return "3年　混合　バレー";
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryToGet = ModalRoute.of(context)!.settings.arguments;
    _loadData(categoryToGet as CategoryToGet);

    if (!_isLoading) {
      _gameDataAll = Provider.of<GameData>(context).getGameDataForResult(categoryToGet: categoryToGet) as Map;
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title(categoryToGet)),
          actions: const [MainPopUpMenu()],
          bottom: const TabBar(indicatorColor: Colors.white, tabs: [
            Tab(text: "リーグ"),
            Tab(text: "トーナメント"),
          ]),
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
                                  leagueData: _gameDataAll["a"],
                                ),
                                const SizedBox(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 5),
                                    child: Divider(),
                                  ),
                                ),
                                LeagueWidget(
                                  title: "リーグB",
                                  leagueData: _gameDataAll["b"],
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
                                tournamentData: _gameDataAll["f"],
                              ),
                              if (categoryToGet == CategoryToGet.d2 || categoryToGet == CategoryToGet.d3)
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
                                      tournamentData: _gameDataAll["l"],
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
