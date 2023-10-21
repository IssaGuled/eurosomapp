// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../resources/colors.dart';

class DefTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color? color;
  final String? Function(String?)? validate;
  final onSubmitted;
  final Icon? icon;
  final bool isPassword;
  final TextInputType? type;

  const DefTextForm({
    Key? key,
    this.validate,
    required this.controller,
    required this.hintText,
    this.color,
    this.icon,
    this.type,
    this.isPassword = false,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: TextFormField(
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 14,
          ),
          controller: controller,
          obscureText: isPassword,
          keyboardType: type,
          validator: validate,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: InkWell(
              onTap: () {
                controller.clear();
              },
              child: const Icon(
                Icons.highlight_remove_outlined,
                color: Colors.black,
              ),
            ),
            hintStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              fontSize: 14,
            ),
            prefixIcon: icon,
            border: InputBorder.none,
            filled: true,
            fillColor: Color.fromRGBO(255, 243, 107, 0.25),

            // color ?? AppColors.hardColor.withOpacity(0.5)
          ),
        ),
      ),
    );
  }
}
