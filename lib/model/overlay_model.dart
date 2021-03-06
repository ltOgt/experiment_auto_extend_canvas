import 'dart:ui';

import 'package:auto_expand_canvas_on_drag/model/setable_model.dart';

class OverlayModel extends StatefulModel {
  OverlayState _state = const OverlayStateIdle();
  OverlayState get state => _state;

  OverlayModel();

  void activate({
    required int nodeId,
    required Offset nodeOffset,
    required Size nodeSize,
  }) {
    // assert(_state is OverlayStateIdle);
    setState(() => _state = OverlayStateActive(
          nodeId: nodeId,
          nodeOffset: nodeOffset,
          nodeSize: nodeSize,
        ));
  }

  void transform({
    required int nodeId,
    required Offset ghostOffset,
    required Size ghostSize,
  }) {
    setState(() => _state = OverlayStateTransform(
          nodeId: nodeId,
          ghostOffset: ghostOffset,
          ghostSize: ghostSize,
        ));
  }

  void idle() => setState(() => _state = OverlayStateIdle());
}

abstract class OverlayState {
  const OverlayState();
}

class OverlayStateIdle extends OverlayState {
  const OverlayStateIdle();
}

class OverlayStateActive extends OverlayState {
  final int nodeId;
  final Offset nodeOffset;
  final Size nodeSize;

  const OverlayStateActive({
    required this.nodeOffset,
    required this.nodeSize,
    required this.nodeId,
  });
}

class OverlayStateTransform extends OverlayState {
  final int nodeId;
  final Offset ghostOffset;
  final Size ghostSize;

  const OverlayStateTransform({
    required this.nodeId,
    required this.ghostOffset,
    required this.ghostSize,
  });
}
