import 'package:auto_expand_canvas_on_drag/command/base_command.dart';
import 'package:auto_expand_canvas_on_drag/command/transform_node_command.dart';
import 'package:auto_expand_canvas_on_drag/model/canvas_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/node_model.dart';
import 'model/overlay_model.dart' as om;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NodeModel(NodeState(nodeId: 1, offset: Offset.zero, size: Size(50, 50)))),
        ChangeNotifierProvider(create: (_) => om.OverlayModel()),
        ChangeNotifierProvider(create: (_) => CanvasModel(CanvasStateFixed(numSectorsY: 1, numSectorsX: 1))),
      ],
      child: Builder(
        builder: (context) {
          BaseCommand.initRootContext(context);
          return MyApp();
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Canvas(),
            Node(),
            Overlay(),
          ],
        ),
      ),
    );
  }
}

class Canvas extends StatelessWidget {
  const Canvas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CanvasState state = context.select((CanvasModel m) => m.state);

    double w = state.numSectorsX * state.sectorSize;
    double h = state.numSectorsY * state.sectorSize;
    double? wTemp, hTemp;
    if (state is CanvasStateFlexible) {
      wTemp = w + state.numTemporarySectorsX * state.sectorSize;
      hTemp = h + state.numTemporarySectorsY * state.sectorSize;
    }

    return Stack(
      children: [
        Container(
          width: w,
          height: h,
          color: Colors.green,
        ),
        if (wTemp != null)
          Container(
            width: wTemp,
            height: hTemp,
            color: Colors.grey.withAlpha(125),
          ),
      ],
    );
  }
}

class Node extends StatelessWidget {
  const Node({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NodeState state = context.select((NodeModel m) => m.state);

    return Positioned(
      top: state.offset.dy,
      left: state.offset.dx,
      width: state.size.width,
      height: state.size.height,
      child: GestureDetector(
        onTap: () => TransformNodeCommand.start(state.nodeId),
        child: Container(
          color: Colors.blue,
          width: state.size.width,
          height: state.size.height,
        ),
      ),
    );
  }
}

class Overlay extends StatelessWidget {
  const Overlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    om.OverlayState state = context.select((om.OverlayModel m) => m.state);
    NodeState nodeState = context.select((NodeModel m) => m.state);

    if (state is om.OverlayStateIdle) {
      return Container();
    } else if (state is om.OverlayStateActive || state is om.OverlayStateTransform) {
      return Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => TransformNodeCommand.cancel(),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            top: nodeState.offset.dy,
            left: nodeState.offset.dx,
            width: nodeState.size.width,
            height: nodeState.size.height,
            child: GestureDetector(
              onPanStart: (details) => TransformNodeCommand.start(nodeState.nodeId),
              onPanUpdate: (DragUpdateDetails d) => TransformNodeCommand.update(
                d.globalPosition,
                nodeState.size,
                nodeState.nodeId,
              ),
              onPanEnd: (details) => TransformNodeCommand.complete(),
              child: Container(
                color: Colors.yellow,
                width: nodeState.size.width,
                height: nodeState.size.height,
              ),
            ),
          ),
          if (state is om.OverlayStateTransform) ...[
            Positioned(
              top: state.ghostOffset.dy,
              left: state.ghostOffset.dx,
              width: state.ghostSize.width,
              height: state.ghostSize.height,
              child: Container(
                color: Colors.yellow,
                width: state.ghostSize.width,
                height: state.ghostSize.height,
              ),
            ),
          ]
        ],
      );
    } else {
      throw ("Uncovered case: ${state.runtimeType}");
    }
  }
}
