import 'dart:convert';
import 'dart:html';

import 'package:doctor/Models/MedicalFiles.dart';
import 'package:doctor/screens/bookings/components/requests.dart';
import 'package:doctor/screens/homeScreen/components/requests.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

downloadFile(MedicalFiles file) async {
  // var file = await getTreatmentFiles(bookingId);
  // if (file == null) return;
  // launchUrl(Uri.parse("data:application/pdf;base64,${r}"));
  final anchor = AnchorElement(
      href: 'data:application/octet-stream;base64,${file.fileData}')
    ..target = 'blank';
  // add the name
  var downloadName = file.fileName;
  anchor.download = downloadName;
  // trigger download
  document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}

Future<String> uploadFile(
    int bookingId, BuildContext context, int fileNo) async {
  var picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ["docx", "doc", "pdf", "jpg", "jpeg", "png"]);
  if (picked != null) {
    print("picked");
    if (fileNo + picked.files.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cannot upload more than 8 files")));
      Navigator.of(context).pop();
    }
    List<MedicalFiles> files = [];
    picked.files.forEach((f) {
      files.add(MedicalFiles(
          fileName: f.name,
          fileData: base64Encode(f.bytes ?? [0]),
          type: f.name.split('.')[1]));
    });
    // var fileName = picked.files.single.name;
    // var encodedFile = base64Encode(picked.files.single.bytes ?? [0]);
    // var extention = fileName.split('.')[1];

    String response = await uploadFileAPi(bookingId, files);

    return response;
  }
  return "Error";
}
