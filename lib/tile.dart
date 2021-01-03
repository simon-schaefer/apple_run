import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Tile {
  Rect rect;

  double _activeDuration;
  bool _isActive;
  bool _isOffScreen;
  bool _hasApple;
  Sprite _sprite;

  Tile(Offset center, double width, double height, {bool hasApple = false}) {
    this.rect = Rect.fromCenter(center: center, width: width, height: height);

    this._isActive = false;
    this._isOffScreen = false;
    this._hasApple = hasApple;
    this._activeDuration = 0;
    this._sprite = Sprite('apple.png');
  }

  /* ======================================================================
  == Rendering ============================================================
  ========================================================================= */
  void render(Canvas canvas, Rect view) {
    final displayedRect = this.rect.shift(-view.topLeft);

    if (this.isActive()) {
      Paint paint = Paint();
      paint.color = Colors.yellow;
      canvas.drawRect(displayedRect, paint);
    }

    // Draw apple on top of the activity indication (but of course only, if
    // the tile contains an apple).
    if (this.hasApple()) this._sprite.renderRect(canvas, displayedRect);
  }

  void update(double dt, Rect view) {
    this._activeDuration = this._isActive ? this._activeDuration + dt : 0;
    if (this._activeDuration > 0.5) {
      this.toggle();
    }

    // Check whether the tile still is within the screen.
    this._isOffScreen = !view.overlaps(this.rect);
  }

  /* ======================================================================
  == Status ===============================================================
  ========================================================================= */
  void toggle() {
    this._isActive = !this._isActive;
    this._activeDuration = 0;
  }

  bool isActive() => this._isActive;
  bool isOffScreen() => this._isOffScreen;
  bool hasApple() => this._hasApple;
}
