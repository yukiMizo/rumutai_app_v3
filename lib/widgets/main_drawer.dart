import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rumutai_app/screens/drawer/publish_drive.dart';
import 'package:rumutai_app/themes/app_color.dart';
import '../providers/sign_in_data_provider.dart';

import '../screens/home_screen.dart';
import '../screens/drawer/map_screen.dart';
import '../screens/drawer/sign_in_screen.dart';
import '../screens/drawer/info_screen.dart';
import '../screens/drawer/contact_screen.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSignedIn = (ref.watch(isLoggedInRumutaiStaffProvider) || ref.watch(isLoggedInAdminProvider));
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
          child: const Text(
            "ルム対アプリ",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text("ホーム", style: TextStyle(fontSize: 20)),
          onTap: () => Navigator.popUntil(
            context,
            ModalRoute.withName(HomeScreen.routeName),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.map_outlined),
          title: const Text("マップ", style: TextStyle(fontSize: 20)),
          onTap: () => Navigator.of(context).pushNamed(MapScreen.routeName),
        ),
        ListTile(
          leading: const Icon(Icons.support_agent_outlined),
          title: const Text("お問い合わせ", style: TextStyle(fontSize: 20)),
          onTap: () => Navigator.of(context).pushNamed(ContactScreen.routeName),
        ),
        ListTile(
          leading: const Icon(Icons.article_outlined),
          title: const Text("情報", style: TextStyle(fontSize: 20)),
          onTap: () => Navigator.of(context).pushNamed(InfoScreen.routeName),
        ),
        Divider(color: AppColors.themeColor.shade100),
        ListTile(
          leading: Icon(isSignedIn ? Icons.logout_outlined : Icons.login_outlined),
          title: Text(
            isSignedIn ? "サインアウト" : "サインイン",
            style: const TextStyle(fontSize: 20),
          ),
          onTap: () => Navigator.of(context).pushNamed(SignInScreen.routeName),
        ),
      ]),
    );
  }
}
