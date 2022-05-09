import 'package:ambicare_user/constants/constants.dart';
import 'package:flutter/material.dart';

class IconTilesComponent extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String title;
  final Color iconColor;
  const IconTilesComponent(
      {Key? key,
      required this.icon,
      required this.onTap,
      required this.title,
      required this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
          size: 60.0,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: kDarkRedColor,
            fontFamily: 'Ubuntu',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
