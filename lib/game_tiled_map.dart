import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game_demo2/player/knight.dart';

import 'interface/bar_life_widget.dart';
import 'interface/knight_interface.dart';

class GameTiledMap extends StatelessWidget {
  const GameTiledMap({Key? key}) : super(key: key);

  static const double tileSize = 45;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BonfireTiledWidget(
          // 配置摇杆，以及操作按钮
          joystick: Joystick(
            keyboardConfig: KeyboardConfig(
              keyboardDirectionalType: KeyboardDirectionalType.wasdAndArrows,
              acceptedKeys: [
                LogicalKeyboardKey.space,
              ],
            ),
            // 摇杆图标以及背景
            directional: JoystickDirectional(
              spriteBackgroundDirectional: Sprite.load(
                'joystick_background.png',
              ),
              spriteKnobDirectional: Sprite.load('joystick_knob.png'),
              size: tileSize * 2.5,
              isFixed: false,
            ),
            // 自定义按钮
            actions: [
              // 攻击按钮
              JoystickAction(
                actionId: PlayerAttackType.attackMelee,
                sprite: Sprite.load('joystick_atack.png'),
                align: JoystickActionAlign.BOTTOM_RIGHT,
                size: 80,
                margin: const EdgeInsets.only(bottom: 50, right: 50),
              ),
              // 魔法攻击按钮
              JoystickAction(
                actionId: PlayerAttackType.attackRange,
                sprite: Sprite.load('joystick_atack_range.png'),
                spriteBackgroundDirection: Sprite.load(
                  'joystick_background.png',
                ),
                enableDirection: true,
                size: 50,
                margin: const EdgeInsets.only(bottom: 50, right: 160),
              ),
            ],
          ),
          // 配置英雄
          player: Knight(
            position: Vector2(
              (3 * tileSize),
              (2 * tileSize),
            ),
          ),
          // 配置地图
          map: TiledWorldMap('tiled/mapa1.json'),
          showFPS: true,
          constructionMode: false,
          showCollisionArea: false,
          interface: KnightInterface(),
          overlayBuilderMap: {
            'barLife': (context, game) => const BarLifeWidget(),
          },
          initialActiveOverlays: const [
            'barLife',
          ],
        );
      },
    );
  }
}
