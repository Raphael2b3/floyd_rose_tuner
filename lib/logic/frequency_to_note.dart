import 'dart:math';

class Tone {
  String name;
  double frequency;
  int noteNumber;
  double centDifference;

  Tone(
      {this.name = "?",
      this.frequency = 0.0,
      this.noteNumber = 0,
      this.centDifference = 0});
}

const numberOfNotes = 12;
final double coefficient = numberOfNotes / log(2);
// Note names in an octave
const List<String> noteNames = [
  'A',
  'A#',
  'B',
  'C',
  'C#',
  'D',
  'D#',
  'E',
  'F',
  'F#',
  'G',
  'G#'
];

int getClosestNoteNumberFromFrequency(double frequency,
    {double a4Frequency = 440.0}) {
  // Calculate the number of semitones from A4
  double n = coefficient * (log(frequency / a4Frequency));
  // Round to the nearest semitone
  int roundedN = n.round();
  return roundedN;
}

String getNearestNoteFromFrequency(double frequency,
    {double a4Frequency = 440.0}) {
  int roundedN =
      getClosestNoteNumberFromFrequency(frequency, a4Frequency: a4Frequency);

  // Determine the octave and note
  int noteIndex = roundedN % numberOfNotes;
  int octave = 4 + (roundedN ~/ numberOfNotes); // A4 is in octave 4

  // Get the note name
  String noteName = noteNames[noteIndex];

  // Return the full note with octave
  return '$noteName$octave';
}

double diffInCents(double expectedFrequency, double frequency) {
  return 1200.0 * log(expectedFrequency / frequency);
}
