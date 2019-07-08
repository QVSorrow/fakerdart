import 'Provider.dart';

abstract class AddressProvider extends Provider {
  String city();

  String streetAddress();

  String buildingNumber();

  String zipCode();

  String state();

  String stateAbbreviation();
}
