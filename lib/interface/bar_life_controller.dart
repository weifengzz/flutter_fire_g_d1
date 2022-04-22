import 'package:bonfire/bonfire.dart';

import 'bar_life_component.dart';

class BarLifeController extends StateController<BarLifeComponent> {
  double _maxLife = 100; // 最大生命值
  double _maxStamina = 100; // 最大耐力

  get maxLife => _maxLife;
  get maxStamina => _maxStamina;

  double _life = 0;
  double _stamina = 0;

  double get life => _life;
  double get stamina => _stamina;

  /// 设置生命值
  set life(double newLife) {
    _life = newLife;
    notifyListeners();
  }

  /// 设置耐力
  /// 
  /// [newStamina] 当前耐力
  set stamina(double newStamina) {
    _stamina = newStamina;
    notifyListeners();
  }

  /// 配置
  void configure({required double maxLife, required double maxStamina}) {
    _maxLife = maxLife;
    _maxStamina = maxStamina;
  }

  @override
  void update(double dt) {}
  
}