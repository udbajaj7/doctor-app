import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'dart:convert';

import '../../../components/urls.dart';
import '../../../providers/httpClientProvider.dart';

Future<String> funcSendPhoneNumber(PhoneNumber phoneNo, String password) async {
  print("sending phone number $phoneNo $password");
  var response =
      await ConnectionService().returnConnection().post(Uri.parse(phoneRegUrl),
          body: jsonEncode(<String, String>{
            "phone_number": phoneNo.number.toString(),
            "password": password,
            "user_type": "doctor"
          }),
          headers: <String, String>{
        'Accept': '*/*',
        'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
        'Content-Type': 'application/json',
      });
  print(response.statusCode);
  var responseJson = json.decode(response.body.toString());
  print(responseJson["otp"]);
  if (response.statusCode == 200) {
    return "Success";
  } else {
    return "Error: " + responseJson["message"];
  }
}

Future<String> funcSendPhoneNumberForPwdChange(PhoneNumber phoneNo) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(forgetPassOtpUrl),
      body: jsonEncode(<String, String>{"phone_number": phoneNo.number}),
      headers: <String, String>{
        'Accept': '*/*',
        'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
        'Content-Type': 'application/json',
      });
  var responseJson = json.decode(response.body.toString());
  print(responseJson["otp"]);
  if (response.statusCode == 200) {
    return "Success";
  } else
    return "Error: " + responseJson["message"];
}

Future<String> sendOtpForVerification(String otp, String phoneNo) async {
  var response = await ConnectionService()
      .returnConnection()
      .post(Uri.parse(otpVerificationUrl),
          body: jsonEncode(<String, String>{
            "phone_number": phoneNo,
            "otp": otp,
          }),
          headers: <String, String>{
        'Accept': '*/*',
        'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
        'Content-Type': 'application/json',
      });
  var jsonResponse = json.decode(response.body.toString());
  debugPrint(response.body);
  if (jsonResponse["status"] == 200) {
    return "Success";
  } else
    return "Error: " + jsonResponse["message"];
}
