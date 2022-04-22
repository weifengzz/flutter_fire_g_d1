import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import '../game_tiled_map.dart';
import '../interface/bar_life_controller.dart';
import '../util/common_sprite_sheet.dart';
import '../util/player_sprite_sheet.dart';
import 'knight_controller.dart';

enum PlayerAttackType { attackMelee, attackRange }

class Knight extends SimplePlayer
    with Lighting, ObjectCollision, UseStateController<KnightController> {
  static const double maxSpeed = GameTiledMap.tileSize * 3;

  double angleRadAttack = 0.0;
  bool showBgRangeAttack = false;

  BarLifeController? barLifeController;

  Knight({
    required Vector2 position,
  }) : super(
          position: position, // 英雄初始位置
          size: Vector2.all(GameTiledMap.tileSize / 1.5), // 英雄大小
          animation: PlayerSpriteSheet.simpleDirectionAnimation, // 英雄动画
          life: 100, // 英雄生命值
          speed: maxSpeed, // 英雄速度
          initDirection: Direction.right, // 英雄初始站姿（方向）
        ) {
    // 配置灯光系统
    setupLighting(
      LightingConfig(
        radius: width * 1.5, // 圆角
        blurBorder: width * 1.5, // 边框模糊
        color: Colors.transparent, // 透明
      ),
    );

    // 配置碰撞检测
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(
              GameTiledMap.tileSize / 1.5,
              GameTiledMap.tileSize / 1.5,
            ),
            align: Vector2(
              0,
              0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    barLifeController?.life = life;
    super.update(dt);
  }

  @override
  void onMount() {
    barLifeController = BonfireInjector().get<BarLifeController>();
    barLifeController?.configure(maxLife: maxLife, maxStamina: 100);
    super.onMount();
  }

  /// 根据摇杆控制英雄的速度
  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    speed = maxSpeed * event.intensity;
    super.joystickChangeDirectional(event);
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (hasController) {
      controller.handleJoystickAction(event);
    }
    super.joystickAction(event);
  }

  /// 执行范围攻击
  void execEnableBGRangeAttack(bool enabled, double angle) {
    showBgRangeAttack = enabled;
    angleRadAttack = angle;
  }

  void execShowEmote() {
    // if (hasGameRef) {
    //   gameRef.add(
    //     AnimatedFollowerObject(
    //       animation: CommonSpriteSheet.emote,
    //       target: this,
    //       size: Vector2.all(width / 2),
    //       positionFromTarget: Vector2(
    //         18,
    //         -6,
    //       ),
    //     ),
    //   );
    // }
  }

  /// 执行近战攻击
  void execMeleeAttack(double attack) {
    simpleAttackMelee(
      damage: attack,
      animationDown: CommonSpriteSheet.whiteAttackEffectBottom,
      animationLeft: CommonSpriteSheet.whiteAttackEffectLeft,
      animationRight: CommonSpriteSheet.whiteAttackEffectRight,
      animationUp: CommonSpriteSheet.whiteAttackEffectTop,
      size: Vector2.all(GameTiledMap.tileSize),
    );
  }

  void updateStamina(double stamina) {
    barLifeController?.stamina = stamina;
  }

  /// 远程攻击
  void execRangeAttack(double angle, double damage) {
    simpleAttackRangeByAngle(
      animation: CommonSpriteSheet.fireBallRight,
      animationDestroy: CommonSpriteSheet.explosionAnimation,
      angle: angle,
      size: Vector2.all(width * 0.7),
      damage: damage,
      speed: maxSpeed * 2,
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(width / 3, width / 3),
            align: Vector2(width * 0.1, 0),
          ),
        ],
      ),
      marginFromOrigin: 0,
      lightingConfig: LightingConfig(
        radius: width / 2,
        blurBorder: width,
        color: Colors.orange.withOpacity(0.3),
      ),
      attackFrom: AttackFromEnum.PLAYER_OR_ALLY,
    );
  }
}
