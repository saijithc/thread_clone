import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thread_clone/responsive/mobile_layout.dart';
import 'package:thread_clone/responsive/responsive_layout_screen.dart';
import 'package:thread_clone/responsive/web_layout.dart';
import 'package:thread_clone/screens/authentication/login_screen.dart';
import 'package:thread_clone/services/auth_services.dart';
import 'package:thread_clone/utils/image_picker.dart';
import 'package:thread_clone/utils/snack_bar.dart';
import 'package:thread_clone/widgets/custom_text_field.dart';
import 'package:thread_clone/widgets/submit_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final AuthMethods _authMethodes = AuthMethods();
  Uint8List? _profileImage;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://freelogopng.com/images/all_img/1688663226threads-logo-png.png',
                      height: 60,
                      width: 60,
                    ),
                    const Text(
                      'Threads',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    _profileImage != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: MemoryImage(_profileImage!),
                          )
                        : const CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage("https://mobcup.net/w/cdn9ezn0"),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.amber.shade100,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    controller: emailController,
                    isPassword: false,
                    inputKeyboardType: TextInputType.emailAddress,
                    hintText: 'Enter Email'),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    controller: passwordController,
                    isPassword: true,
                    inputKeyboardType: TextInputType.emailAddress,
                    hintText: 'Enter Password'),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    controller: usernameController,
                    isPassword: false,
                    inputKeyboardType: TextInputType.emailAddress,
                    hintText: 'Enter Username'),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    controller: bioController,
                    isPassword: false,
                    inputKeyboardType: TextInputType.emailAddress,
                    hintText: 'Enter Bio'),
                const SizedBox(
                  height: 30,
                ),
                SubmitButton(
                  text: isLoading ? "Registering.." : "Register",
                  onPressed: registerUser,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void registerUser() async {
    setState(() {
      isLoading = true;
    });
    print("result = 1 $isLoading");
    //get the user data from the text feilds
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String bio = bioController.text.trim();
    String userName = usernameController.text.trim();

    //register the user
    String result = await _authMethodes.registerWithEmailAndPassword(
      email: email,
      password: password,
      username: userName,
      bio: bio,
      profilePic: _profileImage!,
    );
    print("### result =$result");
    //show the snak bar if the user is created or not
    if (result == "Email already in use" ||
        result == "weak password" ||
        result == "invalid email") {
      showSnakBar(context, result);
    } else if (result == 'success') {
      //here the pushReplacement is used for remove the back button from the screen
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileLayout(),
            webScreenLayout: WebLayout(),
          ),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void selectImage() async {
    Uint8List profileImage = await pickImage(ImageSource.camera);
    setState(() {
      _profileImage = profileImage;
    });
  }
}
