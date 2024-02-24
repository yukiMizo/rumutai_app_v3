import 'package:flutter/material.dart';

import 'tournament_button.dart';

enum WinTeam { left, right, none }

enum LineSide { left, right, middle }

enum SeedBlockSide { left, right }

class TournamentBlock {
  static const double lineWeight = 3;
  static Color normalLineColor = Colors.grey.shade800;

  static Widget _verLine({required double length, required Color color}) {
    return SizedBox(
      height: length,
      child: VerticalDivider(
          thickness: lineWeight, width: lineWeight, color: color),
    );
  }

  static Widget _horLine({required double length, required Color color}) {
    return SizedBox(
      width: length,
      child: Divider(thickness: lineWeight, height: lineWeight, color: color),
    );
  }

  static String _gameStatusText(Map gameData) {
    if (gameData["gameStatus"] == "before") {
      return "${gameData["startTime"]["hour"]}:${gameData["startTime"]["minute"]}〜\n${gameData["place"]}";
    } else if (gameData["gameStatus"] == "now") {
      return "試合中";
    } else if (gameData["gameStatus"] == "after") {
      return "試合終了";
    }
    return "";
  }

  static WinTeam _winTeam(Map gameData) {
    if (gameData["gameStatus"] == "after") {
      if (gameData["score"][0] > gameData["score"][1]) {
        return WinTeam.left;
      } else if (gameData["score"][0] < gameData["score"][1]) {
        return WinTeam.right;
      } else if (gameData["team"]["0"] == gameData["extraTime"]) {
        return WinTeam.left;
      } else if (gameData["team"]["1"] == gameData["extraTime"]) {
        return WinTeam.right;
      }
    }
    return WinTeam.none;
  }

  static Color _lineColor({
    required LineSide lineSide,
    required WinTeam winTeam,
  }) {
    if (winTeam == WinTeam.left && lineSide == LineSide.left) {
      return Colors.red;
    } else if (winTeam == WinTeam.right && lineSide == LineSide.right) {
      return Colors.red;
    } else if (winTeam != WinTeam.none && lineSide == LineSide.middle) {
      return Colors.red;
    } else {
      return normalLineColor;
    }
  }

  static Widget _switchHorLine({
    required WinTeam winTeam,
    required double width,
  }) {
    switch (winTeam) {
      case WinTeam.left:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _horLine(length: (width + lineWeight) / 2, color: Colors.red),
            const SizedBox(width: lineWeight),
            _horLine(
                length: (width + lineWeight) / 2 - (lineWeight * 2),
                color: normalLineColor),
          ],
        );
      case WinTeam.right:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _horLine(
                length: (width + lineWeight) / 2 - (lineWeight * 2),
                color: normalLineColor),
            const SizedBox(width: lineWeight),
            _horLine(length: (width + lineWeight) / 2, color: Colors.red),
          ],
        );
      case WinTeam.none:
        return _horLine(length: width, color: normalLineColor);
    }
  }

  static Widget normal({
    required double armHeight,
    required double handHeight,
    required double width,
    required Map gameData,
    required double buttonHeight,
    double? spaceHeight,
    double? otherHeight,
  }) {
    final WinTeam winTeam = _winTeam(gameData);

    return Column(
      children: [
        _verLine(
          length: armHeight,
          color: _lineColor(
            lineSide: LineSide.middle,
            winTeam: winTeam,
          ),
        ),
        _switchHorLine(winTeam: winTeam, width: width),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _verLine(
              length: handHeight,
              color: _lineColor(
                lineSide: LineSide.left,
                winTeam: winTeam,
              ),
            ),
            TournamentButton(
              width: width - (lineWeight * 2),
              height: buttonHeight,
              text: _gameStatusText(gameData),
              gameData: gameData,
            ),
            _verLine(
              length: handHeight,
              color: _lineColor(
                lineSide: LineSide.right,
                winTeam: winTeam,
              ),
            ),
          ],
        ),
        if (spaceHeight != null) SizedBox(height: spaceHeight),
        if (otherHeight != null)
          _verLine(
            length: otherHeight,
            color: _lineColor(
              lineSide: LineSide.middle,
              winTeam: winTeam,
            ),
          ),
      ],
    );
  }

  static Widget cover({
    required double height,
    required double width,
    required Map gameData,
    required double buttonHeight,
    bool isDown = false,
  }) {
    final WinTeam winTeam = _winTeam(gameData);

    return Column(
      children: [
        if (isDown)
          TournamentButton(
            width: width - (lineWeight * 2),
            height: buttonHeight,
            text: _gameStatusText(gameData),
            gameData: gameData,
          )
        else
          _verLine(
            length: height,
            color: _lineColor(
              lineSide: LineSide.middle,
              winTeam: winTeam,
            ),
          ),
        _switchHorLine(winTeam: winTeam, width: width),
        if (!isDown)
          TournamentButton(
            width: width - (lineWeight * 2),
            height: buttonHeight,
            text: _gameStatusText(gameData),
            gameData: gameData,
          )
        else
          _verLine(
            length: height,
            color: _lineColor(
              lineSide: LineSide.middle,
              winTeam: winTeam,
            ),
          ),
      ],
    );
  }

  static Widget seed({
    required double armHeight,
    required double fingerHeight,
    required double width,
    required SeedBlockSide seedBlockSide,
    required Map gameData,
    required double buttonHeight,
  }) {
    final WinTeam winTeam = _winTeam(gameData);

    return Column(
      children: [
        _verLine(
          length: armHeight,
          color: _lineColor(
            lineSide: LineSide.middle,
            winTeam: winTeam,
          ),
        ),
        _switchHorLine(winTeam: winTeam, width: width),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (seedBlockSide == SeedBlockSide.left)
              _verLine(
                length: fingerHeight,
                color: _lineColor(
                  lineSide: LineSide.left,
                  winTeam: winTeam,
                ),
              )
            else
              const SizedBox(width: lineWeight),
            TournamentButton(
              width: width - (lineWeight * 2),
              height: buttonHeight,
              text: _gameStatusText(gameData),
              gameData: gameData,
            ),
            if (seedBlockSide == SeedBlockSide.right)
              _verLine(
                length: fingerHeight,
                color: _lineColor(
                  lineSide: LineSide.right,
                  winTeam: winTeam,
                ),
              )
            else
              const SizedBox(width: lineWeight),
          ],
        ),
      ],
    );
  }
}
