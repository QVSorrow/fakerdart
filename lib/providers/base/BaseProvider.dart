import '../../fakedart.dart';

class BaseProvider {

    final _valuesMap = Map<String, String>();

    void _putValue(String key, String value) {
        _valuesMap[key]=value;
    }

    String getValue(String key, Function fakeItValue) {
        if (Fakedart.getUniqueValue()) {
            if (!_valuesMap.containsKey(key)) {
               _putValue(key, fakeItValue());
            }
            return _valuesMap[key];
        } else {
            return  fakeItValue();
        }
    }
}