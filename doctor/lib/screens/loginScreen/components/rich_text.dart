import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

RichText richText(String text1, String text2) {
  return RichText(
    text: TextSpan(
        text: text1,
        style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey),
        children: <TextSpan>[
          TextSpan(
            text: text2,
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          )
        ]),
  );
}
