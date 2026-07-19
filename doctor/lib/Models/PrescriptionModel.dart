class PrescriptionObject {
  int? bookingId;
  Vitals? vitals;
  List<String>? symptoms;
  List<String>? diagnosis;
  List<Medicines>? medicines;
  List<String>? tests;
  String? nextVisit;

  PrescriptionObject(
      {this.bookingId,
      this.vitals,
      this.symptoms,
      this.diagnosis,
      this.medicines,
      this.tests,
      this.nextVisit});

  PrescriptionObject.fromJson(Map<String, dynamic> json) {
    bookingId = int.parse(json['booking_id']);
    vitals =
        json['vitals'] != null ? new Vitals.fromJson(json['vitals']) : null;
    symptoms = json['symptoms'].cast<String>();
    diagnosis = json['diagnosis'].cast<String>();
    if (json['medicines'] != null) {
      medicines = <Medicines>[];
      json['medicines'].forEach((v) {
        medicines!.add(new Medicines.fromJson(v));
      });
    }
    tests = json['tests'].cast<String>();
    nextVisit = json['next_visit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    if (this.vitals != null) {
      data['vitals'] = this.vitals!.toJson();
    }
    data['symptoms'] = this.symptoms;
    data['diagnosis'] = this.diagnosis;
    if (this.medicines != null) {
      data['medicines'] = this.medicines!.map((v) => v.toJson()).toList();
    }
    data['tests'] = this.tests;
    data['next_visit'] = this.nextVisit;
    return data;
  }
}

class Vitals {
  int? weight;
  int? height;
  int? temperature;
  int? bloodPressure;
  int? pulse;
  int? spo2;

  Vitals(
      {this.weight,
      this.height,
      this.temperature,
      this.bloodPressure,
      this.pulse,
      this.spo2});

  Vitals.fromJson(Map<String, dynamic> json) {
    weight = json['weight'];
    height = json['height'];
    temperature = json['temperature'];
    bloodPressure = json['bloodPressure'];
    pulse = json['pulse'];
    spo2 = json['spo2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (data['weight'] != "") data['weight'] = this.weight;
    if (data['height'] != "") data['height'] = this.height;
    if (data['temperature'] != "") data['temperature'] = this.temperature;
    if (data['bloodPressure'] != "") data['bloodPressure'] = this.bloodPressure;
    if (data['pulse'] != "") data['pulse'] = this.pulse;
    if (data['spo2'] != "") data['spo2'] = this.spo2;
    return data;
  }
}

class Medicines {
  String? name;
  String? type;
  String? dosage;
  String? when;
  String? frequency;
  String? duration;
  String? instructions;

  Medicines(
      {this.name,
      this.type,
      this.dosage,
      this.when,
      this.frequency,
      this.duration,
      this.instructions});

  Medicines.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    dosage = json['dosage'];
    when = json['when'];
    frequency = json['frequency'];
    duration = json['duration'];
    instructions = json['instructions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['dosage'] = this.dosage;
    data['when'] = this.when;
    data['frequency'] = this.frequency;
    data['duration'] = this.duration;
    data['instructions'] = this.instructions;
    return data;
  }
}
