import 'package:doctor/Models/DoctorBookings.dart';
import 'package:doctor/Models/PatientModel.dart';
import 'package:doctor/screens/homeScreen/components/requests.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PatientModel.fromJson', () {
    test('maps all fields', () {
      final patient = PatientModel.fromJson({
        'id': 42,
        'first_name': 'Asha',
        'last_name': 'Rao',
        'phone_number': '9998887776',
        'email': 'asha@example.com',
        'age': 31,
        'gender': 'F',
        'city': 'Pune',
      });

      expect(patient.id, 42);
      expect(patient.firstName, 'Asha');
      expect(patient.lastName, 'Rao');
      expect(patient.phoneNumber, '9998887776');
      expect(patient.email, 'asha@example.com');
      expect(patient.age, 31);
      expect(patient.city, 'Pune');
    });

    test('defaults a null last name to empty string', () {
      final patient = PatientModel.fromJson({
        'id': 1,
        'first_name': 'Solo',
        'last_name': null,
        'phone_number': '1',
        'email': 'a@b.com',
        'age': 20,
        'gender': 'M',
        'city': 'X',
      });
      expect(patient.lastName, '');
    });
  });

  group('DoctorBookingsModel.fromJson', () {
    Map<String, dynamic> baseBooking() {
      return {
        'id': 100,
        'doc_id': 5,
        'pat_id': 42,
        'date': '07-03-2024',
        'batch_number': 1,
        'slot_number': 2,
        'slot_time': 900,
        'start_time': 900,
        'end_time': 915,
        'treatment': 'Cleaning',
        'consent_form': true,
        'balance': 500,
        'installment': 0,
        'file_available': true,
        'notes': 'stable',
      };
    }

    test('maps required fields and stringifies times', () {
      final booking = DoctorBookingsModel.fromJson(baseBooking());
      expect(booking.bookingId, 100);
      expect(booking.docId, 5);
      expect(booking.patId, 42);
      expect(booking.slotTime, '900');
      expect(booking.startTime, '900');
      expect(booking.consentForm, true);
      expect(booking.balance, 500);
    });

    test('applies safe defaults for nullable fields', () {
      final json = baseBooking()
        ..remove('notes')
        ..remove('balance')
        ..remove('installment')
        ..remove('file_available')
        ..remove('slot_number');
      final booking = DoctorBookingsModel.fromJson(json);
      expect(booking.notes, '');
      expect(booking.balance, 0);
      expect(booking.installment, 0);
      expect(booking.slotNumber, 0);
      expect(booking.fileAvailable, false);
    });
  });

  group('BookedResponse.fromJson', () {
    test('parses parallel patient and booking lists', () {
      final response = BookedResponse.fromJson({
        'Patients': [
          {
            'id': 42,
            'first_name': 'Asha',
            'last_name': 'Rao',
            'phone_number': '9998887776',
            'email': 'asha@example.com',
            'age': 31,
            'gender': 'F',
            'city': 'Pune',
          }
        ],
        'Bookings': [
          {
            'id': 100,
            'doc_id': 5,
            'pat_id': 42,
            'date': '07-03-2024',
            'batch_number': 1,
            'slot_number': 2,
            'slot_time': 900,
            'start_time': 900,
            'end_time': 915,
            'treatment': 'Cleaning',
            'consent_form': true,
            'balance': 500,
            'installment': 0,
            'file_available': true,
            'notes': 'stable',
          }
        ],
      });

      expect(response.patients, hasLength(1));
      expect(response.bookings, hasLength(1));
      expect(response.patients.first.firstName, 'Asha');
      expect(response.bookings.first.bookingId, 100);
    });
  });
}
