import 'dart:core';
import 'package:ambicare_user/components/app_drawer.dart';
import 'package:ambicare_user/components/custom_button.dart';
import 'package:ambicare_user/components/waiting_dialog.dart';
import 'package:ambicare_user/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSupport extends StatefulWidget {
  static const String id = "/mail";
  const UserSupport({Key? key}) : super(key: key);

  @override
  State<UserSupport> createState() => _UserSupportState();
}

class _UserSupportState extends State<UserSupport> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  Future launchEmail({
    required String toEmail,
    required String subject,
    required String message,
  }) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';
    try {
      if (await canLaunch(url)) {
        await launch(url);
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  String? validate(String? value) {
    if (value!.trim().isEmpty) {
      return "Required";
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Support'),
        centerTitle: true,
        backgroundColor: kDarkRedColor,
        foregroundColor: kWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'To:',
                      style: TextStyle(
                        color: kDarkRedColor,
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ambicare Support',
                      style: TextStyle(
                        color: kDarkRedColor,
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            buildTextFiled(
              title: 'Subject:',
              controller: subjectController,
              hint: 'Enter Subject',
              validator: validate,
            ),
            const SizedBox(
              height: 25.0,
            ),
            buildTextFiled(
              title: 'Message:',
              controller: messageController,
              hint: 'Enter your message here',
              maxLines: 10,
              validator: validate,
            ),
            const SizedBox(
              height: 20,
            ),
            NewCustomButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          const WaitingDialog(title: "Sending"));
                  await launchEmail(
                    toEmail: 'cmahato2000@gmail.com',
                    subject: subjectController.text.trim(),
                    message: messageController.text.trim(),
                  );
                }
              },
              width: 200,
              height: 50,
              buttonTitle: 'Send Mail',
              color: kLightRedColor,
              textColor: kWhite,
              boldText: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFiled({
    required String title,
    required TextEditingController controller,
    required String hint,
    required Function validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kDarkRedColor,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validate,
          cursorColor: kDarkRedColor,
          decoration: InputDecoration(
            fillColor: kWhite,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kDarkRedColor, width: 2.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kDarkRedColor, width: 2.0),
            ),
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
