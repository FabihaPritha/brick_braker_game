import 'package:brick_braker_game/src/brick_breaker.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'bat.dart';
import 'brick.dart';
import 'play_area.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()
            ..color = const Color(0xff1e6091)
            ..style = PaintingStyle.fill,
          children: [CircleHitbox()],
        );

  Vector2 velocity;
  final double difficultyModifier;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    // ─────────── Walls ───────────
    if (other is PlayArea) {
      final p = intersectionPoints.first;

      // Left / Right
      if (p.x <= 0 || p.x >= game.size.x) {
        velocity.x = -velocity.x;
      }

      // Top
      if (p.y <= 0) {
        velocity.y = -velocity.y;
      }

      // Bottom
      if (p.y >= game.size.y) {
        add(RemoveEffect(delay: 0.35));
      }
    }

    // ─────────── Bat ───────────
    else if (other is Bat) {
      velocity.y = -velocity.y;

      velocity.x +=
          (position.x - other.position.x) /
          other.size.x *
          game.size.x *
          0.3;
    }

    // ─────────── Brick ───────────
    else if (other is Brick) {
      final brickTop = other.position.y - other.size.y / 2;
      final brickBottom = other.position.y + other.size.y / 2;
      final brickLeft = other.position.x - other.size.x / 2;
      final brickRight = other.position.x + other.size.x / 2;

      if (position.y < brickTop || position.y > brickBottom) {
        velocity.y = -velocity.y;
      } else if (position.x < brickLeft || position.x > brickRight) {
        velocity.x = -velocity.x;
      }

      // Increase difficulty (speed)
      velocity *= difficultyModifier;
    }
  }
}
