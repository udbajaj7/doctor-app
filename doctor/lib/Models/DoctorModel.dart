import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

class DoctorModel {
  late int id;
  late String firstName;
  late String lastName;
  late String gender;
  late int age;
  late String phoneNumber;
  late String email;
  late String registrationNumber;
  late String specialization;
  late String degrees;
  late int appointmentFees;
  late String clinicName;
  late String clinicAddress;
  late String city;
  late String category;
  late int avgTime;
  late int patPerSlot;
  late List<dynamic> timing;
  late String timeSlots;
  late String contactNumber;
  late List<String> treatmentNames = ["Braces"];
  late List<int> treatmentPrices = [200];
  DoctorModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.age,
      required this.phoneNumber,
      required this.email,
      required this.registrationNumber,
      required this.specialization,
      required this.degrees,
      required this.appointmentFees,
      required this.clinicName,
      required this.clinicAddress,
      required this.city,
      required this.avgTime,
      required this.patPerSlot,
      required this.timing,
      required this.category,
      required this.contactNumber}) {
    patPerSlot = 1;
    timing = List.generate(
        7,
        (index) => List.generate(
            3,
            (index) =>
                [TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 0, minute: 0)]),
        growable: false);
  }

  Object toJson1() {
    return jsonEncode(<String, dynamic>{
      'category': this.category,
      'first_name': this.firstName,
      'last_name': this.lastName,
      'city': this.city,
      'age': this.age,
      'gender': this.gender,
      'phone_number': this.phoneNumber,
      'email': this.email,
      'registration_number': this.registrationNumber,
      'specialization': this.specialization,
      'degrees': this.degrees,
      'appointment_fees': this.appointmentFees,
      'clinic_name': this.clinicName,
      'clinic_address': this.clinicAddress,
      'avg_time': this.avgTime,
      'timing': this.timeSlots,
      'pat_per_slot': this.patPerSlot,
      'contact_number': this.contactNumber
    });
  }

  Object toJson2() {
    return jsonEncode(<String, dynamic>{
      'id': this.id,
      'category': this.category,
      'first_name': this.firstName,
      'last_name': this.lastName,
      'city': this.city,
      'age': this.age,
      'gender': this.gender,
      'phone_number': this.phoneNumber,
      'email': this.email,
      'registration_number': this.registrationNumber,
      'specialization': this.specialization,
      'degrees': this.degrees,
      'appointment_fees': this.appointmentFees,
      'clinic_name': this.clinicName,
      'clinic_address': this.clinicAddress,
      'avg_time': this.avgTime,
      'timing': this.timeSlots,
      'pat_per_slot': this.patPerSlot,
      'contact_number': this.contactNumber
    });
  }

  static DoctorModel copyWith(DoctorModel d) {
    return new DoctorModel(
        category: d.category,
        id: d.id,
        firstName: d.firstName,
        age: d.age,
        appointmentFees: d.appointmentFees,
        avgTime: d.avgTime,
        city: d.city,
        clinicAddress: d.clinicAddress,
        clinicName: d.clinicName,
        contactNumber: d.contactNumber,
        degrees: d.degrees,
        email: d.email,
        gender: d.gender,
        lastName: d.lastName,
        patPerSlot: d.patPerSlot,
        phoneNumber: d.phoneNumber,
        registrationNumber: d.registrationNumber,
        specialization: d.specialization,
        timing: d.timing);
  }

  DoctorModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    age = json['age'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    registrationNumber = json['registration_number'];
    specialization = json['specialization'];
    degrees = json['degrees'];
    appointmentFees = json['appointment_fees'];
    clinicName = json['clinic_name'];
    clinicAddress = json['clinic_address'];
    city = json['city'];
    avgTime = json['avg_time'];
    timing = json["timing"];
    contactNumber = json["contact_number"];
    patPerSlot = json["pat_per_slot"];
  }
}
