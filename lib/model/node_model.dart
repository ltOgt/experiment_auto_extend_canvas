import 'dart:ui';

import 'package:auto_expand_canvas_on_drag/model/setable_model.dart';

class NodeModel extends StatefulModel {
  NodeState _state;
  NodeState get state => _state;

  NodeModel(
    this._state,
  );

  void updateNodePosition(Offset offset) => setState(
        () {
          _state = NodeState(
            nodeId: _state.nodeId,
            offset: offset,
            size: _state.size,
          );
        },
      );
}

class NodeState {
  final int nodeId;
  final Offset offset;
  final Size size;

  NodeState({
    required this.nodeId,
    required this.offset,
    required this.size,
  });
}
