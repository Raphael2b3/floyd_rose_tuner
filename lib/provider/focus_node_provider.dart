import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'focus_node_provider.g.dart';

@Riverpod(keepAlive: true)
FocusNode focusNode(Ref ref, String id) {
  var focusN = FocusNode(debugLabel: id);
  ref.onDispose(() => focusN.dispose());
  print("Rebuild focus node $id");
  return focusN;
}

const guitarNameFocusNodeID = "guitarName";
const frequencyInputFocusNodeID = "frequencyInput";
