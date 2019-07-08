import 'Provider.dart';

abstract class RickAndMortyProvider extends Provider {
  String character();

  String location();

  String quote();
}
