// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:orko_chat/app/utils/app_colors.dart';
import 'package:orko_chat/app/widgets/Message_input.dart';
import 'package:orko_chat/app/widgets/signle_message.dart';
import 'package:orko_chat/services/chat/chat_service.dart';

import '../app/loaders/app_loaders.dart';

class ChatScrenn extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserName;
  final String receiverUserId;
  final String receiverUserImageUrl;
  const ChatScrenn({
    Key? key,
    required this.receiverUserEmail,
    required this.receiverUserName,
    required this.receiverUserId,
    required this.receiverUserImageUrl,
  }) : super(key: key);

  @override
  State<ChatScrenn> createState() => _ChatScrennState();
}

class _ChatScrennState extends State<ChatScrenn> {
  late TextEditingController _messageController;
  late ChatService _chatService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isEdit = false;
  final LoaderController _loaderController = AppLoader.bounce();

  @override
  void initState() {
    _messageController = TextEditingController();
    _chatService = ChatService();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserId, _messageController.text);

      //clear the controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(LineAwesomeIcons.arrow_left),
            ),
            Container(
              height: 32,
              width: 32,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    widget.receiverUserImageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
        backgroundColor: AppColors.primary,
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0),
          title: Text(widget.receiverUserName),
          subtitle: Text(widget.receiverUserEmail),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_firebaseAuth.currentUser!.uid)
                    .collection('messages')
                    .doc(widget.receiverUserId)
                    .collection('chats')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return const Center(
                        child: Text("Say hi"),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        bool isMe = snapshot.data.docs[index]['senderId'] ==
                            _firebaseAuth.currentUser!.uid;

                        return SingleMessage(
                          message: snapshot.data.docs[index]['message'],
                          isMe: isMe,
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          MessageTextField(
            senderId: _firebaseAuth.currentUser!.uid,
            receiverId: widget.receiverUserId,
          )
        ],
      ),
    );
  }

  // build message list
  Widget _buidMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserId, _firebaseAuth.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            _loaderController.open(context);
          }

          return ListView.builder(itemBuilder: (context, index) {
            var message = snapshot.data![index];
            const ListTile();
            return null;
          });
        });
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to right if sender is the current user, otherwise to the left
    var aligment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: aligment,
      child: Column(
        children: [
          Text(data['senderEmail']),
          Text(data['message']),
        ],
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        // textfield
        Expanded(
          child: TextFormField(
            minLines: 1,
            maxLines: 3,
            onChanged: (value) {
              if (value.isNotEmpty) {
                isEdit = false;
              } else {
                isEdit = true;
              }
              setState(() {});
            },
            controller: _messageController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5.0),
              hintText: "Message",
              prefixIcon: IconButton(
                icon: const Icon(
                  Icons.emoji_emotions,
                  color: Colors.black54,
                ),
                iconSize: 20,
                onPressed: () {},
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.rotate(
                    angle: pi / 4,
                    child: IconButton(
                      icon: const Icon(
                        Icons.attachment,
                        color: Colors.black54,
                      ),
                      iconSize: 20,
                      onPressed: () {},
                    ),
                  ),
                  isEdit
                      ? IconButton(
                          icon: const Icon(
                            Icons.photo_camera,
                            color: Colors.black54,
                          ),
                          iconSize: 20,
                          onPressed: () {},
                        )
                      : Container(),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        )
        // sender button
      ],
    );
  }
}
