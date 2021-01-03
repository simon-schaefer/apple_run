import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';

import 'package:apple_run/screen.dart';
import 'package:apple_run/tile.dart';

class AppleGame extends Game with TapDetector {
  List<Tile> tiles;
  Screen screen;

  Random rnd;
  Offset viewOffset;

  AppleGame() {
    this.screen = Screen();
    initialize();
  }

  void initialize() async {
    this.tiles = List<Tile>();
    this.rnd = Random();
    this.resize(await Flame.util.initialDimensions());
    this.viewOffset = this.screen.position();

    final numRows = this.screen.size.height ~/ this.screen.tileSize;
    assert(numRows >= 2);
    this.addRow(this.screen.size.height - this.screen.tileSize / 2, numTiles: 4);
  }

  void addRow(double yCenter, {int numTiles = 4}) {
    final tileSize = this.screen.tileSize;
    final indexApple = this.rnd.nextInt(numTiles);

    for (var i = 0; i < numTiles; i++) {
      final x = i * tileSize + tileSize / 2;
      final hasApple = (i == indexApple);
      final tile = Tile(Offset(x, yCenter), tileSize, tileSize, hasApple: hasApple);
      this.tiles.add(tile);
    }
  }

  /* ======================================================================
  == Rendering ============================================================
  ========================================================================= */
  @override
  void render(Canvas canvas) {
    this.tiles.forEach((Tile tile) => tile.render(canvas, this.screen.view));
  }

  @override
  void update(double dt) {
    // Add new tiles until screen is full, i.e. until the last tile's
    // y position is at the top of the screen (y = 0).
    if (this.tiles.length < 50) {
      final y = this.tiles.last.rect.center.dy - this.screen.tileSize;
      this.addRow(y, numTiles: 4);
    }

    // Move view to target offset position.
    this.screen.move(this.viewOffset, dt);

    // Update tiles. Then remove tiles when they are out of view.
    this.tiles.forEach((Tile tile) => tile.update(dt, this.screen.view));
    if (this.tiles.length > 4 && this.tiles.first.isOffScreen()) {
      this.tiles.removeRange(0, 4); // remove entire first row
    }
  }

  @override
  void resize(Size size) => this.screen.resize(size);

  /* ======================================================================
  == Interface ============================================================
  ========================================================================= */
  @override
  void onTapDown(TapDownDetails details) {
    final position = this.screen.view.topLeft + details.globalPosition;
    final idxTouched = this.tiles.indexWhere((Tile tile) => tile.rect.contains(position));
    this.tiles[idxTouched].toggle();

    this.viewOffset = this.viewOffset - Offset(0, this.screen.tileSize);
  }
}
