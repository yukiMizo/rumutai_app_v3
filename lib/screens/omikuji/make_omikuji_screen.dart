import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'pick_omikuji_screen.dart';

enum OmikujiCategory {
  fortune,
  oneWord,
  luckyNum,
  luckyCol,
  luckyItem,
  trivia,
  cheerMessage,
  other,
  advice,
  aboutGame,
}

class MakeOmikujiScreen extends StatefulWidget {
  static const routeName = "/make-omikuji-screen";
  const MakeOmikujiScreen({super.key});

  @override
  State<MakeOmikujiScreen> createState() => _MakeOmikujiScreenState();
}

class _MakeOmikujiScreenState extends State<MakeOmikujiScreen> {
  final TextEditingController _oneWordController = TextEditingController();
  final TextEditingController _luckyNumController = TextEditingController();
  final TextEditingController _luckyColController = TextEditingController();
  final TextEditingController _luckyItemController = TextEditingController();
  final TextEditingController _triviaController = TextEditingController();
  final TextEditingController _cheerMessageController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();
  final TextEditingController _adviceController = TextEditingController();
  final TextEditingController _aboutGameController = TextEditingController();

  final List<OmikujiCategory> _categoryListToShow = [];
  late double _insideCardWidth;

  String? _selectedFortune;

  bool _isInit = true;

  Widget _label(label) {
    return SizedBox(
      width: 120,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.brown.shade900,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _fortunePicker({required double width}) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 1,
        child: Row(
          children: [
            _label("運勢："),
            SizedBox(
              width: 100,
              child: DropdownButton(
                dropdownColor: Colors.white,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
                items: const [
                  DropdownMenuItem(
                    value: "大吉",
                    child: Text("大吉"),
                  ),
                  DropdownMenuItem(
                    value: "吉",
                    child: Text("吉"),
                  ),
                  DropdownMenuItem(
                    value: "中吉",
                    child: Text("中吉"),
                  ),
                  DropdownMenuItem(
                    value: "小吉",
                    child: Text("小吉"),
                  ),
                  DropdownMenuItem(
                    value: "末吉",
                    child: Text("末吉"),
                  ),
                  DropdownMenuItem(
                    value: "凶",
                    child: Text("凶"),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _selectedFortune = value as String;
                  });
                },
                value: _selectedFortune,
                isExpanded: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputCard({
    required String title,
    String? helperText,
    required double width,
    required OmikujiCategory category,
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 1,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.brown.shade900,
                    ),
                  ),
                  TextField(
                    controller: controller,
                    onChanged: (_) => setState(() {}),
                    maxLines: null,
                    decoration: InputDecoration(
                      helperText: helperText == null ? null : "例：$helperText",
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      border: const UnderlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
            if (category != OmikujiCategory.oneWord)
              IconButton(
                onPressed: () {
                  switch (category) {
                    case OmikujiCategory.fortune:
                      break;
                    case OmikujiCategory.oneWord:
                      break;
                    case OmikujiCategory.luckyNum:
                      _luckyNumController.text = "";
                      break;
                    case OmikujiCategory.luckyCol:
                      _luckyColController.text = "";
                      break;
                    case OmikujiCategory.luckyItem:
                      _luckyItemController.text = "";
                      break;
                    case OmikujiCategory.trivia:
                      _triviaController.text = "";
                      break;
                    case OmikujiCategory.cheerMessage:
                      _cheerMessageController.text = "";
                      break;
                    case OmikujiCategory.other:
                      _otherController.text = "";
                      break;
                    case OmikujiCategory.advice:
                      _adviceController.text = "";
                      break;
                    case OmikujiCategory.aboutGame:
                      _aboutGameController.text = "";
                      break;
                  }
                  setState(() {
                    _categoryListToShow.remove(category);
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(OmikujiCategory category) {
    switch (category) {
      case OmikujiCategory.fortune:
        return "";
      case OmikujiCategory.oneWord:
        return "一言";
      case OmikujiCategory.luckyNum:
        return "ラッキーナンバー";
      case OmikujiCategory.luckyCol:
        return "ラッキーカラー";
      case OmikujiCategory.luckyItem:
        return "ラッキーアイテム";
      case OmikujiCategory.trivia:
        return "豆知識";
      case OmikujiCategory.cheerMessage:
        return "応援メッセージ";
      case OmikujiCategory.other:
        return "その他";
      case OmikujiCategory.advice:
        return "戦略";
      case OmikujiCategory.aboutGame:
        return "試合結果";
    }
  }

  String _categoryText(OmikujiCategory category) {
    switch (category) {
      case OmikujiCategory.fortune:
        return "";
      case OmikujiCategory.oneWord:
        return "";
      case OmikujiCategory.luckyNum:
        return _luckyNumController.text;
      case OmikujiCategory.luckyCol:
        return _luckyColController.text;
      case OmikujiCategory.luckyItem:
        return _luckyItemController.text;
      case OmikujiCategory.trivia:
        return _triviaController.text;
      case OmikujiCategory.cheerMessage:
        return _cheerMessageController.text;
      case OmikujiCategory.other:
        return _otherController.text;
      case OmikujiCategory.advice:
        return _adviceController.text;
      case OmikujiCategory.aboutGame:
        return _aboutGameController.text;
    }
  }

  Widget _categoryButton({required OmikujiCategory category}) {
    return SizedBox(
      width: 150,
      child: FilledButton(
        style: FilledButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.brown.shade800,
        ),
        onPressed: _categoryListToShow.contains(category)
            ? null
            : () {
                setState(() {
                  _categoryListToShow.add(category);
                });
                Navigator.of(context).pop();
              },
        child: FittedBox(
          child: Text(
            _categoryLabel(category),
            style: TextStyle(color: Colors.brown.shade900),
          ),
        ),
      ),
    );
  }

  void _showBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.brown.shade100,
      builder: (builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                "追加するカテゴリーを選択",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.brown.shade900,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _categoryButton(category: OmikujiCategory.luckyNum),
                  const SizedBox(width: 10),
                  _categoryButton(category: OmikujiCategory.luckyCol),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _categoryButton(category: OmikujiCategory.luckyItem),
                  const SizedBox(width: 10),
                  _categoryButton(category: OmikujiCategory.trivia),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _categoryButton(category: OmikujiCategory.advice),
                  const SizedBox(width: 10),
                  _categoryButton(category: OmikujiCategory.aboutGame),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _categoryButton(category: OmikujiCategory.cheerMessage),
                  const SizedBox(width: 10),
                  _categoryButton(category: OmikujiCategory.other),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _inputCardWithCategory({
    required OmikujiCategory category,
  }) {
    switch (category) {
      case OmikujiCategory.fortune:
        return _fortunePicker(width: _insideCardWidth);
      case OmikujiCategory.oneWord:
        return _inputCard(
          controller: _oneWordController,
          width: _insideCardWidth,
          category: category,
          title: "一言",
          helperText: "・今日は絶好調！\n　　　自信を持って戦いましょう。\n　　・普段あまり話さない人と話すと\n　　　いいことあるかも？！\n　　・今日あなたはスマホを落とすでしょう",
        );
      case OmikujiCategory.luckyNum:
        return _inputCard(
          controller: _luckyNumController,
          width: _insideCardWidth,
          category: category,
          title: "ラッキーナンバー",
          helperText: "・もちろん7\n　　・あなたの誕生日",
        );
      case OmikujiCategory.luckyCol:
        return _inputCard(
          controller: _luckyColController,
          width: _insideCardWidth,
          category: category,
          title: "ラッキーカラー",
          helperText: "・スカイブルー\n　　・今着ている服の色",
        );
      case OmikujiCategory.luckyItem:
        return _inputCard(
          controller: _luckyItemController,
          width: _insideCardWidth,
          category: category,
          title: "ラッキーアイテム",
          helperText: "・タオル\n　　・ブラックサンダー",
        );
      case OmikujiCategory.trivia:
        return _inputCard(
          controller: _triviaController,
          width: _insideCardWidth,
          category: category,
          title: "豆知識",
          helperText: "・フットサルにオフサイドはない\n　　・ドッチビーは日本発祥のスポーツ",
        );
      case OmikujiCategory.cheerMessage:
        return _inputCard(
          controller: _cheerMessageController,
          width: _insideCardWidth,
          category: category,
          title: "応援メッセージ",
          helperText: "・チャンスを逃すな！　ファイト！\n　　・本気を見せてくれ！",
        );
      case OmikujiCategory.other:
        return _inputCard(
          controller: _otherController,
          width: _insideCardWidth,
          category: category,
          title: "その他",
        );
      case OmikujiCategory.advice:
        return _inputCard(
          controller: _adviceController,
          width: _insideCardWidth,
          category: category,
          title: "戦略",
          helperText: "・もっと手堅く攻めましょう\n　　・深呼吸が大事です",
        );
      case OmikujiCategory.aboutGame:
        return _inputCard(
          controller: _aboutGameController,
          width: _insideCardWidth,
          category: category,
          title: "試合結果",
          helperText: "・大差で勝てるでしょう\n　　・接戦になりそうです",
        );
    }
  }

  Widget _addButton() {
    return SizedBox(
      width: 50,
      height: 50,
      child: FloatingActionButton(
        elevation: 0,
        onPressed: () => _showBottomSheetMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _sumbitButton() {
    return SizedBox(
      height: 50,
      width: 130,
      child: ElevatedButton(
        onPressed: (_selectedFortune == null || _oneWordController.text == "")
            ? null
            : () => showDialog(
                context: context,
                builder: (_) {
                  return _dialog();
                }),
        child: const Text(
          "完成",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
    );
  }

  Widget _textForDialog({required OmikujiCategory category}) {
    late String text;
    final String title = _categoryLabel(category);
    switch (category) {
      case OmikujiCategory.fortune:
        return const SizedBox();
      case OmikujiCategory.oneWord:
        return const SizedBox();
      case OmikujiCategory.luckyNum:
        text = _luckyNumController.text;
        break;
      case OmikujiCategory.luckyCol:
        text = _luckyColController.text;
        break;
      case OmikujiCategory.luckyItem:
        text = _luckyItemController.text;
        break;
      case OmikujiCategory.trivia:
        text = _triviaController.text;
        break;
      case OmikujiCategory.cheerMessage:
        text = _cheerMessageController.text;
        break;
      case OmikujiCategory.other:
        text = _otherController.text;
        break;
      case OmikujiCategory.advice:
        text = _adviceController.text;
        break;
      case OmikujiCategory.aboutGame:
        text = _aboutGameController.text;
        break;
    }
    if (text == "") {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "YujiSyuku",
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontFamily: "YujiSyuku",
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dialog() {
    bool dialogIsLoading = false;
    return StatefulBuilder(
      builder: (context, setStateInDialog) => AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        title: const Text("確認"),
        content: SizedBox(
          height: 350,
          child: dialogIsLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: 280,
                          child: Card(
                            elevation: 1,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                            color: Colors.orange.shade50,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    _selectedFortune!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: "YujiSyuku",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        _oneWordController.text,
                                        style: const TextStyle(
                                          fontFamily: "YujiSyuku",
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                const Divider(color: Colors.brown),
                                ListView.builder(
                                  primary: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _categoryListToShow.length,
                                  itemBuilder: (context, index) {
                                    return _textForDialog(
                                      category: _categoryListToShow[index],
                                    );
                                  },
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "おみくじを投稿します",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.brown.shade900,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      "※投稿の取り消しはできません",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          if (!dialogIsLoading)
            SizedBox(
              width: 120,
              height: 40,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("キャンセル"),
              ),
            ),
          if (!dialogIsLoading)
            SizedBox(
              width: 120,
              height: 40,
              child: FilledButton(
                child: const Text("投稿"),
                onPressed: () async {
                  final List contentList = [];
                  for (var category in _categoryListToShow) {
                    final String text = _categoryText(category);
                    if (text == "") {
                      continue;
                    }
                    contentList.add({
                      "title": _categoryLabel(category),
                      "content": text,
                    });
                  }
                  final Map<String, dynamic> data = {
                    "fortune": _selectedFortune,
                    "oneWord": _oneWordController.text,
                    "content": contentList,
                  };
                  setStateInDialog(() {
                    dialogIsLoading = true;
                  });
                  await FirebaseFirestore.instance.collection('omikujiData').add(data);

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('おみくじを投稿しました。'),
                    ),
                  );
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(PickOmikujiScreen.routeName),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double outSideCardWidth = MediaQuery.of(context).size.width - 30;

    if (_isInit) {
      _insideCardWidth = outSideCardWidth - 30;
      _categoryListToShow.add(OmikujiCategory.fortune);
      _categoryListToShow.add(OmikujiCategory.oneWord);
      _isInit = false;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("おみくじ")),
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              final FocusScopeNode currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
            },
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "おみくじの作成、投稿ができます",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.brown.shade900,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  width: outSideCardWidth,
                  child: Card(
                    elevation: 2,
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 100,
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "おみくじ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.brown.shade900,
                              fontFamily: "YujiSyuku",
                            ),
                          ),
                          const SizedBox(height: 6),
                          ListView.builder(
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _categoryListToShow.length,
                            itemBuilder: (context, index) {
                              return _inputCardWithCategory(
                                category: _categoryListToShow[index],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "※個人名は入力しないでください。",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.brown.shade100,
        height: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_sumbitButton()],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [_addButton()],
            ),
          ],
        ),
      ),
    );
  }
}
