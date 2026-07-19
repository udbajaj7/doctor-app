import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<Widget> middleBody(double scaffoldHeight, String text1, String text2) {
  return [
    SizedBox(
      height: scaffoldHeight * 0.005,
    ),
    SizedBox(
      height: scaffoldHeight * 0.03,
      child: FittedBox(
        child: Text(
          text1,
          style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w700, fontSize: 30, color: Colors.black),
        ),
      ),
    ),
    SizedBox(
      height: scaffoldHeight * 0.005,
    ),
    SizedBox(
      height: scaffoldHeight * 0.02,
      child: FittedBox(
        child: Text(
          text2,
          style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey),
        ),
      ),
    ),
  ];
}
