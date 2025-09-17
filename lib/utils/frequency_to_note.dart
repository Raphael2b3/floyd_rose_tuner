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

int getClosestNoteNumber(double frequency, {double normTone = 440.0}) {
  if (frequency <= 0) {
    //print('Frequency must be greater than 0');
    frequency = 1;
  }
  double numberOfSemitones =
      indexOfA + numberOfNotes * log(frequency / normTone) / log(2);
  int noteNumber = numberOfSemitones.round();
  return noteNumber;
}

double getCentDistance(
  double frequency,
  int noteNumber, {
  double normTone = 440.0,
}) {
  if (frequency <= 0) {
    //print('Frequency must be greater than 0');
    frequency = 1;
  }
  double exactFrequency =
      normTone * pow(2, (noteNumber - indexOfA) / numberOfNotes);
  double distance = 1200 * log(frequency / exactFrequency) / log(2);
  return distance;
}

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

(String, double) getNearestNoteAndCentDistance(
  double frequency, {
  double normTone = 440.0,
}) {
  int noteNumber = getClosestNoteNumber(frequency, normTone: normTone);
  String noteName = getNoteName(noteNumber);
  double centDistance = getCentDistance(
    frequency,
    noteNumber,
    normTone: normTone,
  );
  return (noteName, centDistance);
}
