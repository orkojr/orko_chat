import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orko_chat/app/utils/app_colors.dart';
import 'package:orko_chat/app/utils/app_router.dart';
import 'package:orko_chat/views/welcome.dart';

import '../views/home.dart';

class AppInitializationScreen extends StatefulWidget {
  const AppInitializationScreen({Key? key}) : super(key: key);

  @override
  State<AppInitializationScreen> createState() =>
      _AppInitializationScreenState();
}

class _AppInitializationScreenState extends State<AppInitializationScreen> {
  @override
  void initState() {
    checkSate();
    super.initState();
  }

  Future<Widget> userSignIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const HomeScreen();
    } else {
      return const WelcomeScreen();
    }
  }

  checkSate() {
    WidgetsBinding.instance.addPostFrameCallback((Timestamp) async {
      Navigator.of(context).pushAndRemoveUntil(
          AppRouter.buildRoute(await userSignIn()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Orko Chat",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
