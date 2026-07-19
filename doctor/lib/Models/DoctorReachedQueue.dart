import 'dart:convert';

class DoctorReachedQueueModel {
  int docId, batchNumber, slotNo;
  DateTime date;
  DoctorReachedQueueModel(
      {required this.docId,
      required this.batchNumber,
      required this.slotNo,
      required this.date});

  Object toJson() {
    return jsonEncode(<String, dynamic>{
      'doc_id': this.docId,
      'date': this.date,
      'batch_number': this.batchNumber,
      'reached_slot_number': this.slotNo
    });
  }

  factory DoctorReachedQueueModel.fromJson(Map<String, dynamic> parsedJson) {
    return DoctorReachedQueueModel(
        docId: parsedJson["doc_id"],
        date: parsedJson["date"],
        batchNumber: parsedJson["batch_number"],
        slotNo: parsedJson["reached_slot_number"]);
  }
}
