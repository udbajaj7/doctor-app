import 'package:doctor/Models/DoctorBookings.dart';
import 'package:doctor/Models/PatientModel.dart';

class Appointment {
  late DoctorBookingsModel doctorBookingsModel;
  late PatientModel patientModel;
  late int? timeLeft;

  Appointment(
      {required this.doctorBookingsModel,
      required this.patientModel,
      this.timeLeft});
}
