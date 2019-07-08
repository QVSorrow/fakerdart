import 'Provider.dart';

abstract class CoffeeProvider extends Provider {
  String blendName();

  String origin();

  String variety();

  String notes();
}
