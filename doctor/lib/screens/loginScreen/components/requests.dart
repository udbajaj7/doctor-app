import 'package:doctor/Models/DoctorModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../components/urls.dart';
import 'dart:convert';

import '../../../providers/httpClientProvider.dart';

Future<String> logInFuture(String phoneNo, String password) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(signInUrl),
      body: jsonEncode(<String, String>{
        "phone_number": phoneNo,
        "password": password,
        "user_type": "doctor"
      }),
      headers: <String, String>{
        'Accept': '*/*',
        'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
        'Content-Type': 'application/json',
      });
  print("Login response code : ${response.statusCode}");

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body.toString());
    print(responseJson);
    return responseJson["id"].toString();
  } else {
    var responseJson = json.decode(response.body.toString());
    return "Error: " + responseJson["message"];
  }
}

Future<String> resendOtp(String phoneNo) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(resendOtpUrl),
      body: jsonEncode(<String, String>{"phone_number": phoneNo}),
      headers: <String, String>{
        'Accept': '*/*',
        'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
        'Content-Type': 'application/json',
      });
  print("resend otp ");
  print(jsonEncode(
      <String, String>{"phone_number": phoneNo, "user_type": "patient"}));
  print(response.statusCode);
  var responseJson = json.decode(response.body.toString());
  print(responseJson["otp"]);
  if (response.statusCode == 200) {
    return "Success";
  } else {
    return "Error: " + responseJson["message"];
  }
}

Future<String> changePass(String phoneNo, String password) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(changePassUrl),
      body: jsonEncode(<String, String>{
        "phone_number": phoneNo,
        "password": password,
        "user_type": "doctor"
      }),
      headers: <String, String>{
        'Accept': '*/*',
        'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
        'Content-Type': 'application/json',
      });
  if (response.statusCode == 200) {
    return "Success";
  } else {
    var responseJson = json.decode(response.body.toString());
    return "Error: " + responseJson["message"];
  }
}

Future<void> getAvailTreatments(String category) async {
  var response = await http.post(
      Uri.parse(getAvailableTreatmentsUrl),
      body: jsonEncode(<String, String>{"category": category}),
      headers: header);

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body.toString());
    GetTreatmentResponse getTreatmentResponse =
        GetTreatmentResponse.fromJson(responseJson);
    docTreatmentsAvailable = getTreatmentResponse.treatments;
    return;
  }
  return;
}

Future<DoctorModel> getDocInfo(int id) async {
  var response = await http.post(
      Uri.parse(getDocInfoUrl),
      body: jsonEncode(<String, int>{"id": id}),
      headers: header);
  print(header);
  print("Getting doctor data for id $id ${response.statusCode}");
  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body.toString());
    GetInfoResponse getInfoResponse = GetInfoResponse.fromJson(responseJson);
    myProfile = getInfoResponse.doctorModel;
    await getAvailTreatments(myProfile.category);
    return getInfoResponse.doctorModel;
  } else {
    return DoctorModel(
        id: -1,
        firstName: "",
        lastName: "",
        gender: "",
        age: -1,
        phoneNumber: "",
        email: "",
        registrationNumber: "",
        specialization: "",
        degrees: "",
        appointmentFees: -1,
        clinicName: "",
        clinicAddress: "",
        city: "",
        avgTime: -1,
        patPerSlot: -1,
        timing: [],
        category: "",
        contactNumber: "");
  }
}

void saveDataToSharedPreference(DoctorModel doctorInfo) {
  String docIds = prefs.getString("DocIds") ?? "";
  prefs.setString("DocIds", docIds + doctorInfo.id.toString() + ",");
  String docNames = prefs.getString("DocNames") ?? "";
  prefs.setString("DocNames", docNames + doctorInfo.firstName + ",");
  saveTimings(doctorInfo.timing);
  prefs.setInt('age', doctorInfo.age);
  prefs.setInt('appointmentFees', doctorInfo.appointmentFees);
  prefs.setString('city', doctorInfo.city);
  prefs.setString('clinicAddress', doctorInfo.clinicAddress);
  prefs.setString('clinicName', doctorInfo.clinicName);
  prefs.setString('degrees', doctorInfo.degrees);
  prefs.setString('email', doctorInfo.email);
  prefs.setString('firstName', doctorInfo.firstName);
  prefs.setString('gender', doctorInfo.gender);
  prefs.setString('lastName', doctorInfo.lastName);
  prefs.setString('phoneNumber', doctorInfo.phoneNumber);
  prefs.setString('registrationNumber', doctorInfo.registrationNumber);
  prefs.setString('specialization', doctorInfo.specialization);
  prefs.setInt('id', doctorInfo.id);
  prefs.setInt('pat_per_slot', doctorInfo.patPerSlot);
  prefs.setInt('avgTime', doctorInfo.avgTime);
  prefs.setString("contact_number", doctorInfo.contactNumber);
  myProfile = DoctorModel.copyWith(doctorInfo);
}

void saveTimings(List<dynamic> timing) {
  List<List<TimeOfDay>> defaultStartTime = List.generate(
      7, (index) => List.generate(3, (index) => TimeOfDay(hour: 0, minute: 0)));
  List<List<TimeOfDay>> defaultEndTime = List.generate(
      7, (index) => List.generate(3, (index) => TimeOfDay(hour: 0, minute: 0)));
  List<bool> _sitOrNot = List.generate(7, (index) => true);
  List<bool> _has2Slots = List.generate(7, (index) => true),
      _has3Slots = List.generate(7, (index) => true);
  List<String> sitOrNot = List.generate(7, (index) => ""),
      has3Slots = List.generate(7, (index) => ""),
      has2Slots = List.generate(7, (index) => "");
  for (int i = 0; i < 7; i++) {
    for (int j = 0; j < 3; j++) {
      defaultStartTime[i][j] = computeSlot(timing[i][j][0].toString());
      defaultEndTime[i][j] = computeSlot(timing[i][j][1].toString());
      if (j == 0) {
        if (defaultStartTime[i][j] == TimeOfDay(hour: 0, minute: 0))
          _sitOrNot[i] = false;
      }
      if (j == 1) {
        if (defaultStartTime[i][j] == TimeOfDay(hour: 0, minute: 0))
          _has2Slots[i] = false;
      }
      if (j == 2) {
        if (defaultStartTime[i][j] == TimeOfDay(hour: 0, minute: 0))
          _has3Slots[i] = false;
      }
    }
  }

  for (var i = 0; i < 7; i++) {
    sitOrNot[i] = _sitOrNot[i].toString();
    has2Slots[i] = _has2Slots[i].toString();
    has3Slots[i] = _has3Slots[i].toString();
  }
  List<String> startTimingToBeFed = [], endTimingToBeFed = [];
  List<String> timingToStore = [];
  defaultStartTime.forEach((dayElement) {
    dayElement.forEach((slotElement) {
      if (slotElement.hour == 0 && slotElement.minute == 0) {
        startTimingToBeFed.add("0,");
      } else {
        startTimingToBeFed.add(convertToString(slotElement) + ",");
      }
    });
  });
  defaultEndTime.forEach((dayElement) {
    dayElement.forEach((slotElement) {
      if (slotElement.hour == 0 && slotElement.minute == 0) {
        endTimingToBeFed.add("0,");
      } else {
        endTimingToBeFed.add(convertToString(slotElement) + ",");
      }
    });
  });

  timingToStore += startTimingToBeFed;
  timingToStore += endTimingToBeFed;
  prefs.setStringList("timings", timingToStore);
  prefs.setStringList("slot2", has2Slots);
  prefs.setStringList("slot3", has3Slots);
  prefs.setStringList("sit", sitOrNot);
}

TimeOfDay computeSlot(String d) {
  d = d.replaceAll(",", "");
  d = d.padLeft(4, "0");
  int hours = int.parse(d.substring(0, 2));
  int minutes = int.parse(d.substring(2, 4));
  TimeOfDay slot = TimeOfDay(hour: hours, minute: minutes);
  return slot;
}

String convertToString(TimeOfDay timeOfDay) {
  String convertedString = timeOfDay.hour.toString().padLeft(2, "0") +
      timeOfDay.minute.toString().padLeft(2, "0");
  return convertedString;
}

class GetInfoResponse {
  final DoctorModel doctorModel;
  GetInfoResponse({required this.doctorModel});

  factory GetInfoResponse.fromJson(Map<String, dynamic> json) {
    return GetInfoResponse(doctorModel: DoctorModel.fromJson(json["doctor"]));
  }
}

class GetTreatmentResponse {
  final List<String> treatments;
  GetTreatmentResponse({required this.treatments});

  factory GetTreatmentResponse.fromJson(Map<String, dynamic> json) {
    var list = json["treatments"] as List;
    List<String> t = list.map((i) => i as String).toList();
    return GetTreatmentResponse(treatments: t);
  }
}
