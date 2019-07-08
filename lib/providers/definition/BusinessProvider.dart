import 'Provider.dart';

abstract class BusinessProvider extends Provider {
  String name();

  String type();

  String subType();
}
