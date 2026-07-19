import 'package:flutter/material.dart';
import '../../../components/standard_app_bar.dart';
import 'body.dart';

Scaffold scaffold(BuildContext context, bool boolean, String number,String password) {
  return Scaffold(
    appBar: standardAppBar(context, "OTP Verification"),
    backgroundColor: Colors.white,
    body: Body(number, boolean,password),
  );
}
