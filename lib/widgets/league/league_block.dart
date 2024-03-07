import 'package:flutter/material.dart';

import '../../providers/game_data_provider.dart';
import '../../screens/detail_screen.dart';

enum Block { text, win, lose, tie, none }

class LeagueBlock extends StatelessWidget {
  final String? text;
  final Block block;
  final Map? gameData;
  final double blockSize;
  final bool isReverse;
  final bool? doShade;
  final Color? textColor;

  const LeagueBlock({
    super.key,
    required this.block,
    this.text = "",
    this.textColor,
    this.gameData,
    required this.blockSize,
    this.isReverse = false,
    this.doShade = false,
  });

  @override
  Widget build(BuildContext context) {
    switch (block) {
      case Block.text:
        if (gameData == null) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.brown.shade100,
            ),
            child: Center(
              child: SizedBox(
                width: blockSize,
                height: blockSize,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: FittedBox(
                    child: Text(
                      text!,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                DetailScreen.routeName,
                arguments: GameDataToPass(gameDataId: gameData!["gameId"], isReverse: isReverse),
              );
            },
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: Center(
                child: SizedBox(
                  width: blockSize,
                  height: blockSize,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: FittedBox(
                        child: Text(
                      text!,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ),
                ),
              ),
            ),
          );
        }
      case Block.win:
        return InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            DetailScreen.routeName,
            arguments: GameDataToPass(gameDataId: gameData!["gameId"], isReverse: isReverse),
          ),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset("assets/images/win_image.png"),
            ),
          ),
        );
      case Block.lose:
        return InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            DetailScreen.routeName,
            arguments: GameDataToPass(gameDataId: gameData!["gameId"], isReverse: isReverse),
          ),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset("assets/images/lose_image.png"),
            ),
          ),
        );
      case Block.tie:
        return InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            DetailScreen.routeName,
            arguments: GameDataToPass(gameDataId: gameData!["gameId"], isReverse: isReverse),
          ),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset("assets/images/tie_image.png"),
            ),
          ),
        );
      case Block.none:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: doShade == true ? Colors.brown.shade100 : null,
          ),
          child: Image.asset("assets/images/none_image.png"),
        );
      default:
        return Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: const Center(child: Text("")),
        );
    }
  }
}
