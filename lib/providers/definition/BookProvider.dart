import 'Provider.dart';

abstract class BookProvider extends Provider {
  String title();

  String author();

  String publisher();

  String genre();
}
