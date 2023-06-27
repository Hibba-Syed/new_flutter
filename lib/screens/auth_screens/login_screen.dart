
import 'package:flutter/material.dart';
import 'package:new_flutter/screens/auth_screens/signup_screen.dart';

import '../../services/firebase_services.dart';
import '../../utils/styles.dart';
import '../../widget/app_button.dart';
import '../../widget/apptextfield.dart';
import '../dashboard.dart';
import '../home_page.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailC = TextEditingController();
  bool ispassword = true;

  TextEditingController passwordC = TextEditingController();
  Future<void> ecoDialogue(String error) async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(error),
            actions: [
              AppButton(
                title: 'CLOSE',
                onPress: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  submit() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        formStateLoading = true;
      });

      String? accountstatus =
          await FirebaseServices.signInAccount(emailC.text, passwordC.text);

      //print(accountstatus);
      if (accountstatus != null) {
        ecoDialogue(accountstatus);
        setState(() {
          formStateLoading = false;
        });
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => Dashboard()));
      }
    }
  }

  final formkey = GlobalKey<FormState>();
  bool formStateLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "WELCOME \n Please Login First",
                textAlign: TextAlign.center,
                style: AppStyle.boldStyle,
              ),
              Column(
                children: [
                  Form(
                      key: formkey,
                      child: Column(
                        children: [
                          AppTextField(
                            controller: emailC,
                            hintText: "Email...",
                            validate: (v) {
                              if (v!.isEmpty) {
                                return "email is badly formatted";
                              }
                              return null;
                            },
                          ),
                          AppTextField(
                            controller: passwordC,
                            icon: IconButton(
                              onPressed: () {
                                setState(() {
                                  ispassword = !ispassword;
                                });
                              },
                              icon: ispassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                            hintText: "Password...",
                            validate: (v) {
                              if (v!.isEmpty) {
                                return "password is badly formated";
                              }
                              return null;
                            },
                          ),
                          AppButton(
                            title: "LOGIN",
                            isLoading: formStateLoading,
                            isLoginButton: true,
                            onPress: () {
                              submit();
                            },
                          ),
                        ],
                      )),
                ],
              ),
              AppButton(
                title: "CREATE NEW ACCOUNT",
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SignupScreen()));
                },
                isLoginButton: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
