import 'package:doctor/screens/loginScreen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorDialogLogin extends StatelessWidget {
  final BuildContext context;
 
  final String text;
  ErrorDialogLogin(this.context, this.text);

  @override
  Widget build(BuildContext _context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
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
                  
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
                  
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
