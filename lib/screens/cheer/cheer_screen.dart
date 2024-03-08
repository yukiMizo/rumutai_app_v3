import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:rumutai_app/providers/can_cheer_provider.dart';

class DataToPassCheer {
  final Color backgroundColor;
  final String classStr;
  final int currentCheerPoint;

  DataToPassCheer({
    required this.backgroundColor,
    required this.classStr,
    required this.currentCheerPoint,
  });
}

class CheerScreen extends ConsumerStatefulWidget {
  static const routeName = "/cheer-screen";
  const CheerScreen({super.key});

  @override
  ConsumerState<CheerScreen> createState() => _CheerScreenState();
}

class _CheerScreenState extends ConsumerState<CheerScreen> with TickerProviderStateMixin {
  late DatabaseReference _cheerDatabase;
  late StreamSubscription _streamSubscription;

  bool _isInit = true;
  int? _cheerPoint;
  final _random = math.Random();
  late Color _splashColor;

  late int _randomColorMaker;

  late Color _backgroundColor;
  late String _classStr;

  void _incrementCount(String classStr) async {
    await _cheerDatabase.update({classStr: ServerValue.increment(1)});
  }

  void _onCheerPointChanged(DatabaseEvent event) {
    _cheerPoint = (event.snapshot.value ?? 0) as int;
    setState(() {});
  }

  void _setRandomSplashColor() {
    int r = _random.nextInt(101);
    int g = _random.nextInt(101);
    int b = _random.nextInt(101);
    final o = _random.nextDouble() * 0.4 + 0.5;

    if (_randomColorMaker % 3 == 0) {
      r = 255;
      if (_randomColorMaker == 3) {
        g += 50;
      } else {
        b += 50;
      }
    } else if (_randomColorMaker % 3 == 1) {
      g = 255;
      if (_randomColorMaker == 1) {
        r += 50;
      } else {
        b += 50;
      }
    } else if (_randomColorMaker % 3 == 2) {
      b = 255;
      if (_randomColorMaker == 2) {
        g += 50;
      } else {
        r += 50;
      }
    }

    _splashColor = Color.fromRGBO(r, g, b, o);
  }

  @override
  void deactivate() {
    _streamSubscription.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit) {
      final DataToPassCheer gotData = ModalRoute.of(context)!.settings.arguments as DataToPassCheer;
      _backgroundColor = gotData.backgroundColor;
      _classStr = gotData.classStr;
      _cheerPoint = gotData.currentCheerPoint;
      _cheerDatabase = FirebaseDatabase.instance.ref("cheer");
      _streamSubscription = _cheerDatabase.child(_classStr).onValue.listen(_onCheerPointChanged);
      _randomColorMaker = _random.nextInt(6);
      _setRandomSplashColor();
      _isInit = false;
    }
    final bool canCheer = ref.watch(canCheerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("応援")),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 3,
                  left: 3,
                  right: 3,
                ),
                child: Hero(
                  tag: "card$_classStr",
                  child: Card(
                    color: _backgroundColor,
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        if (canCheer) {
                          _incrementCount(_classStr);
                          setState(() {
                            _setRandomSplashColor();
                          });
                        } else {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("応援機能停止中です")),
                          );
                        }
                      },
                      splashColor: _splashColor,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                          bottom: 8,
                          left: 15,
                          right: 15,
                        ),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Text(
                              _classStr,
                              style: TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.shade900,
                              ),
                            ),
                            const SizedBox(height: 30),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      width: 55,
                                      height: 55,
                                      child: Image.asset(
                                        "assets/images/cheer.png",
                                        color: Colors.deepOrange.shade900,
                                      ),
                                    ),
                                  ),
                                  _cheerPoint == null
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(),
                                        )
                                      : Text(
                                          _cheerPoint.toString(),
                                          style: TextStyle(
                                            color: Colors.brown.shade900,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                  const SizedBox(width: 6),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "画面をタップして応援！",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.brown.shade900,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "※応援の数はリアルタイムで更新されます。",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
