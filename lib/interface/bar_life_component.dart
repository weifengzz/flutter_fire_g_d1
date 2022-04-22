import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import 'bar_life_controller.dart';

class BarLifeComponent extends InterfaceComponent
    with UseStateController<BarLifeController> {
  final double padding = 20;
  final double widthBar = 90;
  final double strokeWidth = 12;
  BarLifeComponent()
      : super(
          id: 1,
          position: Vector2(20, 20),
          spriteUnselected: Sprite.load('health_ui.png'),
          size: Vector2(120, 40),
        );

  @override
  void render(Canvas c) {
    super.render(c);
    try {
      _drawLife(c);
      _drawStamina(c);
    } catch (e) {}
  }

  /// 生命值
  void _drawLife(Canvas canvas) {
    double xBar = position.x + 26;
    double yBar = position.y + 10;
    canvas.drawLine(
      Offset(xBar, yBar),
      Offset(xBar + widthBar, yBar),
      Paint()
        ..color = Colors.blueGrey[800]!
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.fill,
    );
  
    double currentBarLife = (controller.life * widthBar) / controller.maxLife;

    canvas.drawLine(
        Offset(xBar, yBar),
        Offset(xBar + currentBarLife, yBar),
        Paint()
          ..color = _getColorLife(currentBarLife)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.fill);
  }

  /// 耐力
  void _drawStamina(Canvas canvas) {
    double xBar = position.x + 26;
    double yBar = position.y + 28;

    double currentBarStamina =
        (controller.stamina * widthBar) / controller.maxStamina;
    canvas.drawLine(
      Offset(xBar, yBar),
      Offset(xBar + currentBarStamina, yBar),
      Paint()
        ..color = Colors.yellow
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.fill,
    );
  }

  Color _getColorLife(double currentBarLife) {
    if (currentBarLife > widthBar - (widthBar / 3)) {
      return Colors.green;
    }
    if (currentBarLife > (widthBar / 3)) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
