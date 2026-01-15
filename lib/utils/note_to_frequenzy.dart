import 'dart:math';

import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:ml_linalg/vector.dart';

import 'frequency_to_note.dart';

double getFrequencyFromNoteNumber(int noteNumber, {double normTone = 440.0}) {
  final semitoneDistance = noteNumber - indexOfA;
  return normTone * pow(2, semitoneDistance / 12);
}

int getNoteNumberFromNoteId(String noteId) {
  // Extract note name and octave
  final regex = RegExp(r'^([A-G][b#]?)(-?\d+)$');
  final match = regex.firstMatch(noteId);
  if (match == null) {
    throw ArgumentError('Invalid note format: $noteId');
  }

  final noteName = match.group(1)!; // e.g. "Eb"
  final octave = int.parse(match.group(2)!); // e.g. 4

  // Find index of note in our noteNames list
  final noteIndex = noteNames.indexOf(noteName);
  if (noteIndex == -1) {
    throw ArgumentError('Unknown note name: $noteName');
  }

  // Compute note number (distance in semitones from A4)
  final noteNumber = noteIndex + (octave - 4) * numberOfNotes;
  return noteNumber;
}

dynamic getFrequencyFromNoteId(String noteId) {
  final noteNumber = getNoteNumberFromNoteId(noteId);
  return getFrequencyFromNoteNumber(noteNumber);
}

Vector getFrequenciesFromGoalNotes(List<String> goalNotes) {
  var output = <double>[];
  goalNotes.map((noteId) => output.add(getFrequencyFromNoteId(noteId)));
  return Vector.fromList(output);
}
