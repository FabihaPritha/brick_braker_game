import 'package:brick_braker_game/src/brick_breaker.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  final game = BrickBreaker();                                  // Modify this line
  runApp(GameWidget(game: game));
}