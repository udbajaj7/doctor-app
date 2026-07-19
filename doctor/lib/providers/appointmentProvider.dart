import 'package:doctor/Models/Appointment.dart';
import 'package:flutter/material.dart';

class AppointmentProvider with ChangeNotifier {
  List<Appointment> _currentAppointments = new List.empty(growable: true),
      _reachedAppointments = new List.empty(growable: true);
  List<Appointment> _bookingAppointments = new List.empty(growable: true);

  List<Appointment> get getCurrAppoin => _currentAppointments;
  List<Appointment> get getReachedAppoin => _reachedAppointments;
  List<Appointment> get getBookAppoin => _bookingAppointments;

  void setCurrAndReachedAppoin(
      List<Appointment> curr, List<Appointment> reached) {
    _currentAppointments = curr;
    _reachedAppointments = reached;
    notifyListeners();
  }

  void setBookAppoin(List<Appointment> list) {
    _bookingAppointments = list;
    notifyListeners();
  }

  void cancelBookAppoin(Appointment appointment) {
    _bookingAppointments.removeWhere((element) =>
        element.doctorBookingsModel.bookingId ==
        appointment.doctorBookingsModel.bookingId);
    notifyListeners();
  }

  void patReached(Appointment appointment) {
    _bookingAppointments.removeWhere((element) =>
        element.doctorBookingsModel.bookingId ==
        appointment.doctorBookingsModel.bookingId);
    _reachedAppointments.add(appointment);
    _reachedAppointments.sort((a, b) => (a.doctorBookingsModel.slotNumber
        .compareTo(b.doctorBookingsModel.slotNumber)));
    notifyListeners();
  }

  void sendPatIn(Appointment appointment) {
    _reachedAppointments.removeWhere((element) =>
        element.doctorBookingsModel.bookingId ==
        appointment.doctorBookingsModel.bookingId);
    _currentAppointments.add(appointment);
    notifyListeners();
  }

  void patEnded(Appointment appointment) {
    _currentAppointments.removeWhere((element) =>
        element.doctorBookingsModel.bookingId ==
        appointment.doctorBookingsModel.bookingId);
    notifyListeners();
  }
}
