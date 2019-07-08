import 'Provider.dart';

abstract class BankProvider extends Provider {
  String name();

  String swiftBic();

  String bankCountryCode();

  String ibanLetterCode();

  String ibanDigits();
}
