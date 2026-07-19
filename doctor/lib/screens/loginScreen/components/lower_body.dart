import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget lowerBody(double scaffoldHeight, BuildContext context) {
  return SizedBox(
    height: scaffoldHeight * 0.12,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Image.asset(
                  "assets/images/plus2.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo_without_title.png",
                  height: 45, width: 45),
              SizedBox(
                height: 10,
              ),
              Text(
                "INCUE",
                style: GoogleFonts.josefinSans(
                    fontWeight: FontWeight.w600, fontSize: 15),
              )
            ],
          ),
        ),
        Spacer()
      ],
    ),
  );
}
