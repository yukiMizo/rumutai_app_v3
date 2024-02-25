import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumutai_app/providers/local_data_provider.dart';

import '../widgets/my_game_widget.dart';
import '../widgets/main_pop_up_menu.dart';

import '../providers/local_data.dart';

class MyGameScreen extends ConsumerStatefulWidget {
  static const routeName = "/my-game-screen";

  const MyGameScreen({super.key});

  @override
  ConsumerState<MyGameScreen> createState() => _MyGameScreenState();
}

class _MyGameScreenState extends ConsumerState<MyGameScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  //bool _dialogIsLoading = false;
  //bool _dialogIsInit = true;
  bool _isDirty = false;
  List<Map> _gameDataList = [];

  String? _targetPerson;

  final TextEditingController _targetPersonController = TextEditingController();

  //String? _pickedPersonInDialog;
  //String? _wasPickedPersonInDialog;

  //final List<String> _nameList = [];
  // List<String> _searchedNames = [];

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
      await FirebaseFirestore.instance.collection('gameData2').where('referee', arrayContains: _targetPerson).get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          _gameDataList.add(doc.data() as Map);
        }
      });
      await FirebaseFirestore.instance.collection('gameData2').where('rumutaiStaff', isEqualTo: _targetPerson).get().then((QuerySnapshot querySnapshot) {
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

/*
  Future _loadNameList(void Function(void Function()) setStateInDialog) async {
    if (_dialogIsInit) {
      setStateInDialog(() {
        _dialogIsLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('refereesAndStaffs')
          .doc('refereesAndStaffsDoc')
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        documentSnapshot["refereesAndStaffsList"]
            .forEach((name) => _nameList.add(name));
      });
      setStateInDialog(() {
        _dialogIsLoading = false;
      });
      _dialogIsInit = false;
    }
  }*/

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

  Widget _dialog() {
    _targetPersonController.text = _targetPerson ?? "";
    final String currentTargetPerson = _targetPerson ?? "";
    return StatefulBuilder(builder: (context, setStateInDialog) {
      return GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          } /*
            setStateInDialog(() {
              _pickedPersonInDialog = null;
            });*/
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: "例：20634",
                      label: const Text("入力"),
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
                  // _searchedNames = [];
                  // _pickedPersonInDialog = null;
                  Navigator.pop(context);
                },
                child: const Text("キャンセル"),
              ),
            ),
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
                onPressed: currentTargetPerson == _targetPersonController.text
                    ? null
                    : () async {
                        /*
                            String pickedPersonInDialog =
                                _pickedPersonInDialog == null
                                    ? ""
                                    : _pickedPersonInDialog!;*/

                        await LocalData.saveLocalData<String>("pickedPersonForMyGame", _targetPersonController.text);

                        if (!mounted) return;
                        await LocalDataManager.setLoginDataFromLocal(ref);
                        setState(() {
                          _targetPerson = _targetPersonController.text;
                          if (_targetPerson != "") {
                            _isDirty = true;
                          }
                          /*
                              if (pickedPersonInDialog != "") {
                                _targetPerson = pickedPersonInDialog;
                                _isDirty = true;
                              } else {
                                _targetPerson = null;
                                _gameDataList = [];
                              }*/
                        });
                        // _wasPickedPersonInDialog = null;
                        //  _searchedNames = [];
                        //   _pickedPersonInDialog = null;
                        if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    _loadData();

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
                      _targetPerson == null ? "HR番号：" : "HR番号：$_targetPerson",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Padding(
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
                                          color: Colors.brown.shade900,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                              : _myGameListWidget(
                                  gameDataList: _gameDataList,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.brown.shade100,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: FilledButton.icon(
            onPressed: () {
              /*
                      if (_targetPerson != null) {
                        _pickedPersonInDialog = _targetPerson;
                        _wasPickedPersonInDialog = _targetPerson;
                      }*/
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
      ),
    );
  }
}
