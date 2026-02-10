import 'package:brick_braker_game/src/brick_breaker.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'bat.dart';
import 'play_area.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
  }) : super(
         radius: radius,
         anchor: Anchor.center,
         paint: Paint()
           ..color = const Color(0xff1e6091)
           ..style = PaintingStyle.fill,
         children: [CircleHitbox()],
       );

  Vector2 velocity;

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
      final collisionPoint = intersectionPoints.first;

      // Left / Right walls
      if (collisionPoint.x <= 0 || collisionPoint.x >= game.width) {
        velocity.x = -velocity.x;
      }

      // Top wall
      if (collisionPoint.y <= 0) {
        velocity.y = -velocity.y;
      }

      // Bottom wall → remove ball with delay
      if (collisionPoint.y >= game.height) {
        add(RemoveEffect(delay: 0.35));
      }
    }
    // ─────────── Bat ───────────
    else if (other is Bat) {
      velocity.y = -velocity.y;

      // Add angle based on hit position
      velocity.x +=
          (position.x - other.position.x) / other.size.x * game.width * 0.3;
    }
    // ─────────── Debug ───────────
    else {
      debugPrint('collision with $other');
    }
  }
}
