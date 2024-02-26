import 'package:flutter/material.dart';

import '../../screens/detail_screen.dart';
import '../../providers/game_data_provider.dart';

class TournamentButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Map gameData;
  const TournamentButton({
    super.key,
    required this.text,
    required this.gameData,
    required this.width,
    required this.height,
  });
  @override
  Widget build(BuildContext context) {
    late Color textColor;
    if (text == "試合中") {
      textColor = Colors.deepPurpleAccent.shade700;
    } else if (text == "試合終了") {
      textColor = Colors.red.shade800;
    } else {
      textColor = Colors.black;
    }

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
        ),
        onPressed: () => Navigator.of(context).pushNamed(
          DetailScreen.routeName,
          arguments: GameDataToPass(gameDataId: gameData["gameId"]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
