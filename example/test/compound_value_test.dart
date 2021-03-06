// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:example/compound_value.dart';
import 'package:example/test_enum.dart' hide serializers;
import 'package:test/test.dart';

void main() {
  group('Value', () {
    test('can be serialized', () {
      final compoundValue = new CompoundValue((b) => b
        ..aValue.anInt = 1
        ..aValue.aString = 'two'
        ..aValue.anObject = 3
        ..aTestEnum = TestEnum.no);

      expect(serializers.serialize(compoundValue), [
        'CompoundValue',
        'aValue',
        [
          'anInt',
          1,
          'aString',
          'two',
          'anObject',
          ['int', 3],
          'aDefaultInt',
          7,
          'listOfInt',
          [],
        ],
        'aTestEnum',
        'no',
      ]);
    });

    test('can be deserialized', () {
      final compoundValue = new CompoundValue((b) => b
        ..aValue.anInt = 1
        ..aValue.aString = 'two'
        ..aValue.anObject = 3
        ..aTestEnum = TestEnum.no);

      expect(serializers.deserialize(serializers.serialize(compoundValue)),
          compoundValue);
    });
  });
}
