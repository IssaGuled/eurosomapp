import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final bool isAnemated;
  const AnimatedText({required this.text, required this.isAnemated});

  @override
  State createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  @override
  Widget build(BuildContext context) {
    return widget.isAnemated
        ? AnimatedTextKit(
      displayFullTextOnTap:true,

            isRepeatingAnimation:true,
            animatedTexts: [
              TypewriterAnimatedText(
                widget.text,
                speed: const Duration(milliseconds: 30),
                textStyle:GoogleFonts.poppins(fontWeight:FontWeight.w300,color:Colors.black,fontSize:16)
              ),
            ],
            pause: const Duration(seconds: 1),
            totalRepeatCount: 1,
          )
        : Text(
            widget.text,
            style:GoogleFonts.poppins(fontWeight:FontWeight.w300,color:Colors.black,fontSize:16)
    ,
          );
  }
}
