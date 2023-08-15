import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orko_chat/models/user_model.dart';

class UserService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<UserModel> users = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserModel>(
        fromFirestore: ((snapshot, _) => UserModel.fromJson(snapshot.data()!)),
        toFirestore: (movie, _) => movie.toJson(),
      );

  Stream<List<UserModel>> listusers() {
    var stream = users.snapshots();
    return stream.map(
      (qShot) => qShot.docs
          .map(
            (doc) => doc.data(),
          )
          .toList(),
    );
  }

  

  addUser({required userModel}) async {
    return await users.add(userModel);
  }

  logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

class AuthService {

FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<UserModel> users = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserModel>(
        fromFirestore: ((snapshot, _) => UserModel.fromJson(snapshot.data()!)),
        toFirestore: (movie, _) => movie.toJson(),
      );

  Stream<List<UserModel>> listusers() {
    var stream = users.snapshots();
    return stream.map(
      (qShot) => qShot.docs
          .map(
            (doc) => doc.data(),
          )
          .toList(),
    );
  }


  loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

//   registerWithEmailAndPassword({
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     try {
//       UserCredential userCredential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
// //This code below is what your looking for
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

  signUp({
    required String fullName,
    required String email,
    required String password,
    required String sex,
    required String phone,
    required String imgUrl,
    required DateTime date,
  }) async {
    //create user
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;

      // User user = FirebaseAuth.instance.currentUser!;

      //add user detail
      addUserDetail(
        fullName: fullName,
        email: email,
        password: password,
        sex: sex,
        phone: phone,
        imgUrl: imgUrl,
        date: date,
        uid: uid,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
//This code below is what your looking for
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  logIn({
    required String email,
    required String password,
  }) async {
    //create user
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
      // User user = FirebaseAuth.instance.currentUser!;

      //add user detail
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
//This code below is what your looking for
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future addUserDetail({
    required String fullName,
    required String email,
    required String password,
    required String sex,
    required String phone,
    required String imgUrl,
    required String uid,
    required DateTime date,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("users").add({
        "fullName": fullName,
        "email": email,
        "password": password,
        "image": imgUrl,
        "sex": sex,
        "phone": phone,
        "uid": uid,
        "date": date,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
//This code below is what your looking for
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
