import 'Provider.dart';

abstract class MusicProvider extends Provider {
  String key();

  String chord();

  String instrument();

  String keyTypes();

  String chordTypes();
}
