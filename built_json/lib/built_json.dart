// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library built_json;

import 'src/bool_serializer.dart';
import 'src/built_json_serializers.dart';
import 'src/built_list_serializer.dart';
import 'src/built_map_serializer.dart';
import 'src/built_set_serializer.dart';
import 'src/double_serializer.dart';
import 'src/int_serializer.dart';
import 'src/string_serializer.dart';

export 'package:built_collection/built_collection.dart' show BuiltList;

/// Serializes all known classes.
///
/// See <https://github.com/google/built_json.dart/tree/master/example>
abstract class Serializers {
  /// Default [Serializers] that can serialize primitives and collections.
  ///
  /// Use [toBuilder] to add more serializers.
  factory Serializers() {
    return (new SerializersBuilder()
      ..add(new BoolSerializer())
      ..add(new BuiltListSerializer())
      ..add(new BuiltMapSerializer())
      ..add(new BuiltSetSerializer())
      ..add(new DoubleSerializer())
      ..add(new IntSerializer())
      ..add(new StringSerializer())).build();
  }

  /// Serializes [object].
  ///
  /// A [Serializer] must have been provided for every the object uses.
  ///
  /// Types that are known statically can be provided via [genericType]. This
  /// will reduce the amount of data needed on the wire. The exact same
  /// [genericType] will be needed to deserialize.
  ///
  /// Create one using [SerializersBuilder].
  Object serialize(Object object,
      {GenericType genericType: const GenericType()});

  /// Deserializes [serialized].
  ///
  /// A [Serializer] must have been provided for every the object uses.
  ///
  /// If [serialized] was produced by calling [serialize] with [genericType],
  /// the exact same [genericType] must be provided to deserialize.
  Object deserialize(Object serialized,
      {GenericType genericType: const GenericType()});

  /// Creates a new builder for the type represented by [genericType].
  ///
  /// For example, if [genericType] is `BuiltList<int, String>`, returns a
  /// `ListBuilder<int, String>`. This helps serializers to instantiate with
  /// correct generic type parameters.
  ///
  /// May return null if no matching builder factory has been added. In this
  /// case the serializer should fall back to `Object`.
  Object newBuilder(GenericType genericType);

  SerializersBuilder toBuilder();
}

/// Builder for [Serializers].
abstract class SerializersBuilder {
  factory SerializersBuilder() = BuiltJsonSerializersBuilder;

  void add(Serializer serializer);

  void addBuilderFactory(GenericType genericType, Function function);

  Serializers build();
}

/// A tree of [Type] instances.
class GenericType {
  /// The root of the type.
  final Type root;

  /// Type parameters of the type.
  final List<GenericType> leaves;

  const GenericType([this.root = Object, this.leaves = const []]);

  bool get isObject => root == Object;
}

/// Serializes a single type.
///
/// You should not usually need to implement this interface. Implementations
/// are provided for collections and primitives in `built_json`. Classes using
/// `built_value` and enums using `EnumClass` can have implementations
/// generated using `built_json_generator`.
abstract class Serializer<T> {
  /// Whether the serialized format for this type is structured or primitive.
  bool get structured;

  /// The [Type]s that can be serialized.
  ///
  /// They must all be equal to T or subclasses of T.
  Iterable<Type> get types;

  /// The wire name of the serializable type. For most classes, the class name.
  /// For primitives and collections a lower-case name is defined as part of
  /// the `built_json` wire format.
  String get wireName;

  /// Serializes [object].
  ///
  /// Use [serializers] as needed for nested serialization. Information about
  /// the type being serialized is provided in [genericType].
  Object serialize(Serializers serializers, T object,
      {GenericType genericType: const GenericType()});

  /// Deserializes [serialized].
  ///
  /// Use [serializers] as needed for nested deserialization. Information about
  /// the type being deserialized is provided in [genericType].
  T deserialize(Serializers serializers, Object serialized,
      {GenericType genericType: const GenericType()});
}
