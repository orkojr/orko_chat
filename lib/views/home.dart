import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:orko_chat/app/constants/images_string.dart';
import 'package:orko_chat/app/constants/texts_string.dart';
import 'package:orko_chat/app/utils/app_colors.dart';
import 'package:orko_chat/app/utils/app_router.dart';
import 'package:orko_chat/services/auth_service.dart';
import 'package:orko_chat/views/auth/sing_in_screen.dart';
import 'package:orko_chat/views/chat_screen.dart';
import 'package:orko_chat/views/search_screen.dart';
import 'package:orko_chat/views/statut_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late AuthService _authService;

  @override
  void initState() {
    _authService = AuthService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var username = "orkojr";
    var useremail = "jordankamga17@gmail.com";

    if (user != null) {
      var username = user?.displayName;
      var useremail = user?.email;
    }
    return Scaffold(
      drawer: Drawer(
        elevation: 0,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                username,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
              accountEmail: Text(
                useremail,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
              currentAccountPicture: const CircleAvatar(
                child: ClipOval(
                  child: Image(
                    image: AssetImage(tProfileImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(tChat1Image),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const ListTile(
                    leading: Icon(LineAwesomeIcons.heart),
                    title: Text("Favorites"),
                  ),
                  const ListTile(
                    leading: Icon(LineAwesomeIcons.user_friends),
                    title: Text("Friends"),
                  ),
                  const ListTile(
                    leading: Icon(Icons.share),
                    title: Text("Share"),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(LineAwesomeIcons.power_off),
                    title: const Text("Logout"),
                    onTap: () async {
                      await GoogleSignIn().signOut();
                      await _authService.logOut();
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                          context,
                          AppRouter.buildRoute(const SingInScreen()),
                          (route) => false);
                    },
                  ),
                  const ListTile(
                    leading: Icon(LineAwesomeIcons.cog),
                    title: Text("Setting"),
                  ),
                  const ListTile(
                    leading: Icon(LineAwesomeIcons.question_circle),
                    title: Text("Aide et Commentaire"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: AppColors.primary,
            forceElevated: true,
            expandedHeight: 60,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                image: AssetImage(tChat1Image),
                fit: BoxFit.cover,
              ),
              title: Text(
                "OrkoChat",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return const StatuScreen();
              },
              childCount: 1,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: .2),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        AppRouter.buildRoute(
                          const ChatScrenn(
                              receiverUserEmail: tProfileSubHeading,
                              receiverUserName: tProfileHeading,
                              receiverUserId: tProfileHeading,
                              receiverUserImageUrl:
                                  "https://lh3.googleusercontent.com/a/AAcHTtfZ_o3xg1yQGqSZfxDdtNVmARWtfSi4jmbVX7AQL7Hc=s96-c"),
                        ),
                      );
                    },
                    leading: const CircleAvatar(
                      child: Icon(LineAwesomeIcons.user),
                    ),
                    title: const Text(tProfileHeading),
                    subtitle: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            LineAwesomeIcons.double_check,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ),
                        Text("Hello Us, how can i help  you?")
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("05:23"),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.greenAccent,
                          ),
                          child: Text(
                            "$index",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 50,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, AppRouter.buildRoute(const SearchScreen()));
        },
        child: const Icon(LineAwesomeIcons.pen),
      ),
    );
  }
}
