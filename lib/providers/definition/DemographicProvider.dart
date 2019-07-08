import 'Provider.dart';

abstract class DemographicProvider extends Provider {
  String race();

  String educationalAttainment();

  String demonym();

  String maritalStatus();

  String sex();
}
