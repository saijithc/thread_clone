import 'package:flutter/material.dart';
import 'package:thread_clone/responsive/mobile_layout.dart';
import 'package:thread_clone/responsive/responsive_layout_screen.dart';
import 'package:thread_clone/responsive/web_layout.dart';
import 'package:thread_clone/screens/authentication/register_screen.dart';
import 'package:thread_clone/services/auth_services.dart';
import 'package:thread_clone/utils/snack_bar.dart';
import 'package:thread_clone/widgets/custom_text_field.dart';
import 'package:thread_clone/widgets/submit_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.3,
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
              SizedBox(
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
              SubmitButton(
                text: isLoading ? "Processing..." : "Login",
                onPressed: loginUser,
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t  have an account?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ));
                      },
                      child: const Text(
                        'Register',
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
    ));
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    String result = await AuthMethods().loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    //show the snak bar if the user is created or not

    if (result == "email-already-in-use" ||
        result == "weak-password" ||
        result == "invalid-email") {
      showSnakBar(context, result);
    } else if (result == 'success') {
      //here the pushReplacement is used for remove the back button from the screen

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            webScreenLayout: WebLayout(),
            mobileScreenLayout: MobileLayout(),
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });

    print("user logged in");
  }
}
