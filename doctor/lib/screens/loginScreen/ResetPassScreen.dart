import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/button_container.dart';
import 'components/heading.dart';
import 'components/lower_body.dart';
import 'components/requests.dart';
import 'components/upper_body.dart';
import 'loginScreen.dart';

class ResetPassScreen extends StatefulWidget {
  final String phoneNo;
  ResetPassScreen(this.phoneNo);

  @override
  _ResetPassScreenState createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool hidePassword = true, hideConfpass = true;
  TextEditingController c = TextEditingController();
  String password = "", confirmPass = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var scaffoldHeight = size.height - MediaQuery.of(context).viewPadding.top;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ...upperBody(context, scaffoldHeight),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: scaffoldHeight * 0.04,
                      ),
                      SizedBox(
                        height: scaffoldHeight * 0.035,
                        child: FittedBox(
                          child: Text(
                            "Create New Password",
                            style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: scaffoldHeight * 0.05,
                      ),
                      SizedBox(
                          height: scaffoldHeight * 0.124,
                          child: _buildPassword()),
                      SizedBox(
                        height: scaffoldHeight * 0.02,
                      ),
                      SizedBox(
                          height: scaffoldHeight * 0.1,
                          child: _buildConfirmPassword()),
                      SizedBox(
                        height: scaffoldHeight * 0.1,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => FutureBuilder(
                                  future: changePass(widget.phoneNo, password),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data
                                          .toString()
                                          .contains("Error")) {
                                        return Scaffold(
                                          body: Center(
                                            child: AlertDialog(
                                              title: Text(
                                                "Error Occurred",
                                                style: GoogleFonts.publicSans(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                              content: Text(
                                                snapshot.data.toString(),
                                                style: GoogleFonts.publicSans(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ResetPassScreen(
                                                                    widget
                                                                        .phoneNo)),
                                                        (route) => false);
                                                  },
                                                  child: Text(
                                                    "Retry",
                                                    style:
                                                        GoogleFonts.publicSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return LoginScreen();
                                      }
                                    } else
                                      return SpinKitPouringHourGlass(
                                          color: Colors.grey);
                                  },
                                ),
                              ),
                              (route) => false);
                        },
                        child: buttonContainer(context, "Change Password"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: scaffoldHeight * 0.13,
              ),
              lowerBody(scaffoldHeight, context)
            ],
          ),
        ));
  }

  Widget _buildPassword() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 0,
          blurRadius: 8,
          offset: Offset(0, 0),
        ),
      ]),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading("PASSWORD"),
            TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 40),
              style: GoogleFonts.mulish(fontWeight: FontWeight.w800),
              obscureText: hidePassword,
              obscuringCharacter: "*",
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              validator: (value) {
                if (password.length < 6)
                  return "The Password length should be atleast 6!";
                else
                  return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline_sharp,
                  color: Colors.black,
                  size: 20,
                ),
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: hidePassword
                      ? Icon(
                          Icons.visibility_outlined,
                          color: Colors.black,
                        )
                      : Icon(Icons.visibility_off_outlined),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmPassword() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 0,
          blurRadius: 8,
          offset: Offset(0, 0),
        ),
      ]),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading("CONFIRM PASSWORD"),
            TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 40),
              style: GoogleFonts.mulish(fontWeight: FontWeight.w800),
              obscureText: hideConfpass,
              obscuringCharacter: "*",
              onChanged: (value) {
                confirmPass = value;
              },
              validator: (value) {
                if (confirmPass != password) {
                  return "Passwords Do not Match!";
                } else
                  return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline_sharp,
                  color: Colors.black,
                  size: 20,
                ),
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: hideConfpass
                      ? Icon(
                          Icons.visibility_outlined,
                          color: Colors.black,
                        )
                      : Icon(Icons.visibility_off_outlined),
                  onPressed: () {
                    setState(() {
                      hideConfpass = !hideConfpass;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
