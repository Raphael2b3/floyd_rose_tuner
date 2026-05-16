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

int getClosestNoteNumber(num frequency, {num normTone = 440.0}) {
  if (frequency <= 0) {
    //print('Frequency must be greater than 0');
    frequency = 1;
  }
  num numberOfSemitones =
      indexOfA + numberOfNotes * log(frequency / normTone) / log(2);
  int noteNumber = numberOfSemitones.round();
  return noteNumber;
}

num getCentDistanceFromNote(
  num frequency,
  int noteNumber, {
  num normTone = 440.0,
}) {
  if (frequency <= 0) {
    //print('Frequency must be greater than 0');
    frequency = 1;
  }
  num exactFrequency =
      normTone * pow(2, (noteNumber - indexOfA) / numberOfNotes);
  return getCentDistance(frequency, exactFrequency);
}

num getCentDistance(num frequency, num otherFrequency) =>
    1200 * log(frequency / otherFrequency) / log(2);

String getNoteName(int noteNumber) {
  int noteIndex = noteNumber % numberOfNotes; // Determine the octave and note

  int octave =
      4 +
      (noteNumber >=
              0 // Proper floor division for negative values
          ? noteNumber ~/ numberOfNotes
          : ((noteNumber + 1) ~/ numberOfNotes) - 1);

  // Get the note name
  String noteName = noteNames[noteIndex];
  // Return the full note with octave
  return '$noteName$octave';
}

(String, num) getNearestNoteAndCentDistance(
  num frequency, {
  num normTone = 440.0,
}) {
  int noteNumber = getClosestNoteNumber(frequency, normTone: normTone);
  String noteName = getNoteName(noteNumber);
  num centDistance = getCentDistanceFromNote(frequency, noteNumber, normTone: normTone);
  return (noteName, centDistance);
}
