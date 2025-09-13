
import 'dart:math';
import 'package:floyd_rose_tuner/logic/frequency_to_note.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('getClosestNoteNumberFromFrequency', () {
    test('returns index of A for 440 Hz (A4)', () {
      expect(getClosestNoteNumberFromFrequency(440.0), equals(indexOfA));
    });

    test('returns index of Bb for ~466.16 Hz', () {
      expect(getClosestNoteNumberFromFrequency(466.16),
          equals(noteNames.indexOf('Bb')));
    });

    test('returns index of B for ~493.88 Hz', () {
      expect(getClosestNoteNumberFromFrequency(493.88),
          equals(noteNames.indexOf('B')));
    });

    test('returns index of C for ~523.25 Hz (C5)', () {
      expect(getClosestNoteNumberFromFrequency(523.25)%numberOfNotes,
          equals(noteNames.indexOf('C')));
    });

    test('returns index of A for 220 Hz (A3)', () {
      expect(getClosestNoteNumberFromFrequency(220.0)%numberOfNotes, equals(indexOfA));
    });

    test('returns index of A for 880 Hz (A5)', () {
      expect(getClosestNoteNumberFromFrequency(880.0)%numberOfNotes, equals(indexOfA));
    });

    test('uses custom normTone (432 Hz instead of 440)', () {
      expect(
        getClosestNoteNumberFromFrequency(432.0, normTone: 432.0),
        equals(indexOfA),
      );
    });
  });

  group('getNearestNoteFromFrequency', () {
    test('returns A4 for 440 Hz', () {
      expect(getNearestNoteFromFrequency(440.0), equals('A4'));
    });

    test('returns Bb4 for ~466.16 Hz', () {
      expect(getNearestNoteFromFrequency(466.16), equals('Bb4'));
    });

    test('returns B4 for ~493.88 Hz', () {
      expect(getNearestNoteFromFrequency(493.88), equals('B4'));
    });

    test('returns C5 for ~523.25 Hz', () {
      expect(getNearestNoteFromFrequency(523.25), equals('C5'));
    });

    test('returns A3 for 220 Hz', () {
      expect(getNearestNoteFromFrequency(220.0), equals('A3'));
    });

    test('returns A5 for 880 Hz', () {
      expect(getNearestNoteFromFrequency(880.0), equals('A5'));
    });

    test('returns A2 for 110 Hz (low octave case)', () {
      expect(getNearestNoteFromFrequency(110.0), equals('A2'));
    });

    test('returns C2 for ~65.41 Hz (low octave case)', () {
      expect(getNearestNoteFromFrequency(65.41), equals('C2'));
    });

    test('works with custom normTone 432 Hz', () {
      expect(getNearestNoteFromFrequency(432.0, normTone: 432.0), equals('A4'));
    });
  });

  group('Property-based tests', () {
    test('doubling frequency increases octave but keeps same note name', () {
      final baseFreqs = [110.0, 220.0, 246.94, 261.63, 293.66, 329.63, 392.0, 440.0];
      for (final freq in baseFreqs) {
        final note1 = getNearestNoteFromFrequency(freq);
        final note2 = getNearestNoteFromFrequency(freq * 2);

        final name1 = note1.replaceAll(RegExp(r'\d'), '');
        final name2 = note2.replaceAll(RegExp(r'\d'), '');

        expect(name1, equals(name2),
            reason: 'Note name should remain same when doubling frequency');
      }
    });

    test('halving frequency decreases octave but keeps same note name', () {
      final baseFreqs = [220.0, 246.94, 261.63, 293.66, 329.63, 392.0, 440.0];
      for (final freq in baseFreqs) {
        final note1 = getNearestNoteFromFrequency(freq);
        final note2 = getNearestNoteFromFrequency(freq / 2);

        final name1 = note1.replaceAll(RegExp(r'\d'), '');
        final name2 = note2.replaceAll(RegExp(r'\d'), '');

        expect(name1, equals(name2),
            reason: 'Note name should remain same when halving frequency');
      }
    });

    test('semitone ratio produces next note name', () {
      final semitoneRatio = pow(2, 1 / 12);
      final freq = 440.0; // A4
      final note1 = getNearestNoteFromFrequency(freq);
      final note2 = getNearestNoteFromFrequency(freq * semitoneRatio);

      final name1 = note1.replaceAll(RegExp(r'\d'), '');
      final name2 = note2.replaceAll(RegExp(r'\d'), '');

      final expectedNext =
      noteNames[(noteNames.indexOf(name1) + 1) % numberOfNotes];

      expect(name2, equals(expectedNext));
    });
  });
}
