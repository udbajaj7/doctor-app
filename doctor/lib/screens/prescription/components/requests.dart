import 'dart:convert';

import 'package:doctor/Models/PrescriptionModel.dart';
import 'package:doctor/components/urls.dart';

import '../../../providers/httpClientProvider.dart';

Future<PrescriptionObject> getPrescription(int bookingID) async {
  var response = await ConnectionService().returnConnection().get(
      Uri.parse(getPrescriptionUrl + "?booking_id=" + bookingID.toString()),
      headers: header);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body.toString());
    PrescriptionObject prescriptionObject =
        PrescriptionObject.fromJson(jsonResponse);
    return prescriptionObject;
  } else
    return PrescriptionObject();
}
