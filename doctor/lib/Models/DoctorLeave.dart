import 'dart:convert';

class DoctorLeaveModel {
  int docId;
  String startTime;
  String endTime;
  DoctorLeaveModel(
      {required this.docId, required this.startTime, required this.endTime});

  Object toJson() {
    return jsonEncode(<String, dynamic>{
      'doc_id': this.docId,
      'start_day': this.startTime,
      'end_day': this.endTime
    });
  }

  factory DoctorLeaveModel.fromJson(Map<String, dynamic> parsedJson) {
    return DoctorLeaveModel(
        docId: parsedJson["doc_id"],
        startTime: parsedJson["start_day"],
        endTime: parsedJson["end_day"]);
  }
}
