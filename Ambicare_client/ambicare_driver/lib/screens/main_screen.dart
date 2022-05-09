import 'package:ambicare_driver/constants/constants.dart';
import 'package:ambicare_driver/screens/ambulance_details.dart';
import 'package:ambicare_driver/screens/history_screen.dart';
import 'package:ambicare_driver/screens/maps_screen.dart';
import 'package:ambicare_driver/screens/profile_screen.dart';
import 'package:ambicare_driver/services/notification.dart';
import 'requests_page.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const id = '/HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    NotificationHandler.onMessageHandler();
    NotificationHandler.resolveToken();
  }

  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(TextController());
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        // dragStartBehavior: DragStartBehavior.down,
        controller: tabController,
        children: const [
          Requests(),
          History(),
          AmbulanceDetails(),
          Profile(),
          // Drivers(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kDarkRedColor,
        // backgroundColor: Colors.green,
        // selectedItemColor: const Color(0xffd17842),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined), label: "All"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.carOutline), label: "Ambulance"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.personOutline), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            tabController!.index = _selectedIndex;
          });
        },
      ),
    );
  }
}
