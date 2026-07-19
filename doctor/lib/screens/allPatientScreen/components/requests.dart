import 'dart:convert';

import '../../../Models/PatientModel.dart';
import '../../../components/urls.dart';
import '../../../providers/httpClientProvider.dart';

Future<List<PatientModel>> getAllPatientsFuture(int docId) async {
  print("calling all patient api");
  final response = await ConnectionService().returnConnection().post(
        Uri.parse(getAllPatientsUrl),
        headers: header,
        body: jsonEncode(<String, dynamic>{"doc_id": docId}),
      );
  print(response.statusCode);
  if (response.statusCode == 200) {
    print("All patients are here");
    var responseJson = json.decode(response.body.toString());
    var list = responseJson["Patients"] as List;
    List<PatientModel> patList =
        list.map((i) => PatientModel.fromJson(i)).toList();
    return patList;
  } else {
    return [];
  }
}
