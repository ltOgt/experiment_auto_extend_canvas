import 'package:auto_expand_canvas_on_drag/model/setable_model.dart';

class CanvasModel extends StatefulModel {
  CanvasState _state;
  CanvasState get state => _state;

  CanvasModel(
    this._state,
  );

  void update(CanvasState canvasState) => setState(() => _state = canvasState);
}

abstract class CanvasState {
  final double sectorSize = 500;
  // Top Left Origin and only extendable to the right an bottom for simplicity
  final int numSectorsX;
  final int numSectorsY;

  CanvasState({
    required this.numSectorsX,
    required this.numSectorsY,
  });
}

class CanvasStateFixed extends CanvasState {
  CanvasStateFixed({
    required int numSectorsX,
    required int numSectorsY,
  }) : super(numSectorsX: numSectorsX, numSectorsY: numSectorsY);
}

class CanvasStateFlexible extends CanvasState {
  final int numTemporarySectorsX;
  final int numTemporarySectorsY;

  CanvasStateFlexible({
    required int numSectorsX,
    required int numSectorsY,
    this.numTemporarySectorsX = 0,
    this.numTemporarySectorsY = 0,
  }) : super(numSectorsX: numSectorsX, numSectorsY: numSectorsY);
}
