import 'Provider.dart';

abstract class AppProvider extends Provider {
  String name();

  String version();

  String author();
}
