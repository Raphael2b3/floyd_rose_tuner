
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
import 'package:floyd_rose_tuner/utils/note_to_frequenzy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getFrequencyFromNote', () {
    const double tolerance = 0.5; // Hz tolerance for floating point

    test('returns 440.0 Hz for A4', () {
      expect(getFrequencyFromNote("A4"), closeTo(440.0, tolerance));
    });

    test('returns ~261.63 Hz for C4', () {
      expect(getFrequencyFromNote("C4"), closeTo(261.63, tolerance));
    });

    test('returns ~311.13 Hz for Eb4', () {
      expect(getFrequencyFromNote("Eb4"), closeTo(311.13, tolerance));
    });

    test('returns ~3951.07 Hz for B7', () {
      expect(getFrequencyFromNote("B7"), closeTo(3951.07, tolerance));
    });

    test('returns ~51.91 Hz for Ab1', () {
      expect(getFrequencyFromNote("Ab1"), closeTo(51.91, tolerance));
    });

    test('handles lowest piano note A0 (~27.5 Hz)', () {
      expect(getFrequencyFromNote("A0"), closeTo(27.5, tolerance));
    });

    test('handles highest piano note C8 (~4186 Hz)', () {
      expect(getFrequencyFromNote("C8"), closeTo(4186.0, tolerance));
    });

    test('throws ArgumentError for invalid format', () {
      expect(() => getFrequencyFromNote("Hello"), throwsA(isA<ArgumentError>()));
    });

    test('throws ArgumentError for unknown note name', () {
      expect(() => getFrequencyFromNote("H4"), throwsA(isA<ArgumentError>()));
    });
  });

  group('round-trip tests', () {
    const double tolerance = 0.5;

    final notesToCheck = [
      "A4",
      "C4",
      "Eb4",
      "B7",
      "Ab1",
      "A0",
      "C-18",
      "Gb3", // enharmonic spelling
    ];

    for (var note in notesToCheck) {
      test('note $note → frequency → nearest note → back to same note', () {
        final freq = getFrequencyFromNote(note);
        final nearestNote = getNearestNoteFromFrequency(freq);

        expect(nearestNote, equals(note),
            reason: 'Expected round-trip of $note to return same note');
      });

      test('note $note → frequency → back to same frequency (approx)', () {
        final freq = getFrequencyFromNote(note);
        final nearestNote = getNearestNoteFromFrequency(freq);
        final freq2 = getFrequencyFromNote(nearestNote);

        expect(freq2, closeTo(freq, tolerance),
            reason: 'Expected round-trip of $note to match frequency');
      });
    }
  });
}