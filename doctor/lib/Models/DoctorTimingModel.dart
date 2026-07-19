import 'dart:convert';

class DoctorTimingModel {
  int docId;
  DateTime timing;
  DoctorTimingModel({required this.docId, required this.timing});

  Object toJson() {
    return jsonEncode(
        <String, dynamic>{'doc_id': this.docId, 'timing': this.timing});
  }

  factory DoctorTimingModel.fromJson(Map<String, dynamic> parsedJson) {
    return DoctorTimingModel(
        docId: parsedJson["doc_id"], timing: parsedJson["timing"]);
  }
}
