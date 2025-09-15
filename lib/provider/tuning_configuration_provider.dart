import 'package:floyd_rose_tuner/types/tuning_configuration.dart';

List<TuningConfiguration> defaultTuningConfigurations = [
  TuningConfiguration(
      name: 'Standard E', goalNotes: ["E2", "A2", "D3", "G3", "B3", "E4"]),
  TuningConfiguration(
      name: 'Drop D', goalNotes: ["D2", "A2", "D3", "G3", "B3", "E4"]),
  TuningConfiguration(
      name: 'DADGAD', goalNotes: ["D2", "A2", "D3", "G3", "A3", "D4"]),
  TuningConfiguration(
      name: 'Open G', goalNotes: ["D2", "G2", "D3", "G3", "B3", "D4"]),
  TuningConfiguration(
      name: 'Half Step Down',
      goalNotes: ["Eb2", "Ab2", "Db3", "Gb3", "Bb3", "Eb4"]),
  TuningConfiguration(
      name: 'Whole Step Down', goalNotes: ["D2", "G2", "C3", "F3", "A3", "D4"]),
  TuningConfiguration(
      name: 'Drop C', goalNotes: ["C2", "G2", "C3", "F3", "A3", "D4"]),
  TuningConfiguration(
      name: 'Drop B', goalNotes: ["B1", "Gb2", "B2", "E3", "Ab3", "Db4"]),
];
