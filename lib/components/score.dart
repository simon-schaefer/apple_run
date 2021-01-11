import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:apple_run/tools/text-display.dart';

class Score extends TextDisplay {
  int score;
  int highscore;

  Offset _position;

  Score(Size screenSize) : super(fontSize: 10, align: TextAlign.right) {
    this._position = Offset(screenSize.width - 100, 20);
    this.score = 0;
    this.highscore = 0;

    this._loadHighscore();
  }

  void increment() => this.score++;

  /* ======================================================================
  == Highscore ============================================================
  ========================================================================= */
  void _loadHighscore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.highscore = (prefs.getInt('highscore') ?? 0);
  }

  void _updateHighscore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('highscore', score);
    this.highscore = score;
  }

  /* ======================================================================
  == Rendering ============================================================
  ========================================================================= */
  void render(Canvas canvas) {
    super.renderAt(canvas, this._position);
  }

  void update(double dt) {
    // Update the highscore only if the achieved score is larger than the
    // current (e.g. initially loaded) highscore.
    if (this.score > this.highscore) {
      this._updateHighscore(this.score);
    }

    // Write score + highscore in two seperate lines.
    var scoreText = "";
    scoreText += "Score: " + this.score.toString() + "\n";
    scoreText += "Highscore: " + this.highscore.toString();
    super.updateText(dt, scoreText);
  }
}
