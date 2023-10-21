import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerItem extends StatelessWidget {
  final String? image;
  final IconData? icon;
  final String text;
  final VoidCallback onPressed;

  const DrawerItem({
    Key? key,
    this.image,
    required this.text,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            if (image != null)
              Image.asset(
                image!,
                color: Colors.white,
              ),
            if (icon != null)
              Icon(
                icon,
                color: Colors.white,
              ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 1,
              height: 15,
              color: Colors.white30,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
