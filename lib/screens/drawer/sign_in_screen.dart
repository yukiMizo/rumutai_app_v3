import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../local_data.dart';

import '../../providers/local_data_provider.dart';
import '../../themes/app_color.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const routeName = "/sign-in-screen";

  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _adminController = TextEditingController();
  final TextEditingController _rumutaiStaffController = TextEditingController();

  var _isLoadingAdmin = false;
  var _isLoadingRumutaiStaff = false;

  Widget _signInWidget({
    required bool isLoggedIn,
    required String loginAs,
    required textController,
  }) {
    late String text;
    if (loginAs == "Admin") {
      text = "管理者";
    } else if (loginAs == "RumutaiStaff") {
      text = "ルム対スタッフ";
    }
    return Column(
      children: [
        SizedBox(
          width: 300,
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (isLoggedIn)
          SizedBox(
            width: 300,
            child: Row(
              children: [
                Text(
                  "サインイン済みです。",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: () async {
                    setState(() {
                      if (loginAs == "Admin") {
                        _isLoadingAdmin = true;
                      } else if (loginAs == "RumutaiStaff") {
                        _isLoadingRumutaiStaff = true;
                      }
                    });
                    await LocalData.saveLocalData<bool>("isLoggedIn$loginAs", false);
                    if (!mounted) return;
                    await LocalDataManager.setLoginDataFromLocal(ref);
                    textController.text = "";
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('サインアウトしました。'),
                      ),
                    );

                    setState(() {
                      if (loginAs == "Admin") {
                        _isLoadingAdmin = false;
                      } else if (loginAs == "RumutaiStaff") {
                        _isLoadingRumutaiStaff = false;
                      }
                    });
                  },
                  label: const Text("サインアウト"),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          )
        else
          SizedBox(
            width: 300,
            height: 50,
            child: TextField(
              onChanged: (_) => setState(() {}),
              controller: textController,
              decoration: InputDecoration(
                label: const Text("認証コード"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLoggedIn)
              SizedBox(
                width: 300,
                child: FilledButton.icon(
                  onPressed: textController.text == ""
                      ? null
                      : () async {
                          setState(() {
                            if (loginAs == "Admin") {
                              _isLoadingAdmin = true;
                            } else if (loginAs == "RumutaiStaff") {
                              _isLoadingRumutaiStaff = true;
                            }
                          });
                          var data = await FirebaseFirestore.instance.collection("password").doc("passwordDoc").get();
                          if (data[loginAs] == textController.text) {
                            await LocalData.saveLocalData<bool>("isLoggedIn$loginAs", true);
                            if (loginAs == "Admin") {
                              await LocalData.saveLocalData<String>(
                                "adminPassword",
                                data[loginAs],
                              );
                            } else if (loginAs == "RumutaiStaff") {
                              await LocalData.saveLocalData<String>(
                                "rumutaiStaffPassword",
                                data[loginAs],
                              );
                            }

                            if (!mounted) return;
                            await LocalDataManager.setLoginDataFromLocal(ref);
                            textController.text = "";
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("$textとして、サインインしました。")),
                            );
                          } else {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('認証コードが違います。'),
                              ),
                            );
                          }

                          setState(() {
                            if (loginAs == "Admin") {
                              _isLoadingAdmin = false;
                            } else if (loginAs == "RumutaiStaff") {
                              _isLoadingRumutaiStaff = false;
                            } /* if (loginAs == "ResultEditor") {
                              _isLoadingResultEditor = false;
                            }*/
                          });
                        },
                  label: const Text("サインイン"),
                  icon: const Icon(Icons.login),
                ),
              ),
            if (_isLoadingRumutaiStaff && loginAs == "RumutaiStaff") const SizedBox(width: 10),
            if (_isLoadingRumutaiStaff && loginAs == "RumutaiStaff")
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            if (_isLoadingAdmin && loginAs == "Admin") const SizedBox(width: 10),
            if (_isLoadingAdmin && loginAs == "Admin")
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedInAdmin = ref.read(isLoggedInAdminProvider);
    bool isLoggedInRumutaiStaff = ref.read(isLoggedInRumutaiStaffProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("サインイン")),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 60),
              const SizedBox(
                width: 300,
                child: Text(
                  "ルム対スタッフ、管理者は、\n認証コードでサインインできます。",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 30),
              Divider(color: AppColors.themeColor.shade900),
              _signInWidget(
                isLoggedIn: isLoggedInRumutaiStaff,
                loginAs: "RumutaiStaff",
                textController: _rumutaiStaffController,
              ),
              Divider(color: AppColors.themeColor.shade900),
              _signInWidget(
                isLoggedIn: isLoggedInAdmin,
                loginAs: "Admin",
                textController: _adminController,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
