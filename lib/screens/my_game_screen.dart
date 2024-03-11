import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumutai_app/providers/picked_person_data_provider.dart';
import 'package:rumutai_app/themes/app_color.dart';

import '../providers/init_data_provider.dart';

import '../widgets/my_game_widget.dart';
import '../widgets/main_pop_up_menu.dart';

import '../local_data.dart';

class MyGameScreen extends ConsumerStatefulWidget {
  static const routeName = "/my-game-screen";

  const MyGameScreen({super.key});

  @override
  ConsumerState<MyGameScreen> createState() => _MyGameScreenState();
}

class _MyGameScreenState extends ConsumerState<MyGameScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  bool _isDirty = false;
  List<Map> _gameDataList = [];

  String? _targetPerson;

  final TextEditingController _targetPersonController = TextEditingController();

  Future _loadData() async {
    if (_isInit) {
      _targetPerson = ref.read(pickedPersonForMyGameProvider);
    }
    if (_targetPerson == "") {
      _targetPerson = null;
    }
    if ((_isInit && _targetPerson != null) || _isDirty) {
      setState(() {
        _isLoading = true;
      });
      _gameDataList = [];

      final String collection = ref.read(semesterProvider) == Semester.zenki ? "gameDataZenki" : "gameDataKouki";

      debugPrint("loadedMyGameData");
      await FirebaseFirestore.instance.collection(collection).where('referee', arrayContains: _targetPerson).get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          _gameDataList.add(doc.data() as Map);
        }
      });
      setState(() {
        _isLoading = false;
      });
      _isInit = false;
      _isDirty = false;
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

  List<Widget> _myGameListWidget({required List<Map> gameDataList}) {
    List<Widget> myGameListWidget = [];
    List day1sortedMyGameData = [];
    List day2sortedMyGameData = [];
    for (var gameData in gameDataList) {
      if (gameData["startTime"]["date"] == "1") {
        day1sortedMyGameData.add({
          "createdAt": DateTime(
            2023,
            3,
            15,
            int.parse(gameData["startTime"]["hour"]),
            int.parse(gameData["startTime"]["minute"]),
          ),
          "data": gameData
        });
      } else if (gameData["startTime"]["date"] == "2") {
        day2sortedMyGameData.add({
          "createdAt": DateTime(
            2023,
            3,
            16,
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
              color: AppColors.themeColor.shade900,
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
            color: AppColors.themeColor.shade700,
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

  Widget _dialog() {
    _targetPersonController.text = _targetPerson ?? "";
    final String currentTargetPerson = _targetPerson ?? "";
    return StatefulBuilder(builder: (context, setStateInDialog) {
      return GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: const Text("HR番号を入力"),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                SizedBox(
                  height: 55,
                  child: TextField(
                    controller: _targetPersonController,
                    decoration: const InputDecoration(
                      hintText: "例：20634",
                      label: Text("入力"),
                    ),
                    onChanged: (text) {
                      setStateInDialog(() {});
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "HR番号：${_targetPersonController.text}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            SizedBox(
              width: 140,
              height: 40,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("キャンセル"),
              ),
            ),
            SizedBox(
              width: 140,
              height: 40,
              child: FilledButton(
                onPressed: currentTargetPerson == _targetPersonController.text
                    ? null
                    : () async {
                        await LocalData.saveLocalData<String>("pickedPersonForMyGame", _targetPersonController.text);
                        await PickedPersonDataManager.setPickedPersonDataFromLocal(ref);
                        setState(() {
                          _targetPerson = _targetPersonController.text;
                          if (_targetPerson != "") {
                            _isDirty = true;
                          }
                        });
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                child: const Text("決定"),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTopSection() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.themeColor.shade100,
        border: const Border(
          bottom: BorderSide(
            color: AppColors.themeColor,
            width: 2,
          ),
        ),
      ),
      child: Center(
        child: Text(
          _targetPerson == null ? "HR番号：" : "HR番号：$_targetPerson",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: _targetPerson == null
            ? [
                const SizedBox(height: 50),
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "審判は自分が担当の試合を\n確認できます。\n\nHR番号を入力してください。",
                      style: TextStyle(
                        color: AppColors.themeColor.shade900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ]
            : _myGameListWidget(gameDataList: _gameDataList),
      ),
    );
  }

  Widget _buildBottomSection() {
    return BottomAppBar(
      height: 60,
      padding: EdgeInsets.zero,
      child: Container(
        color: AppColors.scaffoldBackgroundColor,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: FilledButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return _dialog();
              },
            );
          },
          icon: const Icon(Icons.person_search_outlined),
          label: Text(
            _targetPerson == null ? "HR番号を入力" : "HR番号を変更",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Future _onRefresh() async {
    setState(() {
      _isDirty = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("担当の試合"),
        actions: const [MainPopUpMenu()],
      ),
      body: Column(children: [
        _buildTopSection(),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _buildMiddleSection(),
                  ),
                ),
        ),
      ]),
      bottomNavigationBar: _buildBottomSection(),
    );
  }
}
