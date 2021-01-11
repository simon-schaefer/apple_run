import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

enum TileStatus { active, error, hidden, offscreen, none }

class Tile {
  Rect rect;

  double _activeDuration;
  int _index;
  TileStatus _status;
  bool _hasApple;
  Sprite _sprite;

  Tile(Offset center, double width, double height,
      {int index = 0, bool hasApple = false, TileStatus status = TileStatus.none}) {
    this.rect = Rect.fromCenter(center: center, width: width, height: height);

    this._status = status;
    this._index = index;
    this._hasApple = hasApple;
    this._activeDuration = 0;
    this._sprite = Sprite('apple.png');
  }

  /* ======================================================================
  == Rendering ============================================================
  ========================================================================= */
  void render(Canvas canvas, Rect view) {
    final displayedRect = this.rect.shift(-view.topLeft);

    // Todo -> only when active for computational efficiency
    Paint paint = Paint();
    paint.color = this.setColor();
    canvas.drawRect(displayedRect, paint);

    // Draw apple on top of the activity indication (but of course only, if
    // the tile contains an apple).
    if (this.hasApple() && !this.isHidden() && !this.isOffScreen()) {
      this._sprite.renderRect(canvas, displayedRect);
    }
  }

  void update(double dt, Rect view) {
    this._activeDuration = this.isActive() ? this._activeDuration + dt : 0;
    if (this._activeDuration > 0.2) {
      final wasActive = this._status == TileStatus.active;
      this._status = wasActive ? TileStatus.hidden : TileStatus.none;
    }

    // Check whether the tile still is within the screen.
    final isOffScreen = !view.overlaps(this.rect);
    if (isOffScreen) this._status = TileStatus.offscreen;
    if (this._status == TileStatus.offscreen && !isOffScreen) this._status = TileStatus.none;
  }

  /* ======================================================================
  == Status ===============================================================
  ========================================================================= */
  void setActive({bool isError = false}) {
    this._status = isError ? TileStatus.error : TileStatus.active;
    this._activeDuration = 0;
  }

  Color setColor() {
    switch (this.status()) {
      case TileStatus.active:
        return Color.fromRGBO(0, 255, 0, 1.0);
      case TileStatus.error:
        return Color.fromRGBO(255, 0, 0, 1.0);
      default:
        return Color.fromRGBO(255, 255, 255, 1.0);
    }
  }

  int index() => this._index;
  TileStatus status() => this._status;

  bool isActive() => (this.status() == TileStatus.active) || (this.status() == TileStatus.error);
  bool isOffScreen() => this._status == TileStatus.offscreen;
  bool isHidden() => this._status == TileStatus.hidden;
  bool hasApple() => this._hasApple;
}
