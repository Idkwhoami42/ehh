import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors

const Color black = Colors.black;
const Color white = Colors.white;
const Color primary = Color(0xffff0000);

// Fonts

final defaultFont = GoogleFonts.roboto().fontFamily;

void losefocus(BuildContext context) {
  final currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}
