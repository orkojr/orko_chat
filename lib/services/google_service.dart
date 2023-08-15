import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    'fullName': userCredential.user!.displayName,
    'image': userCredential.user!.photoURL,
    'phone': userCredential.user!.phoneNumber,
    'uid': userCredential.user!.uid,
    'date': DateTime.now(),
  });
}

Future<void> singIn({email}) async {
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
    'fullName': userCredential.user!.displayName,
    'imgUrl': userCredential.user!.photoURL,
    'phone': userCredential.user!.phoneNumber,
    'uid': userCredential.user!.uid,
    'date': DateTime.now(),
  });
}
