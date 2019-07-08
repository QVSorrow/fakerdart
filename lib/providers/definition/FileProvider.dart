import 'Provider.dart';

abstract class FileProvider extends Provider {
  String extension();

  String mimeType();
}
