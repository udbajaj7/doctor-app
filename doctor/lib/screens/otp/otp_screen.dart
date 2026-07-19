import 'package:doctor/screens/otp/components/error_dialog_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../../components/size_config.dart';
import '../../components/urls.dart';
import 'components/error_dialog.dart';
import 'components/requests.dart';
import 'components/scaffold.dart';

class OtpScreen extends StatefulWidget {
  final PhoneNumber phoneNo;
  final String password;
  OtpScreen(this.phoneNo, this.password);

  static String routeName = "/otp";

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Future<String> _sendPhoneNumber, _sendForChangingPass;
  @override
  void initState() {
    super.initState();
    _sendPhoneNumber = funcSendPhoneNumber(widget.phoneNo, widget.password);
    if (widget.password == "")
      _sendForChangingPass = funcSendPhoneNumberForPwdChange(widget.phoneNo);
  }

  @override
  Widget build(BuildContext context) {
    prefs.setString('password', widget.password);
    metaData.password = widget.password;
    SizeConfig().init(context);
    return widget.password != ""
        ? FutureBuilder(
            future: _sendPhoneNumber,
            // ignore: missing_return
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData &&
                  asyncSnapshot.connectionState == ConnectionState.done) {
                if (asyncSnapshot.data.toString().contains("Error")) {
                  return ErrorDialogLogin(
                      context, asyncSnapshot.data.toString());
                } else {
                  return scaffold(
                      context, false, widget.phoneNo.number, widget.password);
                }
              } else
                return Scaffold(
                  body: SpinKitPouringHourGlass(color: Colors.grey, size: 100),
                  backgroundColor: Colors.white,
                );
            })
        : FutureBuilder(
            future: _sendForChangingPass,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData) {
                if (asyncSnapshot.data.toString().contains("Error")) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ErrorDialog(context,
                                asyncSnapshot.data.toString(), false)));
                  });
                } else {
                  return scaffold(
                      context, true, widget.phoneNo.number, widget.password);
                }
              }
              return Scaffold(
                body: SpinKitPouringHourGlass(color: Colors.grey, size: 100),
                backgroundColor: Colors.white,
              );
            });
  }
}
