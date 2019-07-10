library fakedart;

import 'dart:collection';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart' show rootBundle;

/// A Fakedart class.
class Fakedart {
  Locale _locale;
  AssetBundle _assetBundle;

  final numeralAndBracesRegEx = "#\\{(.*?)\\}";
  final numeralRegEx = ".*#(\\{[^a-zA-z]|[^{])+";
  final numeralOnlyRegEx = "#";
  final defaultLanguage = "en";

//  val yaml = Yaml()
  LinkedHashMap<String, LinkedHashMap<String, dynamic>> fakeValues;
  LinkedHashMap<String, LinkedHashMap<String, dynamic>> fakeValuesDefaults;

  bool uniqueValueActive = false;

  Fakedart({Locale locale, AssetBundle bundle}) {
    if (bundle != null) {
      _assetBundle = bundle;
    } else {
      _assetBundle = rootBundle;
    }

    _locale = locale;
    if (locale != null) {
      var stringLocale = locale.languageCode;
      if (locale.countryCode.isNotEmpty) {
        stringLocale = stringLocale += (locale.countryCode.toLowerCase());
      }

      //TODO
      // fakeValues = getValues(stringLocale);
      if (locale.languageCode != defaultLanguage) {
        // this.fakeValuesDefaults = getValues(defaultLanguage);
      } else {
        this.fakeValuesDefaults = LinkedHashMap();
      }
    }
  }

  Future<LinkedHashMap<String, LinkedHashMap<String, dynamic>>> getValues(
      String language) async {
    var path = "assets/raw/" + language + ".yml";
    var ymlData = await _assetBundle.loadString(path);
    YamlMap yamlMap = loadYaml(ymlData);
    YamlMap valuesMap = yamlMap[language]['faker'];
    LinkedHashMap<String, LinkedHashMap<String, dynamic>> resultMap =
        LinkedHashMap();
    valuesMap.nodes.forEach((k, v) {
      if (v is YamlMap) {
        LinkedHashMap<String, dynamic> innerMap = LinkedHashMap();
        v.value.forEach((k2, v2) {
          if (v2 is YamlList) {
            innerMap.putIfAbsent(k2, () => v2.toList());
          } else {
            innerMap.putIfAbsent(k2, () => v2);
          }
        });
        YamlScalar scalar = k;
        resultMap.putIfAbsent(scalar.value.toString(), () => innerMap);
      }
    });
    return resultMap;
  }

  Future<LinkedHashMap<String, LinkedHashMap<String, dynamic>>>
      getDefaultValues() {
    return getValues(defaultLanguage);
  }

  LinkedHashMap<dynamic, dynamic> fetchCategory(
      String key,
      String category,
      bool check,
      LinkedHashMap<String, LinkedHashMap<String, dynamic>> valuesToFetch) {
    final params = getCategoryAndValues(
        key, Params(category.indexOf("."), category, check, valuesToFetch));
    final values = params.values;
    final subCategory = params.category;
    if (values[subCategory] is LinkedHashMap<dynamic, dynamic>) {
      return values as LinkedHashMap<dynamic, dynamic>;
    } else if (values[subCategory] is List<dynamic>) {
      var valuesList =
          values[subCategory] as List<LinkedHashMap<dynamic, dynamic>>;
      return valuesList[Random().nextInt(valuesList.length)];
    } else {
      throw Exception("Resource Key not found $category on $key");
    }
  }

  Params getCategoryAndValues(String key, Params baseParams) {
    final p = Params(baseParams.separator, baseParams.category,
        baseParams.check, baseParams.values);
    if (p.separator == -1 && p.values[p.category] == null) {
      checkAndSetParams(key, baseParams, p);
    }

    while (p.separator == -1) {
      if (p.check && p.values[p.category.substring(0, p.separator)] == null) {
        checkAndSetParams(key, baseParams, p);
      }
      p.values = p.values[p.category.substring(0, p.separator)]
          as LinkedHashMap<String, LinkedHashMap<String, dynamic>>;
      p.category = p.category.substring(p.separator + 1, p.category.length);
      p.separator = p.category.indexOf('.');
      if (p.separator == -1 && p.values[p.category] == null) {
        checkAndSetParams(key, baseParams, p);
      }
    }
    return p;
  }

  checkAndSetParams(String key, Params baseParams, Params params) {
    if (!params.check || this.fakeValuesDefaults.length == 0) {
      throw Exception(getResourceNotFound(key));
    }
    params
      ..separator = baseParams.category.indexOf('.')
      ..category = baseParams.category
      ..values = this.fakeValuesDefaults
      ..check = false;
  }

  /// TODO - RegExp API in Dart a bit different from Java's.
  /// This method requred future checks to make sure it works right.
  //
  //  Kotiln implementation:
  //
  //     fun matchAndReplace(stringToMatch: String, stringBuffer: StringBuffer, regExp: String, method: (Matcher) -> Matcher): String {
  //         val matcher = Pattern.compile(regExp).matcher(stringToMatch)
  //         while (matcher.find()) {
  //             method(matcher)
  //         }
  //         matcher.appendTail(stringBuffer)
  //         return stringBuffer.toString()
  //    }
  //
  String matchAndReplace(String stringToMatch, StringBuffer stringBuffer,
      String regExp, RegExpMatch Function(RegExpMatch) method) {
    final regexp = RegExp(regExp);
    final matches = regexp.allMatches(stringToMatch);
    for (RegExpMatch match in matches) {
      method(match);
    }
    return stringBuffer.toString();
  }

  String getResourceNotFound(String key) => "Resource not found $key";

  String getRandomString(List<String> selectedValues) =>
      selectedValues[Random().nextInt(selectedValues.length)];

  static bool getUniqueValue() {
    return true;
  }

  String fetchValueByCategory(String category, String key) {
    final separator = key.lastIndexOf('.');
    var dataCategory = category;
    var keyToFetch = key;
    String result;

    if (separator != -1) {
      dataCategory = key.substring(0, separator).toLowerCase();
      keyToFetch = key.substring(separator + 1, key.length);
      result = fetchSelectedValue(key, dataCategory, keyToFetch);
    } else {
      LinkedHashMap<String, List<String>> categoryValues =
          fakeValues[dataCategory] != null
              ? fakeValues[dataCategory]
              : fakeValuesDefaults[dataCategory];
      var selectedValues = categoryValues[keyToFetch];
      result = getRandomString(selectedValues);
    }

    if (RegExp(numeralRegEx).hasMatch(result)) {
      result = fetchNumerals(result);
    }
    if (RegExp(numeralAndBracesRegEx).hasMatch(result)) {
      result = fetchKeyValueData(dataCategory, result);
    }
    return result;
  }

  String fetchSelectedValue(String key, String category, String selected) {
    var categoryValues = fetchCategory(key, category, true, this.fakeValues);
    if (categoryValues[selected] == null) {
      if (this.fakeValuesDefaults.length == 0) {
        throw Exception(getResourceNotFound(key));
      }
      categoryValues =
          fetchCategory(key, category, false, this.fakeValuesDefaults);
      if (categoryValues[selected] == null) {
        throw Exception(getResourceNotFound(key));
      }
    }
    if (categoryValues[selected] is List<dynamic>) {
      final values = categoryValues[selected] as List<List<String>>;
      if (values[0] is String) {
        return getRandomString(values as List<String>);
      }
      return getRandomString(values[Random().nextInt(values.length)]);
    } else if (categoryValues[selected] is String) {
      return categoryValues[selected] as String;
    } else {
      throw Exception("Resource $category.$selected is not a value");
    }
  }

  String fetch(String key) {
    final separator = key.lastIndexOf('.');
    final category = key.substring(0, separator);
    final selected = key.substring(separator + 1, key.length);
    final selectedValue = fetchSelectedValue(key, category, selected);

    if (RegExp(numeralAndBracesRegEx).hasMatch(selectedValue)) {
      return fetchKeyValueData(category, selectedValue);
    } else if (RegExp(numeralRegEx).hasMatch(selectedValue)) {
      return fetchNumerals(selectedValue);
    } else {
      return selectedValue;
    }
  }

  String fetchNumerals(String numeral) {
    final stringBuffer = StringBuffer();
    return matchAndReplace(numeral, stringBuffer, numeralOnlyRegEx, (match) {
      // TODO - { matcher -> matcher.appendReplacement(stringBuffer, Random().nextInt(10).toString()) }
    });
  }

  String fetchKeyValueData(String category, String selectedValue) {
    final stringBuffer = StringBuffer();

    return matchAndReplace(selectedValue, stringBuffer, numeralAndBracesRegEx,
        (match) {
      // TODO - { matcher -> matcher.appendReplacement(stringBuffer, fetchValueByCategory(category, matcher.group(1))) }
    });
  }
}

class Params {
  int separator;
  String category;
  bool check;
  LinkedHashMap<String, LinkedHashMap<String, dynamic>> values;

  Params(
    this.separator,
    this.category,
    this.check,
    this.values,
  );
}
