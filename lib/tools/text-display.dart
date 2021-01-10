import 'dart:ui';

import 'package:flutter/painting.dart';

class TextDisplay {
  TextPainter painter;
  TextStyle _textStyle;

  TextDisplay({double fontSize = 90, TextAlign align = TextAlign.center}) {
    final textDirection = TextDirection.ltr;
    this.painter = TextPainter(textAlign: align, textDirection: textDirection);
    this._textStyle = TextStyle(color: Color(0xffffffff), fontSize: fontSize);
  }

  /// Render text at the offset [position] in the given [canvas].
  void renderAt(Canvas canvas, Offset position) {
    this.painter.paint(canvas, position);
  }

  /// Update the painted text if it is unequal to the passed [text].
  /// The function returns whether the painted text has been updated or not.
  bool updateText(double dt, String text) {
    if ((painter.text?.toString() ?? '') != text) {
      this.painter.text = TextSpan(text: text, style: _textStyle);
      this.painter.layout();
      return true;
    }
    return false;
  }
}
