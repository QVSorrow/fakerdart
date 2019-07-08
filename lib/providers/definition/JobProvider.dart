import 'Provider.dart';

abstract class JobProvider extends Provider {
  String field();

  String seniority();

  String position();

  String title();

  String keySkill();
}
