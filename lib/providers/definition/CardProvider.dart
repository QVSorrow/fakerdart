import 'Provider.dart';

abstract class CardProvider extends Provider {
  String name();

  String brand();

  String number();

  String type();

  String expirationDate();
}
