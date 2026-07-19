import 'dart:convert';

class DoctorDelayTableModel {
  int docId, batchNumber, delay, index;
  DateTime date;
  DoctorDelayTableModel(
      {required this.docId,
      required this.batchNumber,
      required this.delay,
      required this.index,
      required this.date});

  Object toJson() {
    return jsonEncode(<String, dynamic>{
      'doc_id': this.docId,
      'date': this.date,
      'batch_number': this.batchNumber,
      'delay': this.delay,
      'booking_min_index': this.index
    });
  }

  factory DoctorDelayTableModel.fromJson(Map<String, dynamic> parsedJson) {
    return DoctorDelayTableModel(
        docId: parsedJson["doc_id"],
        date: parsedJson["date"],
        batchNumber: parsedJson["batch_number"],
        delay: parsedJson["delay"],
        index: parsedJson["booking_min_index"]);
  }
}
