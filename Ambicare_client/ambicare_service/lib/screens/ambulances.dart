import 'package:ambicare_service/components/continue_dialog.dart';
import 'package:ambicare_service/components/custom_button.dart';
import 'package:ambicare_service/components/custom_text_field.dart';
import 'package:ambicare_service/components/scroll_behaviour.dart';
import 'package:ambicare_service/components/waiting_dialog.dart';
import 'package:ambicare_service/constants/constants.dart';
import 'package:ambicare_service/main.dart';
import 'package:ambicare_service/models/ambulance.dart';
import 'package:ambicare_service/screens/signin_screen.dart';
import 'package:ambicare_service/screens/signup_screen.dart';
import 'package:ambicare_service/screens/splash_screen.dart';
import 'package:ambicare_service/services/auth.dart';
import 'package:ambicare_service/services/database.dart';
import 'package:ambicare_service/services/location.dart';
import 'package:ambicare_service/state/ambulance_type_state.dart';
import 'package:ambicare_service/state/filter_status_colour_state.dart';
import 'package:ambicare_service/state/filter_status_value.dart';
import 'package:ambicare_service/state/filter_type_colour_state.dart';
import 'package:ambicare_service/state/filter_type_value.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Ambulances extends StatefulWidget {
  const Ambulances({Key? key}) : super(key: key);

  @override
  State<Ambulances> createState() => _AmbulancesState();
}

class _AmbulancesState extends State<Ambulances> {
  // List<DropdownMenuItem<String>>? dropDownItems() {
  final registrationController = TextEditingController();
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // int? totalAmbulances;

  @override
  void dispose() {
    registrationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // totalAmbulances = 0;
  }

  List<DropdownMenuItem<String>>? dropDownItems() {
    List<String> items = [
      'Mobile ICU',
      'Basic Life Support',
      'Neonatal',
      'Multiple Victim',
      'Isolation',
    ];
    List<DropdownMenuItem<String>> dropDown = [];
    for (String item in items) {
      dropDown.add(
        DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Ubuntu",
              fontSize: 20.0,
            ),
          ),
        ),
      );
    }
    return dropDown;
  }

  Future<void> logoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SizedBox(
        height: 100,
        child: AlertDialog(
          titlePadding: const EdgeInsets.only(
            top: 10.0,
            // bottom: 10.0,
            left: 24.0,
            right: 24.0,
          ),
          contentPadding: const EdgeInsets.only(
            top: 20.0,
            // bottom: 10.0,
            left: 24.0,
            right: 24.0,
          ),
          actionsPadding: const EdgeInsets.only(
            // top: 20.0,
            bottom: 10.0,
            // left: 24.0,
            // right: 24.0,
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Are you sure?',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 24,
            ),
          ),
          content: const Text(
            'Do you want to logout?',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 20,
            ),
          ),
          actions: [
            NewCustomButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => const WaitingDialog(
                    title: "Logging out",
                  ),
                );
                final result = await Authentication.signOut();
                if (result) {
                  navigatorKey.currentState!
                      .pushNamedAndRemoveUntil(Signin.id, (route) => false);
                  showSnackBar(
                    context,
                    "Signout Successful",
                    Colors.green,
                  );
                } else {
                  navigatorKey.currentState!.pop();
                  showSnackBar(
                    context,
                    "Couldnot signout",
                    Colors.green,
                  );
                }
              },
              width: 100,
              height: 40,
              buttonTitle: 'Log out',
              color: kWhite,
              textColor: kDarkRedColor,
              border: true,
              boldText: false,
            ),
            NewCustomButton(
              onPressed: () {
                navigatorKey.currentState!.pop();
              },
              width: 80,
              height: 40,
              buttonTitle: 'Cancel',
              color: kLightRedColor,
              textColor: kWhite,
              boldText: false,
              border: false,
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets.copyWith(
              top: 30.0,
              left: 30.0,
              right: 30.0,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Ambulance Details",
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            CustomTextField(
              controller: registrationController,
              labelText: "Registration Number",
              icon: EvaIcons.carOutline,
            ),
            const SizedBox(
              height: 30.0,
            ),
            DropdownButton(
              items: dropDownItems(),
              style: const TextStyle(
                color: Colors.white,
              ),
              value: Provider.of<AmbulanceTypeState>(context, listen: true)
                  .ambulanceType,
              onChanged: (value) {
                Provider.of<AmbulanceTypeState>(context, listen: false)
                    .changeState(value as String);
              },
            ),
            const SizedBox(
              height: 50.0,
            ),
            CustomButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  showDialog(
                    context: context,
                    builder: (context) => const WaitingDialog(title: "Saving"),
                  );
                  final position = await Location.determinePosition();
                  final data = {
                    "location": {
                      "longitude": position.longitude,
                      "latitude": position.latitude,
                    },
                    "isAvailable": false,
                    "registrationNumber": registrationController.text.trim(),
                    "ambulanceType": {
                      "type": Provider.of<AmbulanceTypeState>(context,
                              listen: false)
                          .ambulanceType,
                      "farePerKm": 20
                    }
                  };
                  final result = await Database.saveAmbulance(data);

                  if (result! ~/ 100 == 2) {
                    navigatorKey.currentState!.pop();
                    navigatorKey.currentState!.pop();
                    showSnackBar(context, "Ambulance added", Colors.green);
                    setState(() {});
                  } else {
                    navigatorKey.currentState!.pop();
                    navigatorKey.currentState!.pop();
                    showSnackBar(
                        context, "Ambulance couldnot be added", Colors.red);
                  }
                }
              },
              width: double.infinity,
              buttonContent: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      EvaIcons.saveOutline,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "SAVE",
                      style: kButtonContentTextStye,
                    ),
                  ]),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget editAmbulanceBottomSheet(
      BuildContext context, String ambId, String initialType) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.copyWith(
            top: 30.0,
            left: 30.0,
            right: 30.0,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Ambulance Details",
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          DropdownButton(
            items: dropDownItems(),
            style: const TextStyle(
              color: Colors.white,
            ),
            value: Provider.of<AmbulanceTypeState>(context, listen: true)
                .ambulanceType,
            onChanged: (value) {
              Provider.of<AmbulanceTypeState>(context, listen: false)
                  .changeState(value as String);
            },
          ),
          const SizedBox(
            height: 50.0,
          ),
          CustomButton(
            onPressed: () async {
              if (initialType !=
                  Provider.of<AmbulanceTypeState>(context, listen: false)
                      .ambulanceType) {
                showDialog(
                  context: context,
                  builder: (context) => const WaitingDialog(title: "Saving"),
                );

                final result = await Database.updateAmbulanceType(
                  Provider.of<AmbulanceTypeState>(context, listen: false)
                      .ambulanceType,
                  ambId,
                );

                if (result! ~/ 100 == 2) {
                  navigatorKey.currentState!.pop();
                  navigatorKey.currentState!.pop();
                  showSnackBar(context, "Ambulance type updated", Colors.green);
                  setState(() {});
                } else {
                  navigatorKey.currentState!.pop();
                  navigatorKey.currentState!.pop();
                  showSnackBar(context, "Ambulance type couldnot be updated",
                      Colors.red);
                }
              } else {
                navigatorKey.currentState!.pop();
              }
            },
            width: double.infinity,
            buttonContent: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    EvaIcons.saveOutline,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    "SAVE",
                    style: kButtonContentTextStye,
                  ),
                ]),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ambulance'),
        // title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: kDarkRedColor,
        foregroundColor: kWhite,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                logoutDialog(navigatorKey.currentState!.overlay!.context);
              },
              child: const Icon(
                EvaIcons.logOutOutline,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Authentication.signOut();
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              builder: (context) {
                return bottomSheet(context);
              });
          // navigatorKey.currentState!.pushNamed(AddNewAmbulance.id);
        },
        // backgroundColor: const Color(0xffd17842),
        backgroundColor: kLightRedColor,
        child: const Icon(
          EvaIcons.plus,
          color: Colors.white,
        ),
      ),
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40.0,
                child: Row(
                  // shrinkWrap: true,
                  // scrollDirection: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Provider.of<FilterStatusColourState>(context,
                                listen: false)
                            .changeAllState();
                        Provider.of<FilterStatusState>(context, listen: false)
                            .changeState("All");
                      },
                      child: Container(
                        width: 70.0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<FilterStatusColourState>(context,
                                  listen: true)
                              .allColour,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                            child: Text(
                          "All",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily: "Ubuntu",
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<FilterStatusColourState>(context,
                                listen: false)
                            .changeOnlineState();
                        Provider.of<FilterStatusState>(context, listen: false)
                            .changeState("Online");
                      },
                      child: Container(
                        width: 70.0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<FilterStatusColourState>(context,
                                  listen: true)
                              .onlineColour,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                            child: Text(
                          "Online",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily: "Ubuntu",
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<FilterStatusColourState>(context,
                                listen: false)
                            .changeOfflineState();
                        Provider.of<FilterStatusState>(context, listen: false)
                            .changeState("Offline");
                      },
                      child: Container(
                        width: 80.0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<FilterStatusColourState>(context,
                                  listen: true)
                              .offlineColour,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                            child: Text(
                          "Offline",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily: "Ubuntu",
                          ),
                        )),
                      ),
                    ),
                    // const SizedBox(
                    //   width: 20.0,
                    // ),
                    // Container(
                    //   width: 70.0,
                    //   padding: const EdgeInsets.symmetric(
                    //     vertical: 5.0,
                    //     horizontal: 10.0,
                    //   ),
                    //   decoration: BoxDecoration(
                    //       color: kDarkRedColor,
                    //       borderRadius: BorderRadius.circular(10.0),
                    //       boxShadow: const [
                    //         BoxShadow(
                    //           color: Colors.black26,
                    //           blurRadius: 10.0,
                    //           spreadRadius: 5.0,
                    //           offset: Offset(7, 7),
                    //         ),
                    //       ]),
                    //   child: const Center(
                    //       child: Text(
                    //     "Online",
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 15.0,
                    //       fontFamily: "Ubuntu",
                    //     ),
                    //   )),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 40.0,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Provider.of<FilterTypeColourState>(context,
                                listen: false)
                            .changeAllState();
                        Provider.of<FilterTypeState>(context, listen: false)
                            .changeState("All");
                      },
                      child: Container(
                        width: 70.0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<FilterTypeColourState>(context,
                                  listen: true)
                              .allColour,
                          borderRadius: BorderRadius.circular(10.0),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black26,
                          //     blurRadius: 10.0,
                          //     spreadRadius: 5.0,
                          //     // offset: Offset(5, 5),
                          //   ),
                          // ],
                        ),
                        child: const Center(
                            child: Text(
                          "All",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily: "Ubuntu",
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<FilterTypeColourState>(context,
                                listen: false)
                            .changeMobileICUState();
                        Provider.of<FilterTypeState>(context, listen: false)
                            .changeState("Mobile ICU");
                      },
                      child: Container(
                        width: 120.0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<FilterTypeColourState>(context,
                                  listen: true)
                              .mobileICUColour,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                            child: Text(
                          "Mobile ICU",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily: "Ubuntu",
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<FilterTypeColourState>(context,
                                listen: false)
                            .changeBasicLifeSupportState();
                        Provider.of<FilterTypeState>(context, listen: false)
                            .changeState("Basic Life Support");
                      },
                      child: Container(
                        width: 160.0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<FilterTypeColourState>(context,
                                  listen: true)
                              .basicLifeSupportColour,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                            child: Text(
                          "Basic Life Support",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily: "Ubuntu",
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<FilterTypeColourState>(context,
                                listen: false)
                            .changeMultipleVictimState();
                        Provider.of<FilterTypeState>(context, listen: false)
                            .changeState("Multiple Victim");
                      },
                      child: Container(
                        width: 140.0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<FilterTypeColourState>(context,
                                  listen: true)
                              .multipleVictimColour,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                            child: Text(
                          "Multiple Victim",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily: "Ubuntu",
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<FilterTypeColourState>(context,
                                listen: false)
                            .changeNeonatalState();
                        Provider.of<FilterTypeState>(context, listen: false)
                            .changeState("Neonatal");
                      },
                      child: Container(
                        width: 100.0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<FilterTypeColourState>(context,
                                  listen: true)
                              .neonatalColour,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                            child: Text(
                          "Neonatal",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily: "Ubuntu",
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<FilterTypeColourState>(context,
                                listen: false)
                            .changeIsolationState();
                        Provider.of<FilterTypeState>(context, listen: false)
                            .changeState("Isolation");
                      },
                      child: Container(
                        width: 100.0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<FilterTypeColourState>(context,
                                  listen: true)
                              .isloationColour,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                            child: Text(
                          "Isolation",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily: "Ubuntu",
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              FutureBuilder<List>(
                future: Database.getAllAmbulances(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        const Text(
                          'You have no ambulances',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Network Error!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                    );
                  }
                  final ambulances = snapshot.data!;
                  allAmbulances = ambulances;
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: ambulances.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final Ambulance? ambulance =
                            Ambulance.fromData(data: ambulances[index]);
                        String? ambStatus =
                            ambulance!.isAvailable ? "Online" : "Offline";
                        if ((Provider.of<FilterStatusState>(context,
                                            listen: true)
                                        .filterStatus ==
                                    ambStatus ||
                                Provider.of<FilterStatusState>(context,
                                            listen: true)
                                        .filterStatus ==
                                    "All") &&
                            (Provider.of<FilterTypeState>(context, listen: true)
                                        .filterType ==
                                    ambulance.type ||
                                Provider.of<FilterTypeState>(context,
                                            listen: true)
                                        .filterType ==
                                    "All")) {
                          // totalAmbulances = totalAmbulances! + 1;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 30.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: kDarkRedColor,
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10.0,
                                    spreadRadius: 5.0,
                                    offset: Offset(7, 7),
                                  ),
                                ]),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,\
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Reg No: ${ambulance.registrationNumber}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.0,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      Text(
                                        "Type: ${ambulance.type}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Status: ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    continueDialog(
                                                  title: "Hide Car",
                                                  message:
                                                      "Are you sure you want to continue?",
                                                  yesContent: "Confirm",
                                                  noContent: "Cancel",
                                                  onYes: () async {
                                                    navigatorKey.currentState!
                                                        .pop();
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          CircularProgressIndicator(
                                                            color: Colors.white,
                                                            backgroundColor:
                                                                Colors.black,
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                    final result =
                                                        await Database
                                                            .changeAvailability(
                                                      ambulance.isAvailable
                                                          ? false
                                                          : true,
                                                      ambulance.id,
                                                    );
                                                    if (result! ~/ 100 == 2) {
                                                      navigatorKey.currentState!
                                                          .pop();
                                                      (ambulance.isAvailable)
                                                          ? showSnackBar(
                                                              scaffoldKey
                                                                  .currentContext!,
                                                              "The ambulance is now hidden from all users",
                                                              Colors.green,
                                                            )
                                                          : showSnackBar(
                                                              scaffoldKey
                                                                  .currentContext!,
                                                              "The ambulance is now visible to all users",
                                                              Colors.green,
                                                            );
                                                      setState(() {});
                                                    } else {
                                                      navigatorKey.currentState!
                                                          .pop();
                                                      showSnackBar(
                                                          scaffoldKey
                                                              .currentContext!,
                                                          "The process couldnoot be completed",
                                                          kLightRedColor);
                                                    }

                                                    // setState(() {});
                                                  },
                                                  onNo: () {
                                                    navigatorKey.currentState!
                                                        .pop();
                                                  },
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 10.0,
                                              ),
                                              decoration: BoxDecoration(
                                                // color: Colors.grey,
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Text(
                                                ambulance.isAvailable
                                                    ? "Online"
                                                    : "Offline",
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16.0,
                                                  fontFamily: "Montserrat",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      Text(
                                        ambulance.driver == null
                                            ? "Driver: Not Assigned"
                                            : "Driver: ${ambulance.driver!["name"]}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 18.0),
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(40.0),
                                                  topRight:
                                                      Radius.circular(40.0),
                                                ),
                                              ),
                                              builder: (context) =>
                                                  editAmbulanceBottomSheet(
                                                      context,
                                                      ambulance.id,
                                                      ambulance.type));
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                16.0,
                                              ),
                                            ),
                                          ),

                                          child: const Icon(
                                            Icons.description,
                                            color: Color(0xFF5962DA),
                                            size: 20.0,
                                          ),
                                          // ],
                                          // ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 18.0),
                                      child: InkWell(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                continueDialog(
                                              title: "Delete Ambulance",
                                              message:
                                                  "Are you sure you want to continue?",
                                              yesContent: "Confirm",
                                              noContent: "Cancel",
                                              onYes: () async {
                                                navigatorKey.currentState!
                                                    .pop();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      const WaitingDialog(
                                                          title: "Deleting"),
                                                );
                                                final result = await Database
                                                    .deleteAmbulance(
                                                  ambulance.id,
                                                );
                                                if (result! ~/ 100 == 2) {
                                                  navigatorKey.currentState!
                                                      .pop();
                                                  showSnackBar(
                                                    scaffoldKey.currentContext!,
                                                    "Ambulance successfully deleted",
                                                    Colors.green,
                                                  );
                                                  setState(() {});
                                                } else {
                                                  navigatorKey.currentState!
                                                      .pop();
                                                  showSnackBar(
                                                    scaffoldKey.currentContext!,
                                                    "Ambulance couldnot be deleted",
                                                    Colors.red,
                                                  );
                                                }
                                              },
                                              onNo: () {
                                                navigatorKey.currentState!
                                                    .pop();
                                              },
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                16.0,
                                              ),
                                            ),
                                          ),
                                          child: const Icon(
                                            // Icons.cancel,
                                            Icons.delete,
                                            color: kDarkRedColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          // return Container();
                          // if (totalAmbulances == 0) {
                          //   return Column(
                          //     children: [
                          //       SizedBox(
                          //         height:
                          //             MediaQuery.of(context).size.height * 0.3,
                          //       ),
                          //       const Text(
                          //         'You have no ambulances',
                          //         style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 25,
                          //         ),
                          //       ),
                          //     ],
                          //   );
                          // } else {
                          return Container();
                          // }
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class AmbulancesStream extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     // return Container();
//     return
//   }
// }
