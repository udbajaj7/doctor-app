import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/size_config.dart';
import 'otp_form.dart';

class Body extends StatelessWidget {
  final String phoneNo;
  final bool changePass;
  final String password;
  Body(this.phoneNo, this.changePass, this.password);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.04),
              SizedBox(
                height: height * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Image.asset(
                        "assets/images/shield.png",
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.04),
              SizedBox(
                height: height * 0.027,
                child: FittedBox(
                  child: Text(
                    "Please enter the verification code ",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.027,
                child: FittedBox(
                  child: Text(
                    "sent to the WhatsApp Number:",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.027,
                child: FittedBox(
                  child: Text(
                    "+91 " + phoneNo,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              OtpForm(phoneNo, changePass, password),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "This code will expire in ",
          style: TextStyle(
              fontFamily: "Colfax",
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none),
        ),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: Duration(seconds: 30),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(
                fontFamily: "Colfax",
                color: Color.fromARGB(255, 235, 87, 87),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none),
          ),
        ),
      ],
    );
  }
}
