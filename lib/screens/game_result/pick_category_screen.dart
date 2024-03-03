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
              style: TextStyle(color: Colors.brown.shade900, fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 18, fontFamily: "Anton"),
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

  Widget _getIconForCategory(WidgetRef ref, GameDataCategory gameDataCategory) {
    final SportsType sportsType = ref.watch(sportsTypeMapProvider)[gameDataCategory.asString]!;
    switch (sportsType) {
      case SportsType.futsal:
        return Icon(
          Icons.sports_soccer_outlined,
          size: 40,
          color: Colors.brown.shade900,
        );
      case SportsType.basketball:
        return Icon(
          Icons.sports_basketball_outlined,
          size: 40,
          color: Colors.brown.shade900,
        );
      case SportsType.volleyball:
        return Icon(
          Icons.sports_volleyball_outlined,
          size: 40,
          color: Colors.brown.shade900,
        );
      case SportsType.dodgeball:
        return Icon(
          Icons.sports_volleyball_outlined,
          size: 40,
          color: Colors.brown.shade900,
        );
      case SportsType.dodgebee:
        return Column(
          children: [
            Image.asset(
              "assets/images/frisbee_icon.png",
              scale: 12.6,
              color: Colors.brown.shade900,
            ),
          ],
        );
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
        title: const Text("試合結果を確認"),
        actions: const [MainPopUpMenu()],
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        primary: true,
        child: SizedBox(
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
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
                      _buildGameInfoButton(
                        context: context,
                        ref: ref,
                        categoryToGet: GameDataCategory.d1,
                      ),
                      const SizedBox(width: 10),
                      _buildGameInfoButton(
                        context: context,
                        ref: ref,
                        categoryToGet: GameDataCategory.j1,
                      ),
                      const SizedBox(width: 10),
                      _buildGameInfoButton(
                        context: context,
                        ref: ref,
                        categoryToGet: GameDataCategory.k1,
                      )
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
                      _buildGameInfoButton(
                        context: context,
                        ref: ref,
                        categoryToGet: GameDataCategory.d2,
                      ),
                      const SizedBox(width: 10),
                      _buildGameInfoButton(
                        context: context,
                        ref: ref,
                        categoryToGet: GameDataCategory.j2,
                      ),
                      const SizedBox(width: 10),
                      _buildGameInfoButton(
                        context: context,
                        ref: ref,
                        categoryToGet: GameDataCategory.k2,
                      ),
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
