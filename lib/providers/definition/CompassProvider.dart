import 'Provider.dart';

abstract class CompassProvider extends Provider {
  String cardinal();

  String ordinal();

  String half_wind();

  String quarter_wind();

  String direction();

  String abbreviation();

  String azimuth();

  String cardinal_abbreviation();

  String ordinal_abbreviation();

  String half_wind_abbreviation();

  String quarter_wind_abbreviation();

  String cardinal_azimuth();

  String ordinal_azimuth();

  String half_wind_azimuth();

  String quarter_wind_azimuth();
}
