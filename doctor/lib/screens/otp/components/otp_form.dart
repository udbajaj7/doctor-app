import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../../../components/size_config.dart';
import '../../../components/urls.dart';
import '../../doctor details/components/details_form_1.dart';
import '../../loginScreen/ResetPassScreen.dart';
import '../../loginScreen/components/button_container.dart';
import '../../loginScreen/components/requests.dart';
import 'error_dialog.dart';
import 'requests.dart';

class OtpForm extends StatefulWidget {
  final String phoneNo;
  final bool changePass;
  final String password;
  OtpForm(this.phoneNo, this.changePass, this.password);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  late FocusNode pin1FocusNode;
  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;
  List<int> pin = [0, 0, 0, 0];
  @override
  void initState() {
    super.initState();
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin1FocusNode.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  void prevField(String value, FocusNode focusNode) {
    if (value.length == 0) {
      focusNode.requestFocus();
    }
  }

  final Color color = Color.fromARGB(255, 231, 231, 231);
  int length = 0;
  TextEditingController textEditingController1 = new TextEditingController();
  TextEditingController textEditingController2 = new TextEditingController();
  TextEditingController textEditingController3 = new TextEditingController();
  TextEditingController textEditingController4 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.06),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: SizeConfig.screenHeight * 0.065,
                height: SizeConfig.screenHeight * 0.0775,
                child: Card(
                  elevation: 0,
                  color: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    controller: textEditingController1,
                    cursorColor: Colors.black,
                    cursorHeight: 32,
                    focusNode: pin1FocusNode,
                    autofocus: true,
                    obscureText: true,
                    style: TextStyle(fontSize: 32),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: color,
                      focusColor: color,
                      hoverColor: color,
                    ),
                    onChanged: (value) {
                      if ((value.length - length) > 1 &&
                          value.length == 4 &&
                          isNumeric(value)) {
                        String OTP = value;
                        pin[0] = int.parse(OTP[0]);
                        pin[1] = int.parse(OTP[1]);
                        pin[2] = int.parse(OTP[2]);
                        pin[3] = int.parse(OTP[3]);
                        setState(() {
                          pin1FocusNode.unfocus();
                          textEditingController1.text = pin[0].toString();
                          textEditingController2.text = pin[1].toString();
                          textEditingController3.text = pin[2].toString();
                          textEditingController4.text = pin[3].toString();
                        });
                      } else {
                        nextField(value, pin2FocusNode);
                        if (value != "") pin[0] = int.parse(value);
                      }
                      length = textEditingController1.text.length;
                    },
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.screenHeight * 0.065,
                height: SizeConfig.screenHeight * 0.0775,
                child: Card(
                  elevation: 0,
                  color: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    controller: textEditingController2,
                    cursorColor: Colors.black,
                    cursorHeight: 32,
                    autofocus: true,
                    obscureText: true,
                    focusNode: pin2FocusNode,
                    style: TextStyle(fontSize: 32),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: color,
                      focusColor: color,
                      hoverColor: color,
                    ),
                    onChanged: (value) {
                      if (value != "") pin[1] = int.parse(value);
                      nextField(value, pin3FocusNode);
                      prevField(value, pin1FocusNode);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.screenHeight * 0.065,
                height: SizeConfig.screenHeight * 0.0775,
                child: Card(
                  elevation: 0,
                  color: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    cursorHeight: 32,
                    controller: textEditingController3,
                    autofocus: true,
                    focusNode: pin3FocusNode,
                    obscureText: true,
                    style: TextStyle(fontSize: 32),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: color,
                      focusColor: color,
                      hoverColor: color,
                    ),
                    onChanged: (value) {
                      if (value != "") pin[2] = int.parse(value);
                      nextField(value, pin4FocusNode);
                      prevField(value, pin2FocusNode);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.screenHeight * 0.065,
                height: SizeConfig.screenHeight * 0.0775,
                child: Card(
                  elevation: 0,
                  color: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: textEditingController4,
                    cursorHeight: 32,
                    autofocus: true,
                    focusNode: pin4FocusNode,
                    obscureText: true,
                    style: TextStyle(fontSize: 32),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: color,
                      focusColor: color,
                      hoverColor: color,
                    ),
                    onChanged: (value) {
                      if (value != "") pin[3] = int.parse(value);
                      if (value.length == 1) {
                        pin4FocusNode.unfocus();
                        // Then you need to check is the code is correct or not
                      }
                      prevField(value, pin3FocusNode);
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.1,
          ),
          Text(
            "Didn’t receive an OTP?",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color.fromARGB(255, 144, 144, 144)),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.02,
          ),
          GestureDetector(
            onTap: () {
              resendOtp(widget.phoneNo).then((value) {
                if (value == "Success") {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("New Otp has been sent")));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ErrorDialog(context, value, true),
                  ));
                }
              });
            },
            child: Text(
              "Resend OTP??",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.1,
          ),
          GestureDetector(
            onTap: () {
              String otp = "";
              pin.forEach((element) {
                otp += element.toString();
              });
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return FutureBuilder(
                    future: sendOtpForVerification(otp, widget.phoneNo),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == "Success" &&
                            widget.changePass == false) {
                          prefs.setString("password", widget.password);
                          metaData.password = widget.password;
                          return DetailsForm1(widget.phoneNo);
                        } else if (snapshot.data == "Success" &&
                            widget.changePass == true)
                          return ResetPassScreen(widget.phoneNo);
                        else if (snapshot.data!.toString().contains("Error")) {
                          return ErrorDialog(
                              context, snapshot.data.toString(), false);
                        } else
                          return SpinKitPouringHourGlass(color: Colors.grey);
                      } else
                        return SpinKitPouringHourGlass(color: Colors.grey);
                    },
                  );
                },
              ));
            },
            child: buttonContainer(context, "Verify & Proceed"),
          ),
        ],
      )),
    );
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}

class Number {
  final PhoneNumber phoneNumber;
  Number({required this.phoneNumber});
}
