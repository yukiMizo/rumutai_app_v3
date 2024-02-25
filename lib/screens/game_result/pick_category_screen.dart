import 'package:flutter/material.dart';
import 'package:rumutai_app/providers/game_data_provider.dart';

import 'game_results_screen.dart';
import '../../widgets/main_pop_up_menu.dart';

class PickCategoryScreen extends StatelessWidget {
  static const routeName = "/game-info-screen";

  const PickCategoryScreen({super.key});

  Widget _gameInfoButton({
    required context,
    required IconData icon,
    required String text,
    required GameDataCategory categoryToGet,
  }) {
    return FilledButton(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.all(0),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
      ),
      onPressed: () => Navigator.of(context).pushNamed(GameResultsScreen.routeName, arguments: categoryToGet),
      child: SizedBox(
        width: 105,
        height: 100,
        child: Column(
          children: [
            const SizedBox(height: 18),
            Icon(
              icon,
              size: 40,
              color: Colors.brown.shade900,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(color: Colors.brown.shade900, fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 18, fontFamily: "Anton"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 25,
                      color: Colors.brown.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _gameInfoButton(
                        context: context,
                        icon: Icons.sports_soccer,
                        text: "FUTSAL",
                        categoryToGet: GameDataCategory.d1,
                      ),
                      const SizedBox(width: 10),
                      _gameInfoButton(
                        context: context,
                        icon: Icons.sports_volleyball_outlined,
                        text: "VOLLEYBALL",
                        categoryToGet: GameDataCategory.j1,
                      ),
                      const SizedBox(width: 10),
                      _gameInfoButton(
                        context: context,
                        icon: Icons.sports_volleyball_outlined,
                        text: "DODGEBALL",
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
                      fontSize: 25,
                      color: Colors.brown.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _gameInfoButton(
                        context: context,
                        icon: Icons.sports_soccer,
                        text: "FUTSAL",
                        categoryToGet: GameDataCategory.d2,
                      ),
                      const SizedBox(width: 10),
                      _gameInfoButton(
                        context: context,
                        icon: Icons.sports_basketball_outlined,
                        text: "BASKETBALL",
                        categoryToGet: GameDataCategory.j2,
                      ),
                      const SizedBox(width: 10),
                      _gameInfoButton(
                        context: context,
                        icon: Icons.sports_volleyball_outlined,
                        text: "VOLLEYBALL",
                        categoryToGet: GameDataCategory.k2,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                    child: Divider(),
                  ),
                  Text(
                    "3年",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.brown.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _gameInfoButton(
                        context: context,
                        icon: Icons.sports_soccer,
                        text: "FUTSAL",
                        categoryToGet: GameDataCategory.d3,
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pushNamed(GameResultsScreen.routeName, arguments: GameDataCategory.j3),
                        child: SizedBox(
                          width: 105,
                          height: 100,
                          child: Column(
                            children: [
                              const SizedBox(height: 23),
                              Image.asset(
                                "assets/images/frisbee_icon.png",
                                scale: 15,
                                color: Colors.brown.shade900,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "DODGEBEE",
                                style: TextStyle(color: Colors.brown.shade900, fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 18, fontFamily: "Anton"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _gameInfoButton(
                        context: context,
                        icon: Icons.sports_volleyball_outlined,
                        text: "VOLLEYBALL",
                        categoryToGet: GameDataCategory.k3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
