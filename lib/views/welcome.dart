import 'package:flutter/material.dart';
import 'package:orko_chat/app/constants/texts_string.dart';
import 'package:orko_chat/views/auth/sing_in_screen.dart';
import 'package:orko_chat/views/auth/sign_up_scren.dart';

import '../app/constants/images_string.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 100),
              SizedBox(
                height: 200,
                width: 200,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180),
                    child: Image.asset(
                      tChat1Image,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Text(
                "Welcome".toUpperCase(),
                style:
                    const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text.rich(TextSpan(
                    text: twelcome,
                    style: TextStyle(
                      fontSize: 18,
                    ))),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SingUpScreen(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SingInScreen(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "SIGN IN",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
