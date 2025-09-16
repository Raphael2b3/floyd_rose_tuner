import 'dart:math';

import 'frequency_to_note.dart';

double getFrequencyFromNote(String note, {double normTone = 440.0}) {
  // Extract note name and octave
  final regex = RegExp(r'^([A-G][b#]?)(-?\d+)$');
  final match = regex.firstMatch(note);
  if (match == null) {
    throw ArgumentError('Invalid note format: $note');
  }

  final noteName = match.group(1)!;   // e.g. "Eb"
  final octave = int.parse(match.group(2)!); // e.g. 4

  // Find index of note in our noteNames list
  final noteIndex = noteNames.indexOf(noteName);
  if (noteIndex == -1) {
    throw ArgumentError('Unknown note name: $noteName');
  }

  // Compute note number (distance in semitones from A4)
  final noteNumber = noteIndex + (octave - 4) * numberOfNotes;
  final semitoneDistance = noteNumber - indexOfA;

  // Calculate frequency
  return normTone * pow(2, semitoneDistance / 12);
}