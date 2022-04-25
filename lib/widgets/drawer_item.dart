import 'package:briefify/data/constants.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color col;
  final VoidCallback onTap;

  const DrawerItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.col,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: col,
            ),
            const SizedBox(width: 18),
            Text(
              title,
              style: const TextStyle(
                color: kSecondaryTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
