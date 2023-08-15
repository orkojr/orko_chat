import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orko_chat/models/message_model.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //SEND MESSAGE
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    //construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids (this ensures the chat room id is always the same  for any pair of people)
    String chatRoomId = ids.join(
        "_"); // combine the ids into  asa single string to  use  as a chatroomID

    //add new message to  database
    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //GET MESSAGE
  Stream<QuerySnapshot> getMessages(String userId, String ortherUserId) {
    // construct chat room id from user ids(sorted to ensures it matches the id used when sending messages)
    List<String> ids = [userId, ortherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
