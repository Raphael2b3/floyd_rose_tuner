import 'dart:math';
// Note names in an octave
const List<String> noteNames = [
  'C',
  'Db',
  'D',
  'Eb',
  'E',
  'F',
  'Gb',
  'G',
  'Ab',
  'A',
  'Bb',
  'B',
];
final indexOfA = noteNames.indexOf('A'); // Index of A in the noteNames list
final numberOfNotes = noteNames.length;

int getClosestNoteNumberFromFrequency(double frequency,{double normTone = 440.0}) {
  double numberOfSemitones = indexOfA + numberOfNotes * log(frequency / normTone) / log(2);
  int noteNumber = numberOfSemitones.round();
  return noteNumber;
}

String getNearestNoteFromFrequency(double frequency,
    {double normTone = 440.0}) {
  int noteNumber =
      getClosestNoteNumberFromFrequency(frequency, normTone: normTone);

  // Determine the octave and note
  int noteIndex = noteNumber % numberOfNotes;
  // Proper floor division for negative values
  int octave = 4 + (noteNumber >= 0
      ? noteNumber ~/ numberOfNotes
      : ((noteNumber + 1) ~/ numberOfNotes) - 1);

  // Get the note name
  String noteName = noteNames[noteIndex];

  // Return the full note with octave
  return '$noteName$octave';
}
