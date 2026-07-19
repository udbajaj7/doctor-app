import 'package:flutter/material.dart';

class DoctorInfo {
  String firstName,
      lastName,
      city,
      mobile,
      clinicName,
      specialization,
      degree,
      fees,
      clinicAddress,
      avgTime,
      gender,
      email,
      registrationNo;
  int age;
  List<Day> days = [];
  DoctorInfo({
    required this.clinicAddress,
    required this.avgTime,
    required this.city,
    required this.clinicName,
    required this.degree,
    required this.fees,
    required this.mobile,
    required this.firstName,
    required this.lastName,
    required this.specialization,
    required this.email,
    required this.gender,
    required this.age,
    required this.registrationNo,
    required this.days,
  }) {
    this.days = [];
    for (int i = 0; i < 7; i++) {
      this.days.add(new Day(
          endTimes: List.filled(3, TimeOfDay(hour: 21, minute: 0)),
          startTimes: List.filled(3, TimeOfDay(hour: 8, minute: 0)),
          sitOrNot: false));
    }
  }
}

class Day {
  bool sitOrNot = false, has2Slots = false, has3Slots = false;
  List<TimeOfDay> startTimes = List.filled(3, TimeOfDay.now()),
      endTimes = List.filled(3, TimeOfDay.now());
  Day({required this.sitOrNot, required this.startTimes, required this.endTimes});
}
