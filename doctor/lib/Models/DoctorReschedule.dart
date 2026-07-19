class DoctorRescheduleModel {
  int docId;
  String date;
  List<List<int>> timing;
  DoctorRescheduleModel(
      {required this.docId, required this.date, required this.timing});

  factory DoctorRescheduleModel.fromJson(Map<String, dynamic> json) =>
      DoctorRescheduleModel(
        docId: json["doc_id"],
        date: json["date"],
        timing: List<List<int>>.from(
            json["timing"].map((x) => List<int>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "doc_id": docId,
        "date": date,
        "timing": List<dynamic>.from(
            timing.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
