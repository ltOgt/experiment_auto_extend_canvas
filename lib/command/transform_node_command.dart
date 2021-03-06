import 'dart:ui';

import 'package:auto_expand_canvas_on_drag/command/base_command.dart';
import 'package:auto_expand_canvas_on_drag/model/canvas_model.dart';
import 'package:auto_expand_canvas_on_drag/model/node_model.dart';
import 'package:auto_expand_canvas_on_drag/model/overlay_model.dart';

class TransformNodeCommand extends BaseCommand {
  TransformNodeCommand();

  static void start(int nodeId) {
    final overlayModel = BaseCommand.dependOn<OverlayModel>();

    // mock lookup size and pos of node
    final nodeState = BaseCommand.dependOn<NodeModel>().state;

    overlayModel.activate(nodeId: nodeId, nodeSize: nodeState.size, nodeOffset: nodeState.offset);
  }

  static void update(Offset offset, Size size, [int? nodeId]) {
    final overlayModel = BaseCommand.dependOn<OverlayModel>();
    assert(nodeId != null || overlayModel.state is OverlayStateActive);

    final id = nodeId ?? (overlayModel.state as OverlayStateActive).nodeId;

    overlayModel.transform(nodeId: id, ghostOffset: offset, ghostSize: size);

    final canvasModel = BaseCommand.dependOn<CanvasModel>();
    final diffY = (offset.dy + size.height) - (canvasModel.state.sectorSize * canvasModel.state.numSectorsY);
    final diffX = (offset.dx + size.width) - (canvasModel.state.sectorSize * canvasModel.state.numSectorsX);
    canvasModel.update(
      CanvasStateFlexible(
        numSectorsX: canvasModel.state.numSectorsX,
        numSectorsY: canvasModel.state.numSectorsY,
        numTemporarySectorsX: (diffX / canvasModel.state.sectorSize).ceil(),
        numTemporarySectorsY: (diffY / canvasModel.state.sectorSize).ceil(),
      ),
    );
  }

  static void complete() {
    final overlayModel = BaseCommand.dependOn<OverlayModel>();
    final nodeModel = BaseCommand.dependOn<NodeModel>();

    assert(overlayModel.state is OverlayStateTransform);

    nodeModel.updateNodePosition((overlayModel.state as OverlayStateTransform).ghostOffset);
    overlayModel.idle();

    final canvasModel = BaseCommand.dependOn<CanvasModel>();
    final canvasState = canvasModel.state;
    if (canvasState is CanvasStateFlexible) {
      canvasModel.update(
        CanvasStateFixed(
          numSectorsX: canvasState.numSectorsX + canvasState.numTemporarySectorsX,
          numSectorsY: canvasState.numSectorsY + canvasState.numTemporarySectorsY,
        ),
      );
    }
  }

  static void cancel() {
    final overlayModel = BaseCommand.dependOn<OverlayModel>();

    overlayModel.idle();
  }
}
