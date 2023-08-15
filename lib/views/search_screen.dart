// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:orko_chat/app/constants/images_string.dart';
import 'package:orko_chat/app/utils/app_colors.dart';
import 'package:orko_chat/app/utils/app_router.dart';
import 'package:orko_chat/models/user_model.dart';
import 'package:orko_chat/views/chat_screen.dart';

import '../app/loaders/app_loaders.dart';

// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late Stream<List<UserModel>> _userStream;
  List<Map> searchResult = [];
  List allResult = [];
  List resultList = [];
  bool isloading = false;
  User? userauth = FirebaseAuth.instance.currentUser;
  final LoaderController _loaderController = AppLoader.bounce();

  @override
  void initState() {
    allResults();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    allResults();
    super.didChangeDependencies();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var clientSnapchot in allResult) {
        var name = clientSnapchot['fullName'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapchot);
        }
      }
    } else {
      showResults = List.from(allResult);
    }
    setState(() {
      resultList = showResults;
    });
  }

  _onSearchChanged() {
    searchResultList();
  }

  void onSearch() async {
    setState(() {
      searchResult = [];
      allResult = [];
      isloading = true;
    });

    await FirebaseFirestore.instance
        .collection("users")
        .where("fullName",
            isGreaterThanOrEqualTo: _searchController.text,
            isLessThan: _searchController.text
                    .substring(0, _searchController.text.length - 1) +
                String.fromCharCode(_searchController.text
                        .codeUnitAt(_searchController.text.length - 1) +
                    1))
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No user found")));
        setState(() {
          isloading = false;
        });
        return;
      }

      for (var user in value.docs) {
        if (user.data()['email'] != userauth!.email) {
          searchResult.add(user.data());
        }
      }
      setState(() {
        isloading = false;
      });
    });
  }

  void allResults() async {
    var uid = userauth!.uid;
    var data = await FirebaseFirestore.instance
        .collection("users")
        .where('uid', isNotEqualTo: uid)
        .get();

    setState(() {
      allResult = data.docs;
      isloading = false;
    });
    searchResultList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          controller: _searchController,
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: resultList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  AppRouter.buildRoute(
                    ChatScrenn(
                        receiverUserEmail: resultList[index]['email'],
                        receiverUserName: resultList[index]['fullName'],
                        receiverUserId: resultList[index]['uid'],
                        receiverUserImageUrl: resultList[index]['image']),
                  ),
                );
              },
              leading: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: resultList[index]['image'] != ''
                      ? DecorationImage(
                          image: NetworkImage(resultList[index]['image']),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage(tProfileImage),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              title: Text(resultList[index]['fullName']),
              subtitle: Text(resultList[index]['email']),
              trailing: const Icon(
                LineAwesomeIcons.facebook_messenger,
                color: Colors.black87,
              ),
            );
          },
        ),
      ),
    );
  }
}
