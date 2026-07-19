import 'dart:convert';

import 'package:flutter/cupertino.dart';

class PatientModel {
  String email, gender, firstName, lastName;
  int id, age;
  String city;
  String phoneNumber;

  PatientModel(
      {required this.id,
      required this.email,
      required this.gender,
      required this.firstName,
      required this.lastName,
      required this.city,
      required this.age,
      required this.phoneNumber});

  Object toJson() {
    return jsonEncode(<String, dynamic>{
      'first_name': this.firstName,
      'last_name': this.lastName,
      'phone_number': this.phoneNumber,
      'email': this.email,
      'age': this.age,
      'gender': this.gender,
      'city': this.city,
    });
  }

  Object toJson2() {
    return jsonEncode(<String, dynamic>{
      'id': this.id,
      'first_name': this.firstName,
      'last_name': this.lastName,
      'phone_number': this.phoneNumber,
      'email': this.email,
      'age': this.age,
      'gender': this.gender,
      'city': this.city,
    });
  }

  factory PatientModel.fromJson(Map<String, dynamic> parsedJson) {
    debugPrint(parsedJson.toString());
    return PatientModel(
      id: parsedJson["id"],
      firstName: parsedJson["first_name"],
      lastName: parsedJson["last_name"] == null ? "" : parsedJson["last_name"],
      phoneNumber: parsedJson["phone_number"],
      email: parsedJson["email"],
      age: parsedJson["age"],
      gender: parsedJson["gender"],
      city: parsedJson["city"],
    );
  }
}
