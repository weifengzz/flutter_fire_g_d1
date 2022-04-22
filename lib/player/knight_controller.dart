import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';

import 'knight.dart';

/// 设置英雄的行为
class KnightController extends StateController<Knight> {
  double stamina = 100; // 耐力
  double attack = 20; // 攻击力
  bool canShowEmote = true;
  bool showedDialog = false; // 显示对话框
  bool executingRangeAttack = false; // 远程攻击
  double radAngleRangeAttack = 0; // 范围攻击

  @override
  void onReady(Knight component) {
    // ignore: todo
    // TODO: implement onReady
    super.onReady(component);
  }

  @override
  void onRemove(Knight component) {
    // ignore: todo
    // TODO: implement onRemove
    super.onRemove(component);
  }

  @override
  void update(double dt) {
    // 组件为空，返回
    if (component == null) return;

    // 遇见第一个敌人对话
    if (component?.checkInterval('seeEnemy', 250, dt) == true) {
      component?.seeEnemy(
        radiusVision: component!.width * 4,
        notObserved: _handleNotObserveEnemy,
        observed: (enemies) => _handleObserveEnemy(enemies.first),
      );
    }

    if (executingRangeAttack &&
        component?.checkInterval('ATTACK_RANGE', 150, dt) == true) {
      // 判断耐力
      if (stamina > 2) {
        // 削减耐力
        _decrementStamina(2);
        component?.execRangeAttack(radAngleRangeAttack, attack / 2);
      }
    }
    _verifyStamina(dt);
  }

  void _handleNotObserveEnemy() {
    canShowEmote = true;
  }

  void _handleObserveEnemy(Enemy enemy) {
    if (canShowEmote) {
      canShowEmote = false;
      component?.execShowEmote();
    }
    if (!showedDialog) {
      showedDialog = true;
      // TODO: component?.execShowTalk(enemy);
    }
  }

  /// 处理攻击动作
  void handleJoystickAction(JoystickActionEvent event) {
    // 如果按钮按下动作
    if (event.event == ActionEvent.DOWN) {
      // 如果是空格键，或者近战攻击键
      if (event.id == LogicalKeyboardKey.space.keyId ||
          event.id == PlayerAttackType.attackMelee) {
        // 如果耐力大于15，可以进行攻击
        if (stamina > 2) {
          _decrementStamina(2);
          component?.execMeleeAttack(attack);
        }
      }
    }

    // 如果是范围攻击
    if (event.id == PlayerAttackType.attackRange) {
      // 如果范围攻击是移动
      if (event.event == ActionEvent.MOVE) {
        // 设置正在执行范围攻击
        executingRangeAttack = true;
        // 攻击范围为
        radAngleRangeAttack = event.radAngle;
      }

      // 如果松开
      if (event.event == ActionEvent.UP) {
        // 设置停止范围攻击
        executingRangeAttack = false;
      }
      component?.execEnableBGRangeAttack(executingRangeAttack, event.radAngle);
    }
  }

  /// 更新耐力
  void _verifyStamina(double dt) {
    if (stamina < 100 &&
        component?.checkInterval('INCREMENT_STAMINA', 100, dt) == true) {
      stamina += 2;
      if (stamina > 100) {
        stamina = 100;
      }
    }
    component?.updateStamina(stamina);
  }

  /// 削减耐力
  void _decrementStamina(int i) {
    stamina -= i;
    if (stamina < 0) {
      stamina = 0;
    }
    component?.updateStamina(stamina);
  }
}
