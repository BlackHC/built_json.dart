// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:built_collection/built_collection.dart';
import 'package:built_json/built_json.dart';

/// Default implementation of [Serializers].
class BuiltJsonSerializers implements Serializers {
  final BuiltMap<Type, Serializer> _typeToSerializer;
  final BuiltMap<String, Serializer> _wireNameToSerializer;
  final BuiltMap<String, Serializer> _typeNameToSerializer;

  final BuiltMap<GenericType, Function> _builderFactories;

  BuiltJsonSerializers._(this._typeToSerializer, this._wireNameToSerializer,
      this._typeNameToSerializer, this._builderFactories);

  @override
  Object serialize(Object object,
      {GenericType genericType: const GenericType()}) {
    if (genericType.isObject) {
      final serializer = _getSerializerByType(object.runtimeType);
      if (serializer == null) throw new StateError(
          "No serializer for '${object.runtimeType}'.");
      final serialized = serializer.serialize(this, object);

      if (serializer.structured) {
        final result = <Object>[serializer.wireName];
        return result..addAll(serialized as Iterable);
      } else {
        return <Object>[serializer.wireName, serialized];
      }
    } else {
      final serializer = _getSerializerByType(genericType.root);
      if (serializer == null) throw new StateError(
          "No serializer for '${genericType.root}'.");
      final result =
          serializer.serialize(this, object, genericType: genericType);
      return serializer.structured ? (result as Iterable).toList() : result;
    }
  }

  @override
  Object deserialize(Object object,
      {GenericType genericType: const GenericType()}) {
    if (genericType.isObject) {
      final wireName = (object as List).first;

      final serializer = _wireNameToSerializer[wireName];
      if (serializer ==
          null) throw new StateError("No serializer for '${wireName}'.");
      final json = serializer.structured
          ? (object as List).sublist(1)
          : (object as List)[1];
      return serializer.deserialize(this, json);
    } else {
      final serializer = _getSerializerByType(genericType.root);
      if (serializer == null) throw new StateError(
          "No serializer for '${genericType.root}'.");
      return serializer.deserialize(this, object, genericType: genericType);
    }
  }

  @override
  Object newBuilder(types) {
    final builderFactory = _builderFactories[types];
    return builderFactory == null ? null : builderFactory();
  }

  @override
  SerializersBuilder toBuilder() {
    return new BuiltJsonSerializersBuilder._(
        _typeToSerializer.toBuilder(),
        _wireNameToSerializer.toBuilder(),
        _typeNameToSerializer.toBuilder(),
        _builderFactories.toBuilder());
  }

  Serializer _getSerializerByType(Type type) {
    return _typeToSerializer[type] ?? _typeNameToSerializer[_getName(type)];
  }
}

/// Default implementation of [SerializersBuilder].
class BuiltJsonSerializersBuilder implements SerializersBuilder {
  MapBuilder<Type, Serializer> _typeToSerializer =
      new MapBuilder<Type, Serializer>();
  MapBuilder<String, Serializer> _wireNameToSerializer =
      new MapBuilder<String, Serializer>();
  MapBuilder<String, Serializer> _typeNameToSerializer =
      new MapBuilder<String, Serializer>();

  MapBuilder<GenericType, Function> _builderFactories =
      new MapBuilder<GenericType, Function>();

  BuiltJsonSerializersBuilder();

  BuiltJsonSerializersBuilder._(
      this._typeToSerializer,
      this._wireNameToSerializer,
      this._typeNameToSerializer,
      this._builderFactories);

  void add(Serializer serializer) {
    _wireNameToSerializer[serializer.wireName] = serializer;
    for (final type in serializer.types) {
      _typeToSerializer[type] = serializer;
      _typeNameToSerializer[_getName(type)] = serializer;
    }
  }

  void addBuilderFactory(GenericType types, Function function) {
    _builderFactories[types] = function;
  }

  Serializers build() {
    return new BuiltJsonSerializers._(
        _typeToSerializer.build(),
        _wireNameToSerializer.build(),
        _typeNameToSerializer.build(),
        _builderFactories.build());
  }
}

String _getName(Type type) => _makeRaw(type.toString());

String _makeRaw(String name) {
  final genericsStart = name.indexOf('<');
  return genericsStart == -1 ? name : name.substring(0, genericsStart);
}
