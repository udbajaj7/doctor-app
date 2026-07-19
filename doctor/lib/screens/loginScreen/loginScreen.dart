import 'package:doctor/Models/DoctorModel.dart';
import 'package:doctor/screens/otp/components/error_dialog_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../../components/urls.dart';
import '../doctor details/components/details_form_1.dart';
import '../homeScreen/homeScreen.dart';
import '../otp/otp_screen.dart';
import 'SignUpScreen.dart';
import 'components/button_container.dart';
import 'components/heading.dart';
import 'components/lower_body.dart';
import 'components/middle_body.dart';
import 'components/requests.dart';
import 'components/rich_text.dart';
import 'components/upper_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late PhoneNumber _phoneNo;
  String _password = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool hidePassword = true;
  TextEditingController c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var scaffoldHeight = size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
        key: _scaffoldKey,
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
                      ...middleBody(scaffoldHeight, "Login",
                          "Please sign in to continue"),
                      SizedBox(
                        height: scaffoldHeight * 0.06,
                      ),
                      SizedBox(
                          height: scaffoldHeight * 0.13,
                          child: _buildPhoneNo()),
                      SizedBox(
                        height: scaffoldHeight * 0.03,
                      ),
                      SizedBox(
                          height: scaffoldHeight * 0.11,
                          child: _buildPassword()),
                      SizedBox(
                        height: scaffoldHeight * 0.02,
                      ),
                      SizedBox(
                        height: scaffoldHeight * 0.02,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                _formKey.currentState!.save();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OtpScreen(_phoneNo, "")));
                              },
                              child: FittedBox(
                                child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.publicSans(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 46, 96, 224)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: scaffoldHeight * 0.06,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FutureBuilder(
                                future: logInFuture(_phoneNo.number, _password),
                                builder: (builderContext, snapshot) {
                                  print("snapshot had data ${snapshot.data}");
                                  if (snapshot.hasData) {
                                    if (snapshot.data
                                        .toString()
                                        .contains("Error")) {
                                      return ErrorDialogLogin(builderContext,
                                          snapshot.data.toString());
                                    } else if (int.parse(
                                            snapshot.data.toString()) >
                                        -1) {
                                      myProfile.id =
                                          int.parse(snapshot.data.toString());
                                      myProfile.phoneNumber = _phoneNo.number;

                                      metaData.password = _password;
                                      prefs.setString(
                                          "phoneNumber", _phoneNo.number);
                                      prefs.setString("password", _password);
                                      initializeHeader();
                                      return FutureBuilder(
                                        future: getDocInfo(myProfile.id),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            print("login future has data");
                                            print(snapshot.data);
                                            prefs.setBool("isLoggedIn", true);
                                            prefs.setInt(
                                                "currentDocId", myProfile.id);
                                            metaData.isLoggedIn = true;
                                            myProfile.phoneNumber =
                                                _phoneNo.number;

                                            DoctorModel doctorModel =
                                                snapshot.data as DoctorModel;
                                            if (doctorModel.age != -1) {
                                              saveDataToSharedPreference(
                                                  doctorModel);
                                              SchedulerBinding.instance
                                                  .addPostFrameCallback(
                                                (timeStamp) {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                HomeScreen(),
                                                          ),
                                                          (route) => false);
                                                },
                                              );
                                              return SpinKitPouringHourGlass(
                                                  color: Colors.grey);
                                            } else {
                                              return ErrorDialogLogin(
                                                context,
                                                "Error occurred in fetching details!",
                                              );
                                            }
                                          } else {
                                            return SpinKitPouringHourGlass(
                                                color: Colors.grey);
                                          }
                                        },
                                      );
                                    } else if (int.parse(
                                            snapshot.data.toString()) ==
                                        -1) {
                                      prefs.setString(
                                          "phoneNumber", _phoneNo.number);
                                      prefs.setString("password", _password);
                                      initializeHeader();
                                      return DetailsForm1(_phoneNo.number);
                                    } else {
                                      prefs.setString(
                                          "phoneNumber", _phoneNo.number);
                                      prefs.setString("password", _password);
                                      initializeHeader();
                                      return OtpScreen(_phoneNo, _password);
                                    }
                                  } else
                                    return SpinKitPouringHourGlass(
                                        color: Colors.grey);
                                },
                              ),
                            ),
                          );
                        },
                        child: buttonContainer(context, "LOGIN"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: scaffoldHeight * 0.02,
              ),
              SizedBox(
                height: scaffoldHeight * 0.04,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpScreen()));

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => SignUpScreen()));
                    },
                    child: richText('Don\'t have an account? ', 'Sign up')),
              ),
              SizedBox(
                height: scaffoldHeight * 0.06,
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
              validator: (value) {
                if (_password == "")
                  return null;
                else
                  return null;
              },
              onChanged: (value) {
                _password = value;
              },
              style: GoogleFonts.mulish(fontWeight: FontWeight.w800),
              obscureText: hidePassword,
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

  bool autoValidateOrNot = false;

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
            heading("CONTACT NO."),
            TextFormField(
              autovalidateMode: autoValidateOrNot
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
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
                  setState(() {
                    autoValidateOrNot = true;
                  });
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
