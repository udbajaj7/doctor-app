class MedicalFiles {
  String fileName;
  String fileData;
  String type;
  MedicalFiles(
      {required this.fileName, required this.fileData, required this.type});

  factory MedicalFiles.fromJson(Map<String, dynamic> parsedJson) {
    return MedicalFiles(
        fileName: parsedJson["file_name"],
        fileData: parsedJson["file"],
        type: parsedJson["type"]);
  }

  Map toJson() {
    return {
      'file': this.fileData,
      'file_name': this.fileName,
      'type': this.type,
    };
  }
}
