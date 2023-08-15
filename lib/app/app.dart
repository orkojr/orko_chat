import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orko_chat/app/utils/app_colors.dart';
import 'package:orko_chat/views/home.dart';
import 'package:orko_chat/views/welcome.dart';
import 'app_initialization.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AppInitializationScreen(),
      theme: ThemeData(
        primaryColor: AppColors.primary,
        primarySwatch: AppColors.createMaterialColor(AppColors.primary),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}