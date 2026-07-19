import 'package:doctor/components/urls.dart';
import 'package:doctor/screens/loginScreen/components/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dateToString', () {
    test('formats as dd-MM-yyyy with zero padding', () {
      expect(dateToString(DateTime(2024, 3, 7)), '07-03-2024');
      expect(dateToString(DateTime(2024, 12, 25)), '25-12-2024');
    });
  });

  group('timeToString', () {
    test('formats as HHmm with zero padding', () {
      expect(timeToString(const TimeOfDay(hour: 9, minute: 5)), '0905');
      expect(timeToString(const TimeOfDay(hour: 23, minute: 59)), '2359');
    });
  });

  group('computeSlot', () {
    test('parses a 4-digit time string', () {
      final slot = computeSlot('0930');
      expect(slot.hour, 9);
      expect(slot.minute, 30);
    });

    test('left-pads shorter strings', () {
      final slot = computeSlot('900');
      expect(slot.hour, 9);
      expect(slot.minute, 0);
    });

    test('strips commas before parsing', () {
      final slot = computeSlot('1445,');
      expect(slot.hour, 14);
      expect(slot.minute, 45);
    });
  });

  group('convertToString', () {
    test('round-trips with computeSlot', () {
      const time = TimeOfDay(hour: 8, minute: 5);
      final asString = convertToString(time);
      expect(asString, '0805');
      final back = computeSlot(asString);
      expect(back.hour, 8);
      expect(back.minute, 5);
    });
  });
}
