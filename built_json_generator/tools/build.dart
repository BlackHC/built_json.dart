// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:built_value_generator/built_value_generator.dart';
import 'package:source_gen/source_gen.dart';

void main(List<String> args) {
  build(args, [
    new BuiltValueGenerator(),
  ]).then((result) => print(result));
}
