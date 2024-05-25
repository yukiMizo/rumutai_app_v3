import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../themes/app_color.dart';

import '../../providers/can_cheer_provider.dart';
import '../../providers/init_data_provider.dart';
import '../../providers/sign_in_data_provider.dart';

import 'cheer_screen.dart';

class PickTeamToCheerScreen extends ConsumerStatefulWidget {
  static const routeName = "/pick-team-to-cheer-screen";

  const PickTeamToCheerScreen({super.key});

  @override
  ConsumerState<PickTeamToCheerScreen> createState() => _PickTeamToCheerScreenState();
}

class _PickTeamToCheerScreenState extends ConsumerState<PickTeamToCheerScreen> {
  final _cheerPointMap = {};
  bool _isInit = true;
  List _topCheerPointClassList = [];

  bool _dialogIsLoading = false;

  Widget _teamToCheerWidget({
    required BuildContext context,
    required String classStr,
    required Color color,
    required int? cheerPoint,
  }) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(CheerScreen.routeName,
              arguments: DataToPassCheer(
                backgroundColor: color,
                classStr: classStr,
                currentCheerPoint: cheerPoint ?? 0,
              ))
          .then((_) {
        setState(() {
          _isInit = true;
        });
      }),
      child: Hero(
        tag: "card$classStr",
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    classStr,
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.brown.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_topCheerPointClassList.contains(classStr))
                          const Padding(
                            padding: EdgeInsets.only(right: 3),
                            child: Icon(
                              FontAwesomeIcons.crown,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: SizedBox(
                            width: 23,
                            height: 23,
                            child: Image.asset(
                              "assets/images/cheer.png",
                              color: Colors.deepOrange.shade900,
                            ),
                          ),
                        ),
                        Text(
                          cheerPoint == null ? "-" : cheerPoint.toString(),
                          style: TextStyle(
                            color: Colors.brown.shade900,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
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

  Widget _coloredCard({required Color color}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: color,
    );
  }

  Widget _coloredCardWithText({required Color color, required String text}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 25,
            color: Colors.brown.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

/*
  Widget _coloredCardWithIcon({required Color color, required IconData icon}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: color,
      child: Center(
        child: Icon(
          icon,
          size: 45,
          color: Colors.brown.shade900,
        ),
      ),
    );
  }
*/
  Future _onRefresh() async {
    setState(() {
      _isInit = true;
    });
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => showDialog(
          context: context,
          builder: (_) {
            final bool canCheer = ref.read(canCheerProvider);
            return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                title: const Text("確認"),
                content: SizedBox(
                  height: 100,
                  child: _dialogIsLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: Text(
                            canCheer ? "応援を一時停止する" : "応援を再開する",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  if (!_dialogIsLoading)
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("キャンセル"),
                      ),
                    ),
                  if (!_dialogIsLoading)
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: FilledButton(
                        child: Text(canCheer ? "停止" : "再会"),
                        onPressed: () async {
                          setState(() {
                            _dialogIsLoading = true;
                          });
                          if (canCheer) {
                            await FirebaseDatabase.instance.ref("cheer").update({"canCheer": false});
                            ref.read(canCheerProvider.notifier).state = false;
                          } else {
                            await FirebaseDatabase.instance.ref("cheer").update({"canCheer": true});
                            ref.read(canCheerProvider.notifier).state = true;
                          }
                          _dialogIsLoading = false;
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                canCheer ? "応援を停止しました" : "応援を再開しました",
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                ],
              ),
            );
          }),
      label: Text(ref.watch(canCheerProvider) ? "停止" : "再開"),
      icon: Icon(ref.watch(canCheerProvider) ? Icons.pause : Icons.play_arrow),
      backgroundColor: AppColors.accentColor,
    );
  }

  Future<void> _loadData() async {
    late bool canCheer;
    debugPrint("loadedCheerData2");
    await FirebaseDatabase.instance.ref("cheer").get().then((data) {
      final dataMap = data.value as Map;
      canCheer = dataMap["canCheer"];
      dataMap.remove("canCheer");
      int maxCheerPoint1 = 0;
      int maxCheerPoint2 = 0;
      int maxCheerPoint3 = 0;
      dataMap.forEach((classStr, cheerPoint) {
        cheerPoint ??= 0;
        if (classStr[0] == "1") {
          if (cheerPoint > maxCheerPoint1) {
            maxCheerPoint1 = cheerPoint;
          }
        } else if (classStr[0] == "2") {
          if (cheerPoint > maxCheerPoint2) {
            maxCheerPoint2 = cheerPoint;
          }
        } else {
          if (cheerPoint > maxCheerPoint3) {
            maxCheerPoint3 = cheerPoint;
          }
        }
        _cheerPointMap[classStr] = cheerPoint;
      });
      _topCheerPointClassList = [];
      _cheerPointMap.forEach((classStr, cheerPoint) {
        if (classStr[0] == "1") {
          if (cheerPoint == maxCheerPoint1) {
            _topCheerPointClassList.add(classStr);
          }
        } else if (classStr[0] == "2") {
          if (cheerPoint == maxCheerPoint2) {
            _topCheerPointClassList.add(classStr);
          }
        } else {
          if (cheerPoint == maxCheerPoint3) {
            _topCheerPointClassList.add(classStr);
          }
        }
      });
    });
    ref.read(canCheerProvider.notifier).state = canCheer;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit) {
      _loadData();
      _isInit = false;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("応援")),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                ref.watch(canCheerProvider) ? "応援するクラスをタップ！" : "現在応援機能は停止中です",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.brown.shade900,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GridView.count(
                primary: true,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  _coloredCardWithText(text: "1年", color: Colors.brown.shade100),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "101",
                    color: Colors.brown.shade200,
                    cheerPoint: _cheerPointMap["101"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "102",
                    color: Colors.brown.shade300,
                    cheerPoint: _cheerPointMap["102"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "103",
                    color: Colors.brown.shade100,
                    cheerPoint: _cheerPointMap["103"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "104",
                    color: Colors.brown.shade200,
                    cheerPoint: _cheerPointMap["104"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "105",
                    color: Colors.brown.shade300,
                    cheerPoint: _cheerPointMap["105"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "106",
                    color: Colors.brown.shade100,
                    cheerPoint: _cheerPointMap["106"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "107",
                    color: Colors.brown.shade200,
                    cheerPoint: _cheerPointMap["107"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "108",
                    color: Colors.brown.shade300,
                    cheerPoint: _cheerPointMap["108"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "109",
                    color: Colors.brown.shade100,
                    cheerPoint: _cheerPointMap["109"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "110",
                    color: Colors.brown.shade200,
                    cheerPoint: _cheerPointMap["110"],
                  ),
                  _coloredCard(color: Colors.brown.shade300),
                ],
              ),
              GridView.count(
                primary: true,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  _coloredCardWithText(text: "2年", color: Colors.brown.shade300),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "201",
                    color: Colors.brown.shade200,
                    cheerPoint: _cheerPointMap["201"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "202",
                    color: Colors.brown.shade100,
                    cheerPoint: _cheerPointMap["202"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "203",
                    color: Colors.brown.shade300,
                    cheerPoint: _cheerPointMap["203"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "204",
                    color: Colors.brown.shade200,
                    cheerPoint: _cheerPointMap["204"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "205",
                    color: Colors.brown.shade100,
                    cheerPoint: _cheerPointMap["205"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "206",
                    color: Colors.brown.shade300,
                    cheerPoint: _cheerPointMap["206"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "207",
                    color: Colors.brown.shade200,
                    cheerPoint: _cheerPointMap["207"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "208",
                    color: Colors.brown.shade100,
                    cheerPoint: _cheerPointMap["208"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "209",
                    color: Colors.brown.shade300,
                    cheerPoint: _cheerPointMap["209"],
                  ),
                  _teamToCheerWidget(
                    context: context,
                    classStr: "210",
                    color: Colors.brown.shade200,
                    cheerPoint: _cheerPointMap["210"],
                  ),
                  _coloredCard(color: Colors.brown.shade100),
                  /*_coloredCardWithIcon(
                      color: Colors.brown.shade300,
                      icon: Icons.campaign_outlined,
                    ),*/
                ],
              ),
              if (ref.watch(show3rdGradeProvider))
                GridView.count(
                  primary: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  crossAxisCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    _coloredCardWithText(text: "3年", color: Colors.brown.shade100),
                    _teamToCheerWidget(
                      context: context,
                      classStr: "301",
                      color: Colors.brown.shade200,
                      cheerPoint: _cheerPointMap["301"],
                    ),
                    _teamToCheerWidget(
                      context: context,
                      classStr: "302",
                      color: Colors.brown.shade300,
                      cheerPoint: _cheerPointMap["302"],
                    ),
                    _teamToCheerWidget(
                      context: context,
                      classStr: "303",
                      color: Colors.brown.shade100,
                      cheerPoint: _cheerPointMap["303"],
                    ),
                    _teamToCheerWidget(
                      context: context,
                      classStr: "304",
                      color: Colors.brown.shade200,
                      cheerPoint: _cheerPointMap["304"],
                    ),
                    _teamToCheerWidget(
                      context: context,
                      classStr: "305",
                      color: Colors.brown.shade300,
                      cheerPoint: _cheerPointMap["305"],
                    ),
                    _teamToCheerWidget(
                      context: context,
                      classStr: "306",
                      color: Colors.brown.shade100,
                      cheerPoint: _cheerPointMap["306"],
                    ),
                    _teamToCheerWidget(
                      context: context,
                      classStr: "307",
                      color: Colors.brown.shade200,
                      cheerPoint: _cheerPointMap["307"],
                    ),
                    _teamToCheerWidget(
                      context: context,
                      classStr: "308",
                      color: Colors.brown.shade300,
                      cheerPoint: _cheerPointMap["308"],
                    ),
                    _teamToCheerWidget(
                      context: context,
                      classStr: "309",
                      color: Colors.brown.shade100,
                      cheerPoint: _cheerPointMap["309"],
                    ),
                    _teamToCheerWidget(
                      context: context,
                      classStr: "310",
                      color: Colors.brown.shade200,
                      cheerPoint: _cheerPointMap["310"],
                    ),
                    _coloredCard(color: Colors.brown.shade300),
                  ],
                ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButton: ref.watch(isLoggedInAdminProvider) ? _buildFAB() : null,
    );
  }
}
