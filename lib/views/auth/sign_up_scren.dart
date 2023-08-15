import 'dart:io';
// import 'dart:js_interop';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:orko_chat/app/constants/images_string.dart';
import 'package:orko_chat/app/utils/app_router.dart';
import 'package:orko_chat/app/utils/validators.dart';
import 'package:orko_chat/models/user_model.dart';
import 'package:orko_chat/services/auth_service.dart';
import 'package:orko_chat/view_model/forms/input_form.dart';
import 'package:orko_chat/views/home.dart';

import '../../app/loaders/app_loaders.dart';
import '../../app/utils/app_colors.dart';
import '../../services/google_service.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  final LoaderController _loaderController = AppLoader.bounce();
  late AuthService _authService;
  late UserService _userService;
  String? error;

  // Initial Selected Value
  String dropdownvalue = 'Male';

  // List of items in our dropdown menu
  var items = ["Male", "Female"];
  String imgUrl = "";
  File? imgFile;
  final picker = ImagePicker();

  PlatformFile? pickerFile;

  @override
  void initState() {
    _emailController = TextEditingController();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _authService = AuthService();
    _userService = UserService();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
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
              const SizedBox(height: 120),
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  const SizedBox(height: 100),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * .78,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 70,
                              ),
                              AppInput(
                                controller: _fullNameController,
                                label: "Full Name",
                                obscureText: false,
                                prefixIcon: LineAwesomeIcons.user,
                                validator: (value) =>
                                    Validators.checkFieldEmpty(
                                        _fullNameController.text),
                              ),
                              dropdowButton(),
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
                                controller: _phoneController,
                                label: "Phone",
                                obscureText: false,
                                prefixIcon: LineAwesomeIcons.phone,
                                textInputType: TextInputType.phone,
                              ),
                              AppInput(
                                controller: _passwordController,
                                label: "Password",
                                obscureText: true,
                                validator: (value) =>
                                    Validators.validatePassword(
                                        _passwordController.text,
                                        _fullNameController.text),
                                prefixIcon: LineAwesomeIcons.fingerprint,
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      _loaderController.open(context);

                                      UserModel userModel = UserModel(
                                        _fullNameController.text,
                                        dropdownvalue,
                                        _passwordController.text,
                                        _phoneController.text,
                                        _emailController.text,
                                        imgUrl,
                                        DateTime.now(),
                                      );

                                      // await _userService.addUser(
                                      //     userModel: userModel);
                                      UserCredential user =
                                          await _authService.signUp(
                                        fullName: userModel.name,
                                        email: userModel.email,
                                        password: userModel.password,
                                        sex: userModel.sex,
                                        phone: userModel.phone,
                                        imgUrl: userModel.imgUrl,
                                        date: userModel.date,
                                      );

                                      _fullNameController.clear();
                                      _emailController.clear();
                                      _phoneController.clear();
                                      _phoneController.clear();
                                      _passwordController.clear();
                                      setState(() {
                                        _loaderController.close();
                                        imgUrl = "";
                                        imgFile = null;
                                      });
                                      user != null
                                          // ignore: use_build_context_synchronously
                                          ? Navigator.pushAndRemoveUntil(
                                              context,
                                              AppRouter.buildRoute(
                                                  const HomeScreen()),
                                              (route) => false)
                                          : null;
                                    } catch (e) {
                                      if (e is FirebaseAuthException) {
                                        error = e.message;
                                      } else {
                                        error = e.toString();
                                      }
                                      setState(() {
                                        _loaderController.close();
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder()),
                                  child: const Text("SIGN UP"),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: imgFile != null
                              ? Image(
                                  image: FileImage(imgFile!),
                                  fit: BoxFit.cover,
                                )
                              : const Image(
                                  image: AssetImage(tProfileImage),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.yellow,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              var result = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, "camera");
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: const StadiumBorder(),
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.0),
                                                    child: Icon(LineAwesomeIcons
                                                        .camera),
                                                  ),
                                                  Text("Camera"),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, "galery");
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: const StadiumBorder(),
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.0),
                                                    child: Icon(
                                                        LineAwesomeIcons.image),
                                                  ),
                                                  Text("Galery"),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ));

                              if (result == "camera") {
                                chooseImageCam();
                              } else if (result == 'galery') {
                                chooseImageGal();
                              }
                            },
                            child: const Icon(
                              LineAwesomeIcons.camera,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  chooseImageCam() async {
    final pickerFile = await picker.pickImage(source: ImageSource.camera);

    if (pickerFile != null) {
      imgFile = File(pickerFile.path);
      var img = await uploadFile(imgFile!);
      imgUrl = img!;
      setState(() {});
      print("ImageUrl$imgUrl");
    } else {
      print("No image selected");
    }

    // ignore: unnecessary_null_comparison
    if (pickerFile!.path == null) retrieveLostData();
  }

  chooseImageGal() async {
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickerFile != null) {
      imgFile = File(pickerFile.path);
      var img = await uploadFile(imgFile!);
      imgUrl = img!;
      setState(() {});
      print("ImageUrl$imgUrl");
    } else {
      print("No image selected");
    }

    // ignore: unnecessary_null_comparison
    if (pickerFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      imgFile = File(response.file!.path);
    } else {
      print(response.file);
    }
  }

  Future<String?> uploadFile(File file) async {
    var task = await FirebaseStorage.instance
        .ref('images/${file.hashCode}')
        .putFile(file);

    return task.ref.getDownloadURL();
  }

  Padding dropdowButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(LineAwesomeIcons.genderless),
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          hintText: "Select your sex",
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w300,
            color: AppColors.grayScale,
          ),
          fillColor: const Color.fromARGB(125, 232, 234, 235),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(100),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.hexToColor("#DDDDDD")),
            borderRadius: BorderRadius.circular(100),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.hexToColor("#DDDDDD")),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        value: items[0],
        items: items.map((accountType) {
          return DropdownMenuItem(
            value: accountType,
            child: Text(accountType),
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            dropdownvalue = val!;
          });
        },
      ),
    );
  }
}
