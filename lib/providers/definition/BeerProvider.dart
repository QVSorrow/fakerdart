import 'Provider.dart';

abstract class BeerProvider extends Provider {
  String name();

  String style();

  String hop();

  String yeast();

  String malts();

  String ibu();

  String alcohol();

  String blg();
}
