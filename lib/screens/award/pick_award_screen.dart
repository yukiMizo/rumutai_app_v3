import 'package:flutter/material.dart';

import 'game_award_screen.dart';
import 'cheer_award_screen.dart';
//import 'omikuji_award_screen.dart';

class PickAwardScreen extends StatelessWidget {
  static const routeName = "/pick-award-screen";
  const PickAwardScreen({super.key});

  Widget _tonalButton({
    required double width,
    required BuildContext context,
    required Color color,
    required String string,
    required void Function() onPressed,
    TextStyle? style,
  }) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: width,
        height: 100,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          color: color,
          child: Center(
            child: Text(
              string,
              style: style ??
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dividerWithIcon(IconData icon, double size) {
    return Container(
      width: 303,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 6),
                SizedBox(
                  child: Divider(
                    thickness: 3,
                    color: Colors.brown.shade800,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              icon,
              color: Colors.brown.shade800,
              size: size,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 6),
                SizedBox(
                  child: Divider(
                    thickness: 3,
                    color: Colors.brown.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerForCheer() {
    return Container(
      width: 303,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 6),
                SizedBox(
                  child: Divider(
                    thickness: 3,
                    color: Colors.brown.shade800,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                "assets/images/cheer.png",
                color: Colors.brown.shade700,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 6),
                SizedBox(
                  child: Divider(
                    thickness: 3,
                    color: Colors.brown.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("表彰")),
      body: Center(
        child: SizedBox(
          width: 310,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                _dividerWithIcon(Icons.scoreboard_outlined, 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _tonalButton(
                      context: context,
                      onPressed: () => Navigator.of(context).pushNamed(GameAwardScreen.routeName, arguments: "1年"),
                      width: 100,
                      color: Colors.brown.shade700,
                      string: "1年",
                    ),
                    _tonalButton(
                      context: context,
                      onPressed: () => Navigator.of(context).pushNamed(GameAwardScreen.routeName, arguments: "2年"),
                      width: 100,
                      color: Colors.brown.shade700,
                      string: "2年",
                    ),
                    _tonalButton(
                      context: context,
                      onPressed: () => Navigator.of(context).pushNamed(GameAwardScreen.routeName, arguments: "3年"),
                      width: 100,
                      color: Colors.brown.shade700,
                      string: "3年",
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                /* _dividerWithIcon(FontAwesomeIcons.wandMagic, 30),
                 _tonalButton(
                  width: 250,
                  context: context,
                  color: Colors.brown.shade700,
                  onPressed: () => Navigator.of(context).pushNamed(OmikujiAwardScreen.routeName),
                  string: "人気なおみくじ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )*/
                _dividerForCheer(),
                _tonalButton(
                  width: 250,
                  context: context,
                  color: Colors.brown.shade700,
                  onPressed: () => Navigator.of(context).pushNamed(CheerAwardScreen.routeName),
                  string: "応援数",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
