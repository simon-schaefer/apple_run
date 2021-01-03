import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'apple-game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  // Pre-Loading assets. As this is a tiny game we can simply preload them
  // all together during initialization, not adding much computational or
  // memory cost to the system.
  Flame.images.loadAll(<String>['apple.png']);

  AppleGame game = AppleGame();
  runApp(game.widget);
}
