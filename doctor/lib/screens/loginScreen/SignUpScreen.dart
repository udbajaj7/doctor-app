import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../components/urls.dart';
import '../otp/otp_screen.dart';
import 'components/button_container.dart';
import 'components/heading.dart';
import 'components/lower_body.dart';
import 'components/middle_body.dart';
import 'components/rich_text.dart';
import 'components/upper_body.dart';
import 'loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late PhoneNumber _phoneNo;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passformKey = GlobalKey<FormState>();
  bool hidePassword = true, hideConfpass = true;
  TextEditingController c = TextEditingController();
  late String password, confirmPass;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var scaffoldHeight = size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
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
                      ...middleBody(scaffoldHeight, "Create Account",
                          "Let’s get Started"),
                      SizedBox(
                        height: scaffoldHeight * 0.05,
                      ),
                      SizedBox(
                          height: scaffoldHeight * 0.13,
                          child: _buildPhoneNo()),
                      SizedBox(
                        height: scaffoldHeight * 0.01,
                      ),
                      SizedBox(
                          height: scaffoldHeight * 0.13,
                          child: _buildPassword()),
                      SizedBox(
                        height: scaffoldHeight * 0.01,
                      ),
                      SizedBox(
                          height: scaffoldHeight * 0.13,
                          child: _buildConfirmPassword()),
                      SizedBox(
                        height: scaffoldHeight * 0.07,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!_passformKey.currentState!.validate()) {
                            return;
                          }
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          prefs.setString("phoneNumber", _phoneNo.number);

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) =>
                                    OtpScreen(_phoneNo, password),
                              ),
                              (route) => false);
                        },
                        child: buttonContainer(context, "SIGN UP"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: scaffoldHeight * 0.01,
              ),
              SizedBox(
                height: scaffoldHeight * 0.04,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: richText('Already have an account? ', 'Login')),
              ),
              lowerBody(scaffoldHeight, context)
            ],
          ),
        ));
  }

  Widget _buildPassword() {
    return Form(
      key: _passformKey,
      child: Container(
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
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                validator: (value) {
                  if (password.isEmpty || password == "")
                    return "The Password field should not be empty!";
                  else if (password.length < 6)
                    return "The Password length should be atleast 6!";
                  else
                    return null;
                },
                style: GoogleFonts.mulish(fontWeight: FontWeight.w800),
                obscureText: hidePassword,
                cursorColor: Colors.black,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline_sharp,
                    color: Colors.black,
                    size: 20,
                  ),
                  enabledBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  suffixIcon: IconButton(
                    icon: hidePassword
                        ? const Icon(
                            Icons.visibility_outlined,
                            color: Colors.black,
                          )
                        : const Icon(Icons.visibility_off_outlined),
                    color: Colors.black,
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
              cursorColor: Colors.black,
              style: GoogleFonts.mulish(fontWeight: FontWeight.w800),
              scrollPadding: EdgeInsets.only(bottom: 60),
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
                prefixIcon: const Icon(
                  Icons.lock_outline_sharp,
                  color: Colors.black,
                  size: 20,
                ),
                enabledBorder:
                    const UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    const UnderlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: hideConfpass
                      ? const Icon(
                          Icons.visibility_outlined,
                          color: Colors.black,
                        )
                      : const Icon(Icons.visibility_off_outlined,
                          color: Colors.black),
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

  Widget _buildPhoneNo() {
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
            heading("CONTACT NO. (WhatsApp Registered)"),
            TextFormField(
              controller: c,
              validator: (value) {
                if (value!.length == 10)
                  return null;
                else
                  return "Enter a valid Contact Number";
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              cursorColor: Colors.black,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.call_outlined,
                  color: Colors.black,
                  size: 20,
                ),
                counter: Padding(
                  padding: const EdgeInsets.only(right: 4, bottom: 4),
                  child: Text(
                    c.value.text.length.toString() + "/10",
                    style: GoogleFonts.publicSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: c.text.length != 10
                            ? Color.fromARGB(255, 158, 158, 158)
                            : Colors.green),
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w800, color: Color(0xFF665D5D)),
              onChanged: (value) {
                if (value.length == 10) {
                  FocusManager.instance.primaryFocus!.unfocus();
                }
                setState(() {
                  _phoneNo = PhoneNumber(
                      number: value, countryCode: '', countryISOCode: '');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
