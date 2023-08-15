// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MessageTextField extends StatefulWidget {
  String senderId;
  String receiverId;
  MessageTextField({
    Key? key,
    required this.senderId,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  late TextEditingController _messageController;

  @override
  void initState() {
    _messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              minLines: 1,
              controller: _messageController,
              decoration: InputDecoration(
                  suffixIcon: const Icon(
                    LineAwesomeIcons.paperclip,
                    color: Colors.black54,
                  ),
                  hintText: "Type your Message",
                  fillColor: Colors.grey[100],
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25),
                  )),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              if (_messageController.text.isNotEmpty) {
                String message = _messageController.text;
                _messageController.clear();
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.senderId)
                    .collection('messages')
                    .doc(widget.receiverId)
                    .collection('chats')
                    .add({
                  'senderId': widget.senderId,
                  'receiverId': widget.receiverId,
                  'message': message,
                  'type': 'text',
                  'date': DateTime.now(),
                }).then((value) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.senderId)
                      .collection('messages')
                      .doc(widget.receiverId)
                      .set({
                    'last_msg': message,
                  });
                });

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.receiverId)
                    .collection('messages')
                    .doc(widget.senderId)
                    .collection('chats')
                    .add({
                  'senderId': widget.senderId,
                  'receiverId': widget.receiverId,
                  'message': message,
                  'type': 'text',
                  'date': DateTime.now(),
                }).then((value) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.receiverId)
                      .collection('messages')
                      .doc(widget.senderId)
                      .set({
                    'last_msg': message,
                  });
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.yellow,
              ),
              child: const Icon(
                LineAwesomeIcons.paper_plane,
                color: Colors.black,
                size: 35,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
