
import 'package:floyd_rose_tuner/types/guitar_behaviour_matrix.dart';

List<GuitarBehaviourMatrix> defaultGuitarBehaviourMatrices = [
  GuitarBehaviourMatrix(
      guitarName: 'Music Man Floyd Rose', matrix: [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,1,0],[0,0,0,0,0,1]]),
  GuitarBehaviourMatrix(
      guitarName: 'Robs Guitar', matrix: [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,1,0],[0,0,0,0,0,1]]),
];

GuitarBehaviourMatrix? selectedGuitarBehaviourMatrix = defaultGuitarBehaviourMatrices[0];