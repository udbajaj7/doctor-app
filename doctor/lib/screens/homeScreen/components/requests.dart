import 'package:doctor/Models/Appointment.dart';
import 'package:doctor/providers/appointmentProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../../Models/DoctorBookings.dart';
import '../../../Models/PatientModel.dart';
import '../../../components/urls.dart';
import '../../../providers/httpClientProvider.dart';

final PatientModel dummyPatForSkeleton = PatientModel(
    id: -1,
    email: "",
    gender: "",
    firstName: "",
    lastName: "",
    city: "",
    age: -1,
    phoneNumber: "");
final DoctorBookingsModel dummyBookingForSkeleton = DoctorBookingsModel(
    date: "",
    startTime: "",
    slotTime: "0",
    endTime: "",
    docId: -1,
    patId: -1,
    batchNumber: -1,
    slotNumber: -1,
    bookingId: -1,
    treatment: "",
    consentForm: false,
    balance: 0,
    notes: "",
    installment: 0);

Future<String> addNotes(int bookingId, String notes) async {
  final response = await ConnectionService().returnConnection().post(
      Uri.parse(docNotesUrl),
      headers: header,
      body: jsonEncode(
          <String, dynamic>{"booking_id": bookingId, "notes": notes}));

  if (response.statusCode == 200) {
    return "Success";
  } else
    return "Error";
}

Future<String> cancelAppointment(int bookingId) async {
  final response = await ConnectionService().returnConnection().post(
        Uri.parse(cancelBooking),
        headers: header,
        body: jsonEncode(<String, dynamic>{"booking_id": bookingId}),
      );
  if (response.statusCode == 200) {
    return "Success";
  } else {
    var responseJson = json.decode(response.body.toString());
    return "Error: " + responseJson["message"];
  }
}

Future getCurrentPatients(int docId) async {
  var response = await http.post(Uri.parse(getCurrentPatientUrl),
      body: jsonEncode(<String, int>{
        "doc_id": docId,
      }),
      headers: header);
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body.toString());
    debugPrint(response.body);
    BookedResponse jsonResp = BookedResponse.fromJson(jsonResponse);
    List<DoctorBookingsModel> bookList = jsonResp.bookings;
    List<PatientModel> patList = jsonResp.patients;
    return {"pats": patList, "books": bookList};
  } else
    return {"pats": [], "books": []};
}

Future<String> deleteFileApi(int bookingId, String fileName) async {
  final response = await ConnectionService()
      .returnConnection()
      .post(Uri.parse(deleteFileUrl),
          headers: header,
          body: jsonEncode(<String, dynamic>{
            "booking_id": bookingId,
            "file_name": fileName,
          }));
  print("deleting");
  print(response.statusCode);
  if (response.statusCode == 200) {
    return "Done";
  }
  return "Error";
}

Future updateBalance(int bookingId, int balance, int paid) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(updateBalanceUrl),
      body: jsonEncode(<String, int>{
        "booking_id": bookingId,
        "balance": balance,
        "paid": paid
      }),
      headers: header);
  if (response.statusCode == 200) {
    return "Success";
  } else
    return "Error";
}

Future<String> endAppointmentButtonPressed(int docId, int? bookingID) async {
  var response = await ConnectionService()
      .returnConnection()
      .post(Uri.parse(endAppointmentUrl),
          body: jsonEncode(<String, dynamic>{
            "doc_id": docId,
            "booking_id": bookingID,
          }),
          headers: header);
  print("sending patient in API request body");
  print(endAppointmentUrl);

  print(response.statusCode);
  print(header);
  print(response.body);
  if (response.statusCode == 200) {
    debugPrint(response.body);
    return "Done";
  } else
    return "Error";
}

Future<String> editTreatmentApi(int bookingId, String? treatment) async {
  var response = await ConnectionService()
      .returnConnection()
      .post(Uri.parse(editTreatmentUrl),
          body: jsonEncode(<String, dynamic>{
            "treatment": treatment,
            "booking_id": bookingId,
          }),
          headers: header);
  print(response.body);
  if (response.statusCode == 200) {
    debugPrint(response.body);
    return "Done";
  } else
    return "Error";
}

Future<String> sendInButtonPressed(
    int docId, int? nextBookingID, int? curr) async {
  var response = await ConnectionService()
      .returnConnection()
      .post(Uri.parse(sendInButtonUrl),
          body: jsonEncode(<String, dynamic>{
            "doc_id": docId,
            "current": curr,
            "send": nextBookingID,
          }),
          headers: header);
  print("sending patient in API request body");
  print(jsonEncode(<String, dynamic>{
    "doc_id": docId,
    "current": curr,
    "send": nextBookingID,
  }));
  print(response.statusCode);
  if (response.statusCode == 200) {
    debugPrint(response.body);
    return "Done";
    // Check request
  } else
    return "Error";
}

Future<String> getBookingQueue(int docId, BuildContext context) async {
  final AppointmentProvider appointmentProvider =
      Provider.of<AppointmentProvider>(context, listen: false);
  print(docId);
  print("calling booking queue");
  var response = await http.post(Uri.parse(waitingQueueUrl),
      body: jsonEncode(<String, int>{
        "doc_id": docId,
      }),
      headers: header);

  print(response.statusCode);
  print(response.body.toString());

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body.toString());
    debugPrint(response.body);
    BookedResponse jsonResp = BookedResponse.fromJson(jsonResponse);
    List<DoctorBookingsModel> bookList = jsonResp.bookings;
    List<PatientModel> patList = jsonResp.patients;
    List<Appointment> appointments = [];
    for (int i = 0; i < bookList.length; i++) {
      appointments.add(Appointment(
          doctorBookingsModel: bookList[i], patientModel: patList[i]));
    }
    appointmentProvider.setBookAppoin(appointments);
    return "Done";
  } else
    return "Error";
}

Future<String> getReachedQueue(int docId, BuildContext context) async {
  print("calling reached queue with doc id $docId");
  final AppointmentProvider appointmentProvider =
      Provider.of<AppointmentProvider>(context, listen: false);
  var response = await http.post(Uri.parse(reachedQueueUrl),
      body: jsonEncode(<String, int>{
        "doc_id": docId,
      }),
      headers: header);
  if (response.statusCode == 200) {
    var currentPatients = await getCurrentPatients(docId);
    var jsonResponse = json.decode(response.body.toString());
    debugPrint("Reached queue ${response.body}");
    ReachedResponse jsonResp = ReachedResponse.fromJson(jsonResponse);
    List<DoctorBookingsModel> bookList = jsonResp.bookings,
        bookCurr = currentPatients["books"];
    List<PatientModel> patList = jsonResp.patients,
        patCurr = currentPatients["pats"];
    List<int> timeLeft = jsonResp.timeLeft;

    List<Appointment> reached = [], curr = [];
    for (int i = 0; i < bookList.length; i++) {
      reached.add(Appointment(
          doctorBookingsModel: bookList[i],
          patientModel: patList[i],
          timeLeft: timeLeft[i]));
    }

    for (int i = 0; i < patCurr.length; i++) {
      curr.add(Appointment(
          doctorBookingsModel: bookCurr[i], patientModel: patCurr[i]));
    }

    appointmentProvider.setCurrAndReachedAppoin(curr, reached);
    return "Done";
  } else
    return "Error";
}

class ReachedResponse {
  final List<PatientModel> patients;
  final List<DoctorBookingsModel> bookings;
  final List<int> timeLeft;

  ReachedResponse(
      {required this.patients, required this.bookings, required this.timeLeft});

  factory ReachedResponse.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson["Patients"] as List;
    List<PatientModel> patList =
        list.map((i) => PatientModel.fromJson(i)).toList();
    var list1 = parsedJson["Bookings"] as List;
    List<DoctorBookingsModel> bookingsList =
        list1.map((i) => DoctorBookingsModel.fromJson(i)).toList();
    var list2 = parsedJson["time_left"] as List;
    List<int> _timeLeft = list2.map((i) => i as int).toList();
    return ReachedResponse(
        patients: patList, bookings: bookingsList, timeLeft: _timeLeft);
  }
}

class BookedResponse {
  final List<PatientModel> patients;
  final List<DoctorBookingsModel> bookings;

  BookedResponse({required this.patients, required this.bookings});

  factory BookedResponse.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson["Patients"] as List;
    List<PatientModel> patList =
        list.map((i) => PatientModel.fromJson(i)).toList();
    var list1 = parsedJson["Bookings"] as List;
    List<DoctorBookingsModel> bookingsList =
        list1.map((i) => DoctorBookingsModel.fromJson(i)).toList();
    return BookedResponse(patients: patList, bookings: bookingsList);
  }
}

Future<String> addDelay(int docId, TimeOfDay time) async {
  int minutes = time.hour * 60 + time.minute;
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(addDelayUrl),
      body: jsonEncode(<String, int>{"doc_id": docId, "delay": minutes}),
      headers: header);
  print(response.statusCode);
  if (response.statusCode == 200) {
    print("delay added in minutes are {$minutes} doc id is $docId");
    //Response does not have a body here
    //var jsonResponse = jsonDecode(response.body);
    // print(jsonResponse);
    return "Success";
  }
  return "";
}
