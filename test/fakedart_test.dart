import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fakedart/fakedart.dart';
import 'package:flutter_test/flutter_test.dart' as prefix0;

void main() async {
  Directory current = Directory.current;
  print(current.path);

  final AssetBundle bundle = TestAssetBundle(<String, List<String>>{
    'assets/raw/ca.yml': <String>['assets/raw/ca.yml'],
    'assets/raw/cacat.yml': <String>['assets/raw/cacat.yml'],
    'assets/raw/dadk.yml': <String>['assets/raw/dadk.yml'],
    'assets/raw/de.yml': <String>['assets/raw/de.yml'],
    'assets/raw/deat.yml': <String>['assets/raw/deat.yml'],
    'assets/raw/dech.yml': <String>['assets/raw/dech.yml'],
    'assets/raw/en.yml': <String>['assets/raw/en.yml'],
    'assets/raw/enau.yml': <String>['assets/raw/enau.yml'],
    'assets/raw/enauocker.yml': <String>['assets/raw/enauocker.yml'],
    'assets/raw/enbork.yml': <String>['assets/raw/enbork.yml'],
    'assets/raw/enca.yml': <String>['assets/raw/enca.yml'],
    'assets/raw/engb.yml': <String>['assets/raw/engb.yml'],
    'assets/raw/enind.yml': <String>['assets/raw/enind.yml'],
    'assets/raw/ennep.yml': <String>['assets/raw/ennep.yml'],
    'assets/raw/enng.yml': <String>['assets/raw/enng.yml'],
    'assets/raw/ennz.yml': <String>['assets/raw/ennz.yml'],
    'assets/raw/enpak.yml': <String>['assets/raw/enpak.yml'],
    'assets/raw/ensg.yml': <String>['assets/raw/ensg.yml'],
    'assets/raw/enug.yml': <String>['assets/raw/enug.yml'],
    'assets/raw/enus.yml': <String>['assets/raw/enus.yml'],
    'assets/raw/enza.yml': <String>['assets/raw/enza.yml'],
    'assets/raw/es.yml': <String>['assets/raw/es.yml'],
    'assets/raw/esmx.yml': <String>['assets/raw/esmx.yml'],
    'assets/raw/fa.yml': <String>['assets/raw/fa.yml'],
    'assets/raw/fifi.yml': <String>['assets/raw/fifi.yml'],
    'assets/raw/fr.yml': <String>['assets/raw/fr.yml'],
    'assets/raw/he.yml': <String>['assets/raw/he.yml'],
    'assets/raw/id.yml': <String>['assets/raw/id.yml'],
    'assets/raw/it.yml': <String>['assets/raw/it.yml'],
    'assets/raw/ja.yml': <String>['assets/raw/ja.yml'],
    'assets/raw/ko.yml': <String>['assets/raw/ko.yml'],
    'assets/raw/nbno.yml': <String>['assets/raw/nbno.yml'],
    'assets/raw/nl.yml': <String>['assets/raw/nl.yml'],
    'assets/raw/pl.yml': <String>['assets/raw/pl.yml'],
    'assets/raw/pt.yml': <String>['assets/raw/pt.yml'],
    'assets/raw/ptbr.yml': <String>['assets/raw/ptbr.yml'],
    'assets/raw/ru.yml': <String>['assets/raw/ru.yml'],
    'assets/raw/sk.yml': <String>['assets/raw/sk.yml'],
    'assets/raw/sv.yml': <String>['assets/raw/sv.yml'],
    'assets/raw/tr.yml': <String>['assets/raw/tr.yml'],
    'assets/raw/uk.yml': <String>['assets/raw/uk.yml'],
    'assets/raw/vi.yml': <String>['assets/raw/vi.yml'],
    'assets/raw/zhcn.yml': <String>['assets/raw/zhcn.yml'],
    'assets/raw/zhtw.yml': <String>['assets/raw/zhtw.yml'],
  });

  test('read yaml assets from file', () async {
    final fake = Fakedart(bundle: bundle);
    var values = await fake.getValues("en");

    expect(values, isNot(null));
  });
}

class TestAssetBundle extends CachingAssetBundle {
  TestAssetBundle(Map<String, List<String>> assets) : _assets = assets {
    for (String assetList in assets.keys) {
      for (String asset in assets[assetList]) {
        _assetMap[asset] = bytesForFile(asset);
      }
    }
  }

  final Map<String, ByteData> _assetMap = <String, ByteData>{};
  final Map<String, List<String>> _assets;

  @override
  Future<ByteData> load(String key) {
    if (key == 'AssetManifest.json') {
      return Future<ByteData>.value(bytesForJsonLike(_assets));
    }
    return Future<ByteData>.value(_assetMap[key]);
  }
}

ByteData bytesForJsonLike(Map<String, dynamic> jsonLike) => ByteData.view(
    Uint8List.fromList(const Utf8Encoder().convert(json.encode(jsonLike)))
        .buffer);

ByteData bytesForFile(String path) => ByteData.view(
    Uint8List.fromList(File('./' + path).readAsBytesSync()).buffer);
