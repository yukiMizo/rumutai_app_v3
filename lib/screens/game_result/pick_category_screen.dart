import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rumutai_app/providers/game_data_provider.dart';
import 'package:rumutai_app/providers/init_data_provider.dart';
import 'package:rumutai_app/themes/app_color.dart';

import 'game_results_screen.dart';
import '../../widgets/main_pop_up_menu.dart';

class PickCategoryScreen extends ConsumerWidget {
  static const routeName = "/game-info-screen";

  const PickCategoryScreen({super.key});

  Widget _buildGameInfoButton({
    required context,
    required WidgetRef ref,
    required GameDataCategory categoryToGet,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: AppColors.themeColor.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () => Navigator.of(context).pushNamed(GameResultsScreen.routeName, arguments: categoryToGet),
      child: SizedBox(
        width: 105,
        height: 100,
        child: Column(
          children: [
            const SizedBox(height: 18),
            _getIconForCategory(ref, categoryToGet),
            const SizedBox(height: 10),
            Text(
              _getLabelForCategory(ref, categoryToGet),
              style: TextStyle(
                color: AppColors.themeColor.shade900,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                fontSize: 18,
                fontFamily: "Anton",
                shadows: const [
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    color: Colors.black38,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getLabelForCategory(WidgetRef ref, GameDataCategory gameDataCategory) {
    final SportsType sportsType = ref.watch(sportsTypeMapProvider)[gameDataCategory.asString]!;
    return sportsType.name.toUpperCase();
  }

  Widget _iconWidget(String imageAsset) {
    return Container(
      width: 40,
      height: 40,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Image.asset(imageAsset),
    );
  }

  Widget _getIconForCategory(WidgetRef ref, GameDataCategory gameDataCategory) {
    final SportsType sportsType = ref.watch(sportsTypeMapProvider)[gameDataCategory.asString]!;
    switch (sportsType) {
      case SportsType.futsal:
        return _iconWidget("assets/images/futsalball.jpg");
      case SportsType.basketball:
        return _iconWidget("assets/images/basketball.jpg");
      case SportsType.volleyball:
        return _iconWidget("assets/images/volleyball.jpg");
      case SportsType.dodgeball:
        return _iconWidget("assets/images/dodgeball.jpg");
      case SportsType.dodgebee:
        return _iconWidget("assets/images/dodgebee.jpg");
    }
  }

  Widget _build3rdGradeSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          child: Divider(),
        ),
        Text(
          "3年",
          style: TextStyle(
            fontSize: 22,
            color: AppColors.themeColor.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGameInfoButton(
              context: context,
              ref: ref,
              categoryToGet: GameDataCategory.d3,
            ),
            const SizedBox(width: 10),
            _buildGameInfoButton(
              context: context,
              ref: ref,
              categoryToGet: GameDataCategory.j3,
            ),
            const SizedBox(width: 10),
            _buildGameInfoButton(
              context: context,
              ref: ref,
              categoryToGet: GameDataCategory.k3,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("試合結果"),
        actions: const [MainPopUpMenu()],
      ),
      body: SingleChildScrollView(
        primary: true,
        child: SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 50),
              child: Column(
                children: [
                  Text(
                    "1年",
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.themeColor.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGameInfoButton(context: context, ref: ref, categoryToGet: GameDataCategory.d1),
                      const SizedBox(width: 10),
                      _buildGameInfoButton(context: context, ref: ref, categoryToGet: GameDataCategory.j1),
                      const SizedBox(width: 10),
                      _buildGameInfoButton(context: context, ref: ref, categoryToGet: GameDataCategory.k1)
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                    child: Divider(),
                  ),
                  Text(
                    "2年",
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.themeColor.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGameInfoButton(context: context, ref: ref, categoryToGet: GameDataCategory.d2),
                      const SizedBox(width: 10),
                      _buildGameInfoButton(context: context, ref: ref, categoryToGet: GameDataCategory.j2),
                      const SizedBox(width: 10),
                      _buildGameInfoButton(context: context, ref: ref, categoryToGet: GameDataCategory.k2),
                    ],
                  ),
                  if (ref.watch(show3rdGradeProvider)) _build3rdGradeSection(context, ref),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
