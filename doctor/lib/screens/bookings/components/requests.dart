import 'dart:convert';
import 'package:doctor/Models/DoctorBookings.dart';
import 'package:doctor/Models/MedicalFiles.dart';
import 'package:tuple/tuple.dart';

import '../../../Models/PatientModel.dart';
import '../../../components/urls.dart';
import '../../../providers/httpClientProvider.dart';

Future getBalance(int bookingId) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(getBalanceUrl),
      body: jsonEncode(<String, int>{"booking_id": bookingId}),
      headers: header);
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body.toString());
    print("balance is .........");
    print(jsonResponse["balance"]);
    return Tuple2(jsonResponse["balance"], jsonResponse["installment"] ?? 0);
  } else
    return null;
}

Future<List<DoctorBookingsModel>> getPatientAllBookings(int patId) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(getAllPatientBookings),
      body: jsonEncode(<String, int>{"pat_id": patId, "doc_id": myProfile.id}),
      headers: header);
  print("getting all booking for patient");
  print(getAllPatientBookings);
  print(<String, int>{"pat_id": patId, "doc_id": myProfile.id});
  print(response.statusCode);
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body.toString());
    print("got response for patient all bookings");
    PatientAllBookingResponse bookingResponse =
        PatientAllBookingResponse.fromJson(jsonResponse);

    return bookingResponse.bookings;
  } else
    return [];
}

Future<String> editPatientDetail(PatientModel patient) async {
  var response = await ConnectionService().returnConnection().post(
      Uri.parse(editPatientUrl),
      headers: header,
      body: patient.toJson2());

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "Error: " + response.body.toString().replaceAll("Error ", "");
  }
}

class PatientAllBookingResponse {
  final List<DoctorBookingsModel> bookings;

  PatientAllBookingResponse({required this.bookings});

  factory PatientAllBookingResponse.fromJson(Map<String, dynamic> parsedJson) {
    var list1 = parsedJson["Bookings"] as List;
    List<DoctorBookingsModel> bookingsList =
        list1.map((i) => DoctorBookingsModel.fromJson(i)).toList();
    return PatientAllBookingResponse(bookings: bookingsList);
  }
}

Future<String> uploadFileAPi(
    int bookingId, List<MedicalFiles> encodedFile) async {
  // print(encodedFile.toJson());

  final response = await ConnectionService().returnConnection().post(
      Uri.parse(sendFileUrl),
      headers: header,
      body: jsonEncode(
          <String, dynamic>{"booking_id": bookingId, 'files': encodedFile}));
  print(response.statusCode);
  if (response.statusCode == 200) return "Done";
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

Future<Tuple2<List<MedicalFiles>, List<MedicalFiles>>?> getTreatmentFiles(
    int bookingId) async {
  final response = await ConnectionService()
      .returnConnection()
      .post(Uri.parse(getTreatmentFileUrl),
          headers: header,
          body: jsonEncode(<String, dynamic>{
            "booking_id": bookingId,
          }));
  print(response.statusCode);

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body.toString());
    List<MedicalFiles> files = List<MedicalFiles>.from(
        responseJson["files"].map((file) => MedicalFiles.fromJson(file)));
    print(files);
    List<MedicalFiles> images = [];
    List<MedicalFiles> documents = [];
    files.forEach((f) {
      String extention = f.fileName.split('.').last;
      if (["jpg", "jpeg", "png"].contains(extention))
        images.add(f);
      else
        documents.add(f);
      print(extention);
    });
    print("images are : ${images}");
    print("Documents are : ${documents}");
    return Tuple2(images, documents);
  }
  return Tuple2([], []);
}
