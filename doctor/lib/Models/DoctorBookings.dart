import 'dart:convert';
import 'dart:core';

class DoctorBookingsModel {
  String date;
  String startTime, slotTime, endTime, treatment;
  int docId, patId, batchNumber, slotNumber, bookingId;
  String notes;
  bool consentForm;
  int balance;
  int installment;
  bool? fileAvailable = true;

  DoctorBookingsModel(
      {required this.date,
      required this.startTime,
      required this.slotTime,
      required this.endTime,
      required this.docId,
      required this.patId,
      required this.batchNumber,
      required this.slotNumber,
      required this.bookingId,
      required this.treatment,
      required this.consentForm,
      required this.balance,
      required this.notes,
      required this.installment,
      this.fileAvailable});

  Object toJson() {
    return jsonEncode(<String, dynamic>{
      'doc_id': this.docId,
      'pat_id': this.patId,
      'date': this.date,
      'batch_number': this.batchNumber,
      'slot_number': this.slotNumber,
      'slot_time': this.slotTime,
      'start_time': this.startTime,
      'end_time': this.endTime,
      'treatment': this.treatment,
      'consent_form': this.consentForm,
      'balance': this.balance,
      'installment': this.installment,
      'file_available': this.fileAvailable
    });
  }

  factory DoctorBookingsModel.fromJson(Map<String, dynamic> json) {
    return DoctorBookingsModel(
        notes: json["notes"] ?? "",
        bookingId: json["id"],
        docId: json["doc_id"],
        patId: json['pat_id'],
        date: json["date"],
        batchNumber: json["batch_number"],
        slotNumber: json["slot_number"] ?? 0,
        slotTime: json["slot_time"].toString(),
        startTime: json["start_time"].toString(),
        endTime: json["end_time"].toString(),
        treatment: json["treatment"].toString(),
        consentForm: json["consent_form"],
        balance: json["balance"] ?? 0,
        installment: json["installment"] ?? 0,
        fileAvailable: json["file_available"] ?? false);
  }
}
