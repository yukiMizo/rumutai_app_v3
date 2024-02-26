import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/sign_in_data_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const routeName = "/sign-in-screen";

  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _passwordController = TextEditingController();
  var _isLoading = false;
  SignInType? _selectedLoginType;

  Widget _buildRadioButtonSection() {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Text(
          "選択",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        RadioListTile(
          title: const Text('ルム対スタッフ'),
          value: SignInType.rumutaiStaff,
          groupValue: _selectedLoginType,
          onChanged: (value) {
            setState(() {
              _selectedLoginType = value;
            });
          },
        ),
        RadioListTile(
          title: const Text('管理者'),
          value: SignInType.admin,
          groupValue: _selectedLoginType,
          onChanged: (value) {
            setState(() {
              _selectedLoginType = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      children: [
        const Text(
          "パスワード",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        TextField(
          onChanged: (_) => setState(() {}),
          controller: _passwordController,
        ),
      ],
    );
  }

  Widget _buildSigninButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: (_passwordController.text != "" && _selectedLoginType != null)
            ? () async {
                setState(() {
                  _isLoading = true;
                });
                //firebaseからパスワードを取得
                var passwordData = await FirebaseFirestore.instance.collection("password").doc("passwordDoc").get();
                //パスワードが合っているか確認
                bool canLogin = false;
                switch (_selectedLoginType!) {
                  case SignInType.rumutaiStaff:
                    if (_passwordController.text == passwordData["rumutaiStaff"]) {
                      canLogin = true;
                    }
                    break;
                  case SignInType.admin:
                    if (_passwordController.text == passwordData["admin"]) {
                      canLogin = true;
                    }
                    break;
                }
                //サインイン
                if (canLogin) {
                  await SignInDataManager.signIn(ref, _passwordController.text, _selectedLoginType!);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("サインインに成功しました")),
                  );
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("パスワードが違います"),
                    ),
                  );
                }
                setState(() {
                  _isLoading = false;
                });
              }
            : null,
        child: const Text("サインイン"),
      ),
    );
  }

  Widget _buildSignoutButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          //ログアウト
          await SignInDataManager.signOut(ref);

          _passwordController.text = "";
          _selectedLoginType = null;

          if (!mounted) return;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("サインアウトしました")),
          );
          setState(() {
            _isLoading = false;
          });
        },
        child: const Text("サインアウト"),
      ),
    );
  }

  Widget _buildSignInScreen() {
    return Column(children: [
      _buildRadioButtonSection(),
      const SizedBox(height: 30),
      _buildPasswordSection(),
      const SizedBox(height: 15),
      _isLoading ? const CircularProgressIndicator() : _buildSigninButton(),
    ]);
  }

  Widget _buildSignOutScreen() {
    return Column(children: [
      const SizedBox(height: 30),
      if (ref.watch(isLoggedInRumutaiStaffProvider)) const Text("ルム対スタッフとしてサインイン済みです"),
      if (ref.watch(isLoggedInAdminProvider)) const Text("管理者としてサインイン済みです"),
      const SizedBox(height: 50),
      _isLoading ? const CircularProgressIndicator() : _buildSignoutButton(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final isSignedIn = (ref.watch(isLoggedInRumutaiStaffProvider) || ref.watch(isLoggedInAdminProvider));
    return Scaffold(
      appBar: AppBar(title: Text(isSignedIn ? "サインアウト" : "サインイン")),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            final FocusScopeNode currentScope = FocusScope.of(context);
            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: isSignedIn ? _buildSignOutScreen() : _buildSignInScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
