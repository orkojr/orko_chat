import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:orko_chat/app/constants/images_string.dart';
import 'package:orko_chat/app/utils/app_router.dart';
import 'package:orko_chat/app/utils/validators.dart';
import 'package:orko_chat/services/auth_service.dart';
import 'package:orko_chat/services/google_service.dart';
import 'package:orko_chat/view_model/forms/input_form.dart';
import 'package:orko_chat/views/auth/sign_up_scren.dart';
import 'package:orko_chat/views/home.dart';

import '../../app/loaders/app_loaders.dart';

class SingInScreen extends StatefulWidget {
  const SingInScreen({super.key});

  @override
  State<SingInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final LoaderController _loaderController = AppLoader.bounce();
  late AuthService _authService;
  String? error;

  PlatformFile? pickerFile;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _authService = AuthService();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.yellow.shade400),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.width * .5),
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  const SizedBox(height: 100),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * .54,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(100),
                          topRight: Radius.circular(50)),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _formkey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 70,
                              ),
                              AppInput(
                                controller: _emailController,
                                label: "Email",
                                obscureText: false,
                                prefixIcon: LineAwesomeIcons.envelope,
                                textInputType: TextInputType.emailAddress,
                                validator: (value) => Validators.verifiedEmail(
                                    _emailController.text),
                              ),
                              AppInput(
                                controller: _passwordController,
                                label: "Password",
                                obscureText: true,
                                prefixIcon: LineAwesomeIcons.fingerprint,
                                validator: (value) =>
                                    Validators.validatePassword(
                                  _passwordController.text,
                                  _emailController.text,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      _loaderController.open(context);

                                      final user = await _authService.logIn(
                                          email: _emailController.text,
                                          password: _passwordController.text);

                                      _emailController.clear();
                                      _passwordController.clear();
                                      setState(() {
                                        _loaderController.close();
                                      });

                                      if (user != null) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            AppRouter.buildRoute(
                                                const HomeScreen()),
                                            (route) => false);
                                      }
                                    } catch (e) {
                                      _loaderController.close();
                                      print(e.toString());
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder()),
                                  child: const Text("SIGN IN"),
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    _loaderController.open(context);

                                    await singInWithGoogle();
                                    if (mounted) {
                                      setState(() {
                                        _loaderController.close();
                                      });

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          AppRouter.buildRoute(
                                              const HomeScreen()),
                                          (route) => false);
                                    }
                                  } catch (e) {
                                    _loaderController.close();
                                    print(e.toString());
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Image.asset(
                                          tGoogleImage,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const Text(
                                        "Sign IN with Google",
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: RichText(
                                  text: TextSpan(
                                      text: "don't have an account ?   ",
                                      style: const TextStyle(
                                          color: Colors.black54),
                                      children: [
                                        TextSpan(
                                          text: "Create",
                                          style: const TextStyle(
                                              color: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).push(
                                                  AppRouter.buildRoute(
                                                      const SingUpScreen()));
                                            },
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: const Image(
                        image: AssetImage(tChat1Image),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
