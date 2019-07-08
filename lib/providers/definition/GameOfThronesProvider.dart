import 'Provider.dart';

abstract class GameOfThronesProvider extends Provider {
  String character();

  String house();

  String city();

  String quote();

  String dragon();
}
