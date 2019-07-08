library fakedart;

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

/// A Fakedart class.
class Fakedart {
  final Locale locale;

  final numeralAndBracesRegEx = "#\\{(.*?)\\}";
  final numeralRegEx = ".*#(\\{[^a-zA-z]|[^{])+";
  final numeralOnlyRegEx = "#";
  final defaultLanguage = "en";

//  val yaml = Yaml()
  LinkedHashMap<String, LinkedHashMap<String, String>> fakeValues;
  LinkedHashMap<String, LinkedHashMap<String, String>> fakeValuesDefaults;

  bool uniqueValueActive = false;

  Fakedart(this.locale){
    var stringLocale = locale.languageCode;

    if (locale.countryCode.isNotEmpty) {
      stringLocale = stringLocale+=(locale.countryCode.toLowerCase());
    }

    //TODO
//    this.fakeValues = getValues(stringLocale);
    if (locale.languageCode != defaultLanguage) {
//      this.fakeValuesDefaults = getValues(defaultLanguage);
    } else {
      this.fakeValuesDefaults = LinkedHashMap();
    }
  }


  static bool getUniqueValue() {
    return true;
  }
}
