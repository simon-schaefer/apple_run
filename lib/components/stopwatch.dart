import 'dart:math';
import 'dart:ui';

import 'package:flutter/painting.dart';

import 'package:apple_run/tools/text-display.dart';

class StopWatch extends TextDisplay {
  double _duration;

  Offset _position;

  StopWatch(Size screenSize) : super(fontSize: 10, align: TextAlign.center) {
    this._position = Offset(10, 50);
    this._duration = 30.0;
  }

  /* ======================================================================
  == Rendering ============================================================
  ========================================================================= */
  void render(Canvas canvas) {
    super.renderAt(canvas, this._position);
  }

  void update(double dt) {
    this._duration = max(this._duration - dt, 0.0);
    super.updateText(dt, this._duration.toStringAsFixed(1));
  }

  /* ======================================================================
  == Status ===============================================================
  ========================================================================= */
  bool isRunning() => this._duration >= 1e-3;
}
