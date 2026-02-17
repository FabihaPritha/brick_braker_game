import 'package:brick_braker_game/src/brick_breaker.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Brick({
    required super.position,
    required Color color,
  }) : super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    // Remove this brick when hit by the ball
    if (other is Ball) {
      removeFromParent();
      game.score.value++;


      // If this was the last brick → end round
      if (game.world.children.query<Brick>().isEmpty) {
        game.playState = PlayState.won;
        game.world.removeAll(
          game.world.children.query<Ball>(),
        );
        game.world.removeAll(
          game.world.children.query<Bat>(),
        );
      }
    }
  }
}
