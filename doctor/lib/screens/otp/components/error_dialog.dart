import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorDialog extends StatelessWidget {
  final BuildContext context;
  final bool popTwice;
  final String text;
  ErrorDialog(this.context, this.text, this.popTwice);

  @override
  Widget build(BuildContext _context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Center(
          child: AlertDialog(
            title: Text(
              "Error Occurred",
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black),
            ),
            content: Text(
              text,
              style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (popTwice) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else
                    Navigator.pop(context);
                },
                child: Text(
                  "Retry!",
                  style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
