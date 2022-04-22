import 'package:bonfire/bonfire.dart';

import 'bar_life_component.dart';

class KnightInterface extends GameInterface {
  @override
  void onMount() {
    super.onMount();
    add(BarLifeComponent());
  }
}
