import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Center buttonContainer(BuildContext context, String text) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.84,
      height: MediaQuery.of(context).size.height * 0.06,
      color: Colors.black,
      child: Center(
          child: Text(
        text,
        style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
      )),
    ),
  );
}
