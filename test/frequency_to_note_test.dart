
import 'dart:math';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
import 'package:floyd_rose_tuner/utils/note_to_frequenzy.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  group('getNearestNoteAndCentDistance', () {
    test('returns A4 for 440 Hz', () {
      expect(getNearestNoteAndCentDistance(440.0).$1, equals('A4'));
    });

    test('returns Bb4 for ~466.16 Hz', () {
      expect(getNearestNoteAndCentDistance(466.16).$1, equals('Bb4'));
    });

    test('returns B4 for ~493.88 Hz', () {
      expect(getNearestNoteAndCentDistance(493.88).$1, equals('B4'));
    });

    test('returns C5 for ~523.25 Hz', () {
      expect(getNearestNoteAndCentDistance(523.25).$1, equals('C5'));
    });

    test('returns A3 for 220 Hz', () {
      expect(getNearestNoteAndCentDistance(220.0).$1, equals('A3'));
    });

    test('returns A5 for 880 Hz', () {
      expect(getNearestNoteAndCentDistance(880.0).$1, equals('A5'));
    });

    test('returns A2 for 110 Hz (low octave case)', () {
      expect(getNearestNoteAndCentDistance(110.0).$1, equals('A2'));
    });

    test('returns C2 for ~65.41 Hz (low octave case)', () {
      expect(getNearestNoteAndCentDistance(65.41).$1, equals('C2'));
    });

    test('works with custom normTone 432 Hz', () {
      expect(getNearestNoteAndCentDistance(432.0, normTone: 432.0).$1, equals('A4'));
    });
  });

  group('Property-based tests', () {
    test('doubling frequency increases octave but keeps same note name', () {
      final baseFreqs = [110.0, 220.0, 246.94, 261.63, 293.66, 329.63, 392.0, 440.0];
      for (final freq in baseFreqs) {
        final note1 = getNearestNoteAndCentDistance(freq).$1;
        final note2 = getNearestNoteAndCentDistance(freq * 2).$1;

        final name1 = note1.replaceAll(RegExp(r'\d'), '');
        final name2 = note2.replaceAll(RegExp(r'\d'), '');

        expect(name1, equals(name2),
            reason: 'Note name should remain same when doubling frequency');
      }
    });

    test('halving frequency decreases octave but keeps same note name', () {
      final baseFreqs = [220.0, 246.94, 261.63, 293.66, 329.63, 392.0, 440.0];
      for (final freq in baseFreqs) {
        final note1 = getNearestNoteAndCentDistance(freq).$1;
        final note2 = getNearestNoteAndCentDistance(freq / 2).$1;

        final name1 = note1.replaceAll(RegExp(r'\d'), '');
        final name2 = note2.replaceAll(RegExp(r'\d'), '');

        expect(name1, equals(name2),
            reason: 'Note name should remain same when halving frequency');
      }
    });

    test('semitone ratio produces next note name', () {
      final semitoneRatio = pow(2, 1 / 12);
      final freq = 440.0; // A4
      final note1 = getNearestNoteAndCentDistance(freq).$1;
      final note2 = getNearestNoteAndCentDistance(freq * semitoneRatio).$1;

      final name1 = note1.replaceAll(RegExp(r'\d'), '');
      final name2 = note2.replaceAll(RegExp(r'\d'), '');

      final expectedNext =
      noteNames[(noteNames.indexOf(name1) + 1) % numberOfNotes];

      expect(name2, equals(expectedNext));
    });
  });

  group('getCentDistance', () {
    test('returns 0 for exact frequency match (A4 = 440Hz)', () {
      expect(getCentDistance(440.0, getNoteNumberFromNoteId("A4")), closeTo(0.0, 1e-10));
    });

    test('returns positive cents for sharp frequency', () {
      // A4 expected = 440Hz; 450Hz should be sharp
      final cents = getCentDistance(450.0, getNoteNumberFromNoteId("A4"));
      expect(cents, greaterThan(0));
    });

    test('returns negative cents for flat frequency', () {
      // A4 expected = 440Hz; 430Hz should be flat
      final cents = getCentDistance(430.0, getNoteNumberFromNoteId("A4"));
      expect(cents, lessThan(0));
    });

    test('returns 100 cents for one semitone sharp (Bb4 ~ 466.16Hz)', () {
      final cents = getCentDistance(466.1638, getNoteNumberFromNoteId("A4"));
      expect(cents, closeTo(100.0, 0.01));
    });

    test('returns -100 cents for one semitone flat (Ab4 ~ 415.30Hz)', () {
      final cents = getCentDistance(415.3047, getNoteNumberFromNoteId("A4"));
      expect(cents, closeTo(-100.0, 0.01));
    });

    test('works with non-standard reference tone (A4 = 442Hz)', () {
      final cents = getCentDistance(442.0, getNoteNumberFromNoteId("A4"), normTone: 442.0);
      expect(cents, closeTo(0.0, 1e-10));
    });

    test('handles very high frequencies (C8 = 4186Hz)', () {
      final cents = getCentDistance(4186.01, getNoteNumberFromNoteId("C8"));
      expect(cents.abs(), lessThan(1.0)); // should be very close to exact
    });

    test('handles very low frequencies (C1 ~ 32.70Hz)', () {
      final cents = getCentDistance(32.703, getNoteNumberFromNoteId("C1"));
      expect(cents.abs(), lessThan(1.0)); // should be very close to exact
    });
  });
}

