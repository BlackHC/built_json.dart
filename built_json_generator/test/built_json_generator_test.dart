// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:built_json_generator/built_json_generator.dart';
import 'package:source_gen/source_gen.dart' as source_gen;
import 'package:test/test.dart';

void main() {
  group('generator', () async {
    test('ignores empty library', () async {
      expect(await generate('library value;'), isEmpty);
    });

    test('ignores normal class', () async {
      expect(await generate(r'''
library value;

class EmptyClass {}
'''), isEmpty);
    });

    test('ignores built_value class without serializer', () async {
      expect(await generate(r'''
library value;

import 'package:test_support/test_support.dart';

abstract class Value implements Built<Value, ValueBuilder> {}
'''), isEmpty);
    });

    test('generates for built_value class with serializer', () async {
      expect(await generate(r'''
library value;

import 'package:test_support/test_support.dart';

abstract class Value implements Built<Value, ValueBuilder> {
  static final Serializer<Value> serializer = _$serializer;
}
'''), isNotEmpty);
    });

    test('ignores EnumClass without serializer', () async {
      expect(await generate(r'''
library value;

import 'package:test_support/test_support.dart';

class Enum extends EnumClass {}
'''), isEmpty);
    });

    test('generates for EnumClass with serializer', () async {
      expect(await generate(r'''
library value;

import 'package:test_support/test_support.dart';

class Enum extends EnumClass {
  static final Serializer<Enum> serializer = _$serializer;
}
'''), isNotEmpty);
    });

    test('generates for serializers', () async {
      expect(await generate(r'''
library value;

import 'package:test_support/test_support.dart';

final Serializers serializers = _$serializers;
'''), isNotEmpty);
    });

    test('generates correct serializer for built_value with primitives',
        () async {
      expect(
          await generate(r'''
library value;

import 'package:test_support/test_support.dart';

abstract class Value implements Built<Value, ValueBuilder> {
  static final Serializer<Value> serializer = _$serializer;
  bool get aBool;
  double get aDouble;
  int get anInt;
  String get aString;
}

abstract class ValueBuilder implements Builder<Value, ValueBuilder> {
  bool aBool;
  double aDouble;
  int anInt;
  String aString;
}
'''),
          r'''// GENERATED CODE - DO NOT MODIFY BY HAND

part of value;

// **************************************************************************
// Generator: BuiltJsonGenerator
// Target: library value
// **************************************************************************

Serializer<Value> _$valueSerializer = new _$ValueSerializer();

class _$ValueSerializer implements Serializer<Value> {
  final bool structured = true;
  final Iterable<Type> types = new BuiltList<Type>([Value, _$Value]);
  final String wireName = 'Value';

  @override
  Object serialize(Serializers serializers, Value object,
      {GenericType genericType: const GenericType()}) {
    return [
      'aBool',
      serializers.serialize(object.aBool, genericType: const GenericType(bool)),
      'aDouble',
      serializers.serialize(object.aDouble,
          genericType: const GenericType(double)),
      'anInt',
      serializers.serialize(object.anInt, genericType: const GenericType(int)),
      'aString',
      serializers.serialize(object.aString,
          genericType: const GenericType(String)),
    ];
  }

  @override
  Value deserialize(Serializers serializers, Object object,
      {GenericType genericType: const GenericType()}) {
    final result = new ValueBuilder();

    var key;
    var value;
    var expectingKey = true;
    for (final item in object as List) {
      if (expectingKey) {
        key = item;
        expectingKey = false;
      } else {
        value = item;
        expectingKey = true;

        switch (key as String) {
          case 'aBool':
            result.aBool = serializers.deserialize(value,
                genericType: const GenericType(bool));
            break;
          case 'aDouble':
            result.aDouble = serializers.deserialize(value,
                genericType: const GenericType(double));
            break;
          case 'anInt':
            result.anInt = serializers.deserialize(value,
                genericType: const GenericType(int));
            break;
          case 'aString':
            result.aString = serializers.deserialize(value,
                genericType: const GenericType(String));
            break;
        }
      }
    }

    return result.build();
  }
}
''');
    });

    test('generates correct serializer for built_value with collections',
        () async {
      expect(
          await generate(r'''
library value;

import 'package:test_support/test_support.dart';

abstract class Value implements Built<Value, ValueBuilder> {
  static final Serializer<Value> serializer = _$serializer;
  BuiltList<String> get aList;
  BuiltMap<String, int> get aMap;
}

abstract class ValueBuilder implements Builder<Value, ValueBuilder> {
  ListBuilder<String> aList;
  MapBuilder<String, int> aMap;
}
'''),
          r'''
// GENERATED CODE - DO NOT MODIFY BY HAND

part of value;

// **************************************************************************
// Generator: BuiltJsonGenerator
// Target: library value
// **************************************************************************

Serializer<Value> _$valueSerializer = new _$ValueSerializer();

class _$ValueSerializer implements Serializer<Value> {
  final bool structured = true;
  final Iterable<Type> types = new BuiltList<Type>([Value, _$Value]);
  final String wireName = 'Value';

  @override
  Object serialize(Serializers serializers, Value object,
      {GenericType genericType: const GenericType()}) {
    return [
      'aList',
      serializers.serialize(object.aList,
          genericType:
              const GenericType(BuiltList, const [const GenericType(String)])),
      'aMap',
      serializers.serialize(object.aMap,
          genericType: const GenericType(BuiltMap,
              const [const GenericType(String), const GenericType(int)])),
    ];
  }

  @override
  Value deserialize(Serializers serializers, Object object,
      {GenericType genericType: const GenericType()}) {
    final result = new ValueBuilder();

    var key;
    var value;
    var expectingKey = true;
    for (final item in object as List) {
      if (expectingKey) {
        key = item;
        expectingKey = false;
      } else {
        value = item;
        expectingKey = true;

        switch (key as String) {
          case 'aList':
            result.aList.replace(serializers.deserialize(value,
                genericType: const GenericType(
                    BuiltList, const [const GenericType(String)])));
            break;
          case 'aMap':
            result.aMap.replace(serializers.deserialize(value,
                genericType: const GenericType(BuiltMap, const [
                  const GenericType(String),
                  const GenericType(int)
                ])));
            break;
        }
      }
    }

    return result.build();
  }
}
''');
    });

    test('generates correct serializer for nested built_value', () async {
      expect(
          await generate(r'''
library value;

import 'package:test_support/test_support.dart';

abstract class Value implements Built<Value, ValueBuilder> {
  static final Serializer<Value> serializer = _$serializer;
  Value get value;
}

abstract class ValueBuilder implements Builder<Value, ValueBuilder> {
  ValueBuilder value;
}
'''),
          r'''
// GENERATED CODE - DO NOT MODIFY BY HAND

part of value;

// **************************************************************************
// Generator: BuiltJsonGenerator
// Target: library value
// **************************************************************************

Serializer<Value> _$valueSerializer = new _$ValueSerializer();

class _$ValueSerializer implements Serializer<Value> {
  final bool structured = true;
  final Iterable<Type> types = new BuiltList<Type>([Value, _$Value]);
  final String wireName = 'Value';

  @override
  Object serialize(Serializers serializers, Value object,
      {GenericType genericType: const GenericType()}) {
    return [
      'value',
      serializers.serialize(object.value,
          genericType: const GenericType(Value)),
    ];
  }

  @override
  Value deserialize(Serializers serializers, Object object,
      {GenericType genericType: const GenericType()}) {
    final result = new ValueBuilder();

    var key;
    var value;
    var expectingKey = true;
    for (final item in object as List) {
      if (expectingKey) {
        key = item;
        expectingKey = false;
      } else {
        value = item;
        expectingKey = true;

        switch (key as String) {
          case 'value':
            result.value.replace(serializers.deserialize(value,
                genericType: const GenericType(Value)));
            break;
        }
      }
    }

    return result.build();
  }
}
''');
    });

    test('generates correct serializer for EnumClass', () async {
      expect(await generate(r'''
library value;

import 'package:test_support/test_support.dart';

abstract class TestEnum extends EnumClass {
  static final Serializer<TestEnum> serializer = _$serializer;

  static const TestEnum yes = _$yes;
  static const TestEnum no = _$no;
  static const TestEnum maybe = _$maybe;
}
'''), r'''
// GENERATED CODE - DO NOT MODIFY BY HAND

part of value;

// **************************************************************************
// Generator: BuiltJsonGenerator
// Target: library value
// **************************************************************************

Serializer<TestEnum> _$testEnumSerializer = new _$TestEnumSerializer();

class _$TestEnumSerializer implements Serializer<TestEnum> {
  final bool structured = false;
  final Iterable<Type> types = new BuiltList<Type>([TestEnum]);
  final String wireName = 'TestEnum';

  @override
  Object serialize(Serializers serializers, TestEnum object,
      {GenericType genericType: const GenericType()}) {
    return object.name;
  }

  @override
  TestEnum deserialize(Serializers serializers, Object object,
      {GenericType genericType: const GenericType()}) {
    return TestEnum.valueOf(object);
  }
}
''');
    });
  });
}

// Test setup.

Future<String> generate(String source) async {
  final tempDir =
      Directory.systemTemp.createTempSync('built_json_generator.dart.');
  final packageDir = new Directory(tempDir.path + '/packages')..createSync();
  final builtJsonDir = new Directory(packageDir.path + '/test_support')
    ..createSync();
  final builtJsonFile = new File(builtJsonDir.path + '/test_support.dart')
    ..createSync();
  builtJsonFile.writeAsStringSync(testSupportSource);

  final libDir = new Directory(tempDir.path + '/lib')..createSync();
  final sourceFile = new File(libDir.path + '/value.dart');
  sourceFile.writeAsStringSync(source);

  await source_gen.generate(tempDir.path, [new BuiltJsonGenerator()],
      librarySearchPaths: <String>['lib'], omitGenerateTimestamp: true);
  final outputFile = new File(libDir.path + '/value.g.dart');
  return outputFile.existsSync() ? outputFile.readAsStringSync() : '';
}

// Classes mentioned in the test input need to exist, but we don't need the
// real versions. So just use minimal ones.
const String testSupportSource = r'''
class Built<V, B> {}

class BuiltList<E> {}

class BuiltMap<K, V> {}

class EnumClass {}

class Serializer<T> {}

class Serializers {}
''';
