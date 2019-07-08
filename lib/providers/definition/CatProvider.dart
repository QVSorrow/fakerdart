import 'Provider.dart';

abstract class CatProvider extends Provider {
  String name();

  String breed();

  String registry();
}
