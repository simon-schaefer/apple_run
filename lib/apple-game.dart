import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';

import 'package:apple_run/components/score.dart';
import 'package:apple_run/components/screen.dart';
import 'package:apple_run/components/stopwatch.dart';
import 'package:apple_run/components/tile.dart';

class AppleGame extends Game with TapDetector {
  List<Tile> tiles;
  Screen screen;
  Score score;
  StopWatch stopwatch;

  int rowCounter;
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
    this.score = Score(this.screen.size);
    this.stopwatch = StopWatch(this.screen.size);
    this.rowCounter = this.score.score + 1;

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
      final index = this.rowCounter;
      final tile = Tile(Offset(x, yCenter), tileSize, tileSize, index: index, hasApple: hasApple);
      this.tiles.add(tile);
    }

    this.rowCounter += 1;
  }

  /* ======================================================================
  == Rendering ============================================================
  ========================================================================= */
  @override
  void render(Canvas canvas) {
    this.tiles.forEach((Tile tile) => tile.render(canvas, this.screen.view));
    this.score.render(canvas);
    this.stopwatch.render(canvas);
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

    // Update scoring and timer display.
    this.score.update(dt);
    this.stopwatch.update(dt);
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

    // Check whether the "correct" tile has been touched. The "correct" tile is the
    // tile one row higher than the previous touch as well as contains an apple.
    final tileTouched = this.tiles[idxTouched];
    final isCorrect = tileTouched.hasApple() && tileTouched.index() == this.score.score + 1;

    // Update the score and tile activity state (pressed tile is active when it is touched,
    // it color depends on whether it is the "correct" tile or not).
    this.tiles[idxTouched].setActive(isError: !isCorrect);
    if (isCorrect && this.stopwatch.isRunning()) {
      this.score.increment();
      this.viewOffset = this.viewOffset - Offset(0, this.screen.tileSize);
    }
  }
}
