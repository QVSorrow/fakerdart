import 'Provider.dart';

abstract class NameProvider extends Provider {
  String name();

  String nameWithMiddle();

  String firstName();

  String lastName();

  String prefix();

  String suffix();

  String title();
}
