import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Padding heading(String heading) {
  return Padding(
    padding: const EdgeInsets.only(left: 45, top: 10),
    child: Text(
      heading,
      style: GoogleFonts.publicSans(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Color.fromARGB(255, 158, 158, 158)),
    ),
  );
}
