import 'package:flutter/material.dart';
import 'package:rumutai_app/screens/drawer/publish_drive.dart';

import '../screens/home_screen.dart';
import '../screens/drawer/map_screen.dart';
import '../screens/drawer/sign_in_screen.dart';
import '../screens/drawer/setting_screen.dart';
import '../screens/drawer/contact_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.primary),
          child: const Text(
            "ルム対アプリ",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        ListTile(
          title: const Text("ホーム", style: TextStyle(fontSize: 20)),
          onTap: () => Navigator.popUntil(
            context,
            ModalRoute.withName(HomeScreen.routeName),
          ),
        ),
        ListTile(
          title: const Text("マップ", style: TextStyle(fontSize: 20)),
          onTap: () => Navigator.of(context).pushNamed(MapScreen.routeName),
        ),
        ListTile(
          title: const Text("サインイン", style: TextStyle(fontSize: 20)),
          onTap: () => Navigator.of(context).pushNamed(SignInScreen.routeName),
        ),
        ListTile(
          title: const Text("お問い合わせ", style: TextStyle(fontSize: 20)),
          onTap: () => Navigator.of(context).pushNamed(ContactScreen.routeName),
        ),
        ListTile(
          title: const Text("情報公開", style: TextStyle(fontSize: 20)),
          onTap: () =>
              Navigator.of(context).pushNamed(PublishDriveScreen.routeName),
        ),
        const Divider(),
        ListTile(
          title: const Text("法的事項", style: TextStyle(fontSize: 20)),
          onTap: () => Navigator.of(context).pushNamed(SettingScreen.routeName),
        ),
      ]),
    );
  }
}
