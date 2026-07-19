import 'package:doctor/config/app_config.dart';
import 'package:doctor/utils/app_logger.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import '../../../components/urls.dart';
import '../../../providers/httpClientProvider.dart';

Future<String> funcSendPhoneNumber(PhoneNumber phoneNo, String password) async {
  try {
    var response = await ConnectionService()
        .returnConnection()
        .post(Uri.parse(phoneRegUrl),
            body: jsonEncode(<String, String>{
              "phone_number": phoneNo.number.toString(),
              "password": password,
              "user_type": "doctor"
            }),
            headers: <String, String>{
              'Accept': '*/*',
              'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
              'Content-Type': 'application/json',
            })
        .timeout(AppConfig.httpTimeout);
    logDebug("send phone number response: ${response.statusCode}");
    var responseJson = json.decode(response.body.toString());
    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Error: " + responseJson["message"];
    }
  } on TimeoutException {
    return "Error: Request timed out. Please try again.";
  } on SocketException {
    return "Error: No internet connection.";
  }
}

Future<String> funcSendPhoneNumberForPwdChange(PhoneNumber phoneNo) async {
  try {
    var response = await ConnectionService()
        .returnConnection()
        .post(Uri.parse(forgetPassOtpUrl),
            body: jsonEncode(<String, String>{"phone_number": phoneNo.number}),
            headers: <String, String>{
              'Accept': '*/*',
              'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
              'Content-Type': 'application/json',
            })
        .timeout(AppConfig.httpTimeout);
    var responseJson = json.decode(response.body.toString());
    if (response.statusCode == 200) {
      return "Success";
    } else
      return "Error: " + responseJson["message"];
  } on TimeoutException {
    return "Error: Request timed out. Please try again.";
  } on SocketException {
    return "Error: No internet connection.";
  }
}

Future<String> sendOtpForVerification(String otp, String phoneNo) async {
  try {
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
            })
        .timeout(AppConfig.httpTimeout);
    var jsonResponse = json.decode(response.body.toString());
    if (jsonResponse["status"] == 200) {
      return "Success";
    } else
      return "Error: " + jsonResponse["message"];
  } on TimeoutException {
    return "Error: Request timed out. Please try again.";
  } on SocketException {
    return "Error: No internet connection.";
  }
}
