import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumutai_app/providers/sign_in_data_provider.dart';
import 'package:rumutai_app/screens/admin/manage_omikuji_screen.dart';

import 'package:rumutai_app/themes/app_color.dart';

import 'draw_omikuji_screen.dart';
import 'make_omikuji_screen.dart';

class PickOmikujiScreen extends ConsumerWidget {
  static const routeName = "/pick-omikuji-screen";

  const PickOmikujiScreen({super.key});

  Widget _mainButton({
    required String text,
    required void Function() onPressed,
  }) {
    return SizedBox(
      width: 250,
      height: 50,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.brown,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _subButton({
    required String text,
    required void Function() onPressed,
  }) {
    return SizedBox(
      width: 250,
      height: 50,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          side: const BorderSide(
            color: Colors.brown,
            width: 2,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.brown.shade800,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            height: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTonalButton({
    required String text,
    required void Function() onPressed,
  }) {
    return SizedBox(
      width: 250,
      height: 50,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.themeColor.shade200,
          foregroundColor: AppColors.themeColor.shade900,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            height: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("おみくじ")),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "みんなで作るおみくじです",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.brown.shade900,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 50),
            Hero(
              tag: "omikuji-image",
              child: SizedBox(
                width: 100,
                child: Image.asset("assets/images/omikuji.png"),
              ),
            ),
            const SizedBox(height: 50),
            _mainButton(
              text: "引く",
              onPressed: () => Navigator.of(context).pushNamed(DrawOmikujiScreen.routeName),
            ),
            const SizedBox(height: 15),
            _subButton(
              text: "作る",
              onPressed: () => Navigator.of(context).pushNamed(MakeOmikujiScreen.routeName),
            ),
            if (ref.watch(isLoggedInAdminProvider))
              Column(
                children: [
                  const SizedBox(height: 15),
                  _buildTonalButton(
                    text: "管理",
                    onPressed: () => Navigator.of(context).pushNamed(ManagaeOmikujiScreen.routeName),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
