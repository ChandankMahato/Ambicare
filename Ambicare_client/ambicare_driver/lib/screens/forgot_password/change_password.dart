import 'package:ambicare_driver/components/custom_button.dart';
import 'package:ambicare_driver/components/custom_password_field.dart';
import 'package:ambicare_driver/components/custom_text_field.dart';
import 'package:ambicare_driver/components/waiting_dialog.dart';
import 'package:ambicare_driver/main.dart';
import 'package:ambicare_driver/screens/signin_screen.dart';
import 'package:ambicare_driver/services/database.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ambicare_driver/constants/constants.dart';

class ChangePassword extends StatefulWidget {
  static const String id = "/changePassword";
  final Map<String, dynamic>? args;
  const ChangePassword({Key? key, this.args}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final newPasswordController = TextEditingController();
  final newPasswordAgainController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    newPasswordAgainController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 50.0,
            left: 30.0,
            right: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("images/logo.png"),
              const SizedBox(
                height: 40.0,
              ),
              const Text(
                "Enter New Password",
                style: TextStyle(
                  color: kLightRedColor,
                  fontSize: 20.0,
                  fontFamily: ubuntu,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: Text(
                        "NEW PASSWORD",
                        textAlign: TextAlign.center,
                        style: kTextFieldLabelStyle.copyWith(
                          fontSize: 14.3,
                          fontFamily: "Ubuntu",
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    CustomTextField(
                      controller: newPasswordController,
                      isPassword: true,
                      icon: EvaIcons.lockOutline,
                    ),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: Text(
                        "NEW PASSWORD",
                        textAlign: TextAlign.center,
                        style: kTextFieldLabelStyle.copyWith(
                          fontSize: 14.3,
                          fontFamily: "Ubuntu",
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    CustomTextField(
                      controller: newPasswordAgainController,
                      isPassword: true,
                      icon: EvaIcons.lockOutline,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              CustomButton(
                onPressed: () async {
                  //TODO: change password
                  if (formKey.currentState!.validate()) {
                    if (newPasswordAgainController.text !=
                        newPasswordController.text) {
                      return showSnackBar(
                        context,
                        "Passwords doesnot match",
                        Colors.red,
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WaitingDialog(title: "Changing"),
                      );
                      final result = await Database.changePassword({
                        "phoneNumber": widget.args!["phoneNumber"],
                        "newPassword": newPasswordController.text,
                      });
                      if (result! ~/ 100 == 2) {
                        navigatorKey.currentState!.pop();
                        navigatorKey.currentState!.pop();
                        navigatorKey.currentState!.pop();
                        showSnackBar(context, "Password changed", Colors.green);
                      } else {
                        navigatorKey.currentState!.pop();
                        showSnackBar(context, "Password couldnot be changed",
                            Colors.red);
                      }
                    }
                  }
                },
                width: double.infinity,
                buttonColor: kLightRedColor,
                borderRadius: 10.0,
                buttonContent: Text(
                  "CHANGE PASSWORD",
                  style: kButtonContentTextStye.copyWith(
                    color: kWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
