import 'Provider.dart';

abstract class EducatorProvider extends Provider {
  String name();

  String secondary();

  String tertiaryType();

  String tertiaryCourseSubject();

  String tertiaryCourseType();
}
