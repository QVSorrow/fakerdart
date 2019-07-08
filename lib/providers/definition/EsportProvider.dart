import 'Provider.dart';

abstract class EsportProvider extends Provider {
  String player();

  String team();

  String league();

  String event();

  String game();
}
