// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:ambicare_service/screens/admin/tab_pages/cars.dart';
// import 'package:ambicare_service/screens/admin/tab_pages/comingup_orders.dart';
// import 'package:ambicare_service/services/notification.dart';
import 'package:ambicare_service/constants/constants.dart';
import 'package:ambicare_service/screens/ambulances.dart';
import 'package:ambicare_service/screens/drivers.dart';
import 'package:ambicare_service/screens/history_screen.dart';
import 'package:ambicare_service/screens/maps_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
// import 'tab_pages/orders.dart';

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
          MapsPage(),
          Ambulances(),
          Drivers(),
          History(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kDarkRedColor,
        // selectedItemColor: const Color(0xffd17842),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined), label: "All"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.carOutline), label: "Ambulance"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.personOutline), label: "Drivers"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
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
