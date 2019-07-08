import 'Provider.dart';

abstract class FoodProvider extends Provider {
  String ingredient();

  String spice();

  String measurement();
}
