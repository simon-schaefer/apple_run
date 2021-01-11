import 'package:flutter/material.dart';

class Screen {
  Rect view; // displayed view rect in global coordinate system
  Size size;
  double tileSize;

  Screen() {
    this.tileSize = 0;
    this.size = Size.zero;
    this.view = Rect.zero;
  }

  void move(Offset targetPosition, double dt, {double speedUp: 10.0}) {
    final dxdy = targetPosition - this.position();
    this.view = this.view.shift(dxdy * speedUp * dt);
  }

  void resize(Size size) {
    this.size = size;
    this.tileSize = size.width / 4;

    // Initialize view initially aligned with the screen coordinate system.
    final topLeft = this.view.topLeft;
    this.view = Rect.fromLTWH(topLeft.dx, topLeft.dy, size.width, size.height);
  }

  Offset position() => this.view.bottomCenter;
}
