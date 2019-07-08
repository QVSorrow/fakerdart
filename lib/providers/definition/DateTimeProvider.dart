import 'Provider.dart';

abstract class DateTimeProvider extends Provider {
  String dateFormatter();

  String timeFormatter();

  String dateTimeFormatter();
}
