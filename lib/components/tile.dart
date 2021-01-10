import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

enum TileStatus { active, error, none }

class Tile {
  Rect rect;

  double _activeDuration;
  int _index;
  TileStatus _status;
  bool _isOffScreen;
  bool _hasApple;
  Sprite _sprite;

  Tile(Offset center, double width, double height, {int index = 0, bool hasApple = false}) {
    this.rect = Rect.fromCenter(center: center, width: width, height: height);

    this._status = TileStatus.none;
    this._index = index;
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
      paint.color = (this.status() == TileStatus.error) ? Colors.red : Colors.lightGreen;
      canvas.drawRect(displayedRect, paint);
    }

    // Draw apple on top of the activity indication (but of course only, if
    // the tile contains an apple).
    if (this.hasApple()) this._sprite.renderRect(canvas, displayedRect);
  }

  void update(double dt, Rect view) {
    this._activeDuration = this.isActive() ? this._activeDuration + dt : 0;
    if (this._activeDuration > 0.2) {
      this._status = TileStatus.none;
    }

    // Check whether the tile still is within the screen.
    this._isOffScreen = !view.overlaps(this.rect);
  }

  /* ======================================================================
  == Status ===============================================================
  ========================================================================= */
  void setActive({bool isError = false}) {
    this._status = isError ? TileStatus.error : TileStatus.active;
    this._activeDuration = 0;
  }

  int index() => this._index;
  TileStatus status() => this._status;
  bool isActive() => this.status() != TileStatus.none;
  bool isOffScreen() => this._isOffScreen;
  bool hasApple() => this._hasApple;
}
