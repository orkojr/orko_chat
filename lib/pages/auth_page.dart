import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orko_chat/views/profile/profile_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> singInWithGoogle() async {
    //create an instance of firebase auth and google singn in
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    //Triger the authentification flow details from the
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    //Obtain the auth details from  the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    //Create a new credencials
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //Sign the user with the credentials
    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    await firestore.collection("users").doc(userCredential.user!.uid).set({
      'email': userCredential.user!.email,
      'name': userCredential.user!.displayName,
      'image': userCredential.user!.photoURL,
      'phone': userCredential.user!.phoneNumber,
      'uid': userCredential.user!.uid,
      'date': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ChatJK",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              //ici on  implemente  la fonction google sign in
              await singInWithGoogle();
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const profileScreen(),
                  ),
                );
              }
            },
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset(
                      "assets/images/profile/google.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Text(
                    "Continuer avec Google",
                    style: TextStyle(
                      fontSize: 17,
                    ),
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
