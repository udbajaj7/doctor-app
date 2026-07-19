import 'dart:convert';

class DoctorWaitingQueueModel {
  int docId, batchNumber, slotNo;
  DateTime date;
  DoctorWaitingQueueModel(
      {required this.docId,
      required this.batchNumber,
      required this.slotNo,
      required this.date});

  Object toJson() {
    return jsonEncode(<String, dynamic>{
      'doc_id': this.docId,
      'date': this.date,
      'batch_number': this.batchNumber,
      'waiting_slot_number': this.slotNo
    });
  }

  factory DoctorWaitingQueueModel.fromJson(Map<String, dynamic> parsedJson) {
    return DoctorWaitingQueueModel(
        docId: parsedJson["doc_id"],
        date: parsedJson["date"],
        batchNumber: parsedJson["batch_number"],
        slotNo: parsedJson["waiting_slot_number"]);
  }
}
