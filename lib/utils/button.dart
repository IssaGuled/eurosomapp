import 'package:flutter/material.dart';

import '../resources/colors.dart';

class DefButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final VoidCallback onPressed;
  final bool isLoading;
  final double width;
  final Color? color;
  final double? hight;
  const DefButton(
      {Key? key,
      required this.text,
      this.textStyle,
      this.color,
      required this.onPressed,
      this.isLoading = false,
      this.width = 250,
      this.hight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: hight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: color,
            gradient: color != null
                ? null
                : const LinearGradient(colors: AppColors.gradiantColors)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: MaterialButton(
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: textStyle ??
                      const TextStyle(color: Colors.white, fontSize: 18),
                ),
                if (isLoading)
                  const SizedBox(
                    width: 10,
                  ),
                if (isLoading)
                  const SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 0.8,
                        color: Colors.white,
                      )),
              ],
            )));
  }
}
