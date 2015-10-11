// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-11-08T12:39:28.012Z

part of value;

// **************************************************************************
// Generator: BuiltJsonGenerator
// Target: library value
// **************************************************************************

BuiltJsonSerializers _$builtJsonSerializers = new BuiltJsonSerializers()
  ..add(new _$ValueSerializer());
BuiltJsonSerializer<Value> _$valueSerializer = new _$ValueSerializer();

class _$ValueSerializer implements BuiltJsonSerializer<Value> {
  final Type type = _$Value;
  final String typeName = 'Value';
  Object serialize(BuiltJsonSerializers builtJsonSerializers, Value object,
      {String expectedType}) {
    return {
      'anInt':
          builtJsonSerializers.serialize(object.anInt, expectedType: 'int'),
      'aString': builtJsonSerializers.serialize(object.aString,
          expectedType: 'String'),
      'anObject': builtJsonSerializers.serialize(object.anObject,
          expectedType: 'Object'),
      'aDefaultInt': builtJsonSerializers.serialize(object.aDefaultInt,
          expectedType: 'int'),
      'listOfInt': builtJsonSerializers.serialize(object.listOfInt,
          expectedType: 'BuiltList<int>'),
    };
  }

  Value deserialize(BuiltJsonSerializers builtJsonSerializers, Object object,
      {String expectedType}) {
    return new Value((b) => b
      ..anInt =
          builtJsonSerializers.deserialize(object['anInt'], expectedType: 'int')
      ..aString = builtJsonSerializers.deserialize(object['aString'],
          expectedType: 'String')
      ..anObject = builtJsonSerializers.deserialize(object['anObject'],
          expectedType: 'Object')
      ..aDefaultInt = builtJsonSerializers.deserialize(object['aDefaultInt'],
          expectedType: 'int')
      ..listOfInt.replace(builtJsonSerializers.deserialize(object['listOfInt'],
          expectedType: 'BuiltList<int>')));
  }
}

// **************************************************************************
// Generator: BuiltValueGenerator
// Target: abstract class Value
// **************************************************************************

class _$Value extends Value {
  final int anInt;
  final String aString;
  final Object anObject;
  final int aDefaultInt;
  final BuiltList<int> listOfInt;
  _$Value._(
      {this.anInt,
      this.aString,
      this.anObject,
      this.aDefaultInt,
      this.listOfInt})
      : super._() {
    if (anInt == null) throw new ArgumentError('null anInt');
    if (aString == null) throw new ArgumentError('null aString');
    if (aDefaultInt == null) throw new ArgumentError('null aDefaultInt');
    if (listOfInt == null) throw new ArgumentError('null listOfInt');
  }
  factory _$Value([updates(ValueBuilder b)]) =>
      (new ValueBuilder()..update(updates)).build();
  Value rebuild(updates(ValueBuilder b)) =>
      (toBuilder()..update(updates)).build();
  _$ValueBuilder toBuilder() => new _$ValueBuilder()..replace(this);
  bool operator ==(other) {
    if (other is! Value) return false;
    return anInt == other.anInt &&
        aString == other.aString &&
        anObject == other.anObject &&
        aDefaultInt == other.aDefaultInt &&
        listOfInt == other.listOfInt;
  }

  int get hashCode {
    return hashObjects([anInt, aString, anObject, aDefaultInt, listOfInt]);
  }

  String toString() {
    return 'Value {'
        'anInt=${anInt.toString()}\n'
        'aString=${aString.toString()}\n'
        'anObject=${anObject.toString()}\n'
        'aDefaultInt=${aDefaultInt.toString()}\n'
        'listOfInt=${listOfInt.toString()}\n'
        '}';
  }
}

class _$ValueBuilder extends ValueBuilder {
  _$ValueBuilder() : super._();
  int get anInt => super.anInt;
  void set anInt(int anInt) {
    if (anInt == null) throw new ArgumentError('null anInt');
    super.anInt = anInt;
  }

  String get aString => super.aString;
  void set aString(String aString) {
    if (aString == null) throw new ArgumentError('null aString');
    super.aString = aString;
  }

  Object get anObject => super.anObject;
  void set anObject(Object anObject) {
    super.anObject = anObject;
  }

  int get aDefaultInt => super.aDefaultInt;
  void set aDefaultInt(int aDefaultInt) {
    if (aDefaultInt == null) throw new ArgumentError('null aDefaultInt');
    super.aDefaultInt = aDefaultInt;
  }

  ListBuilder<int> get listOfInt => super.listOfInt;
  void set listOfInt(ListBuilder<int> listOfInt) {
    if (listOfInt == null) throw new ArgumentError('null listOfInt');
    super.listOfInt = listOfInt;
  }

  void replace(Value other) {
    super.anInt = other.anInt;
    super.aString = other.aString;
    super.anObject = other.anObject;
    super.aDefaultInt = other.aDefaultInt;
    super.listOfInt = other.listOfInt?.toBuilder();
  }

  void update(updates(ValueBuilder b)) {
    if (updates != null) updates(this);
  }

  Value build() => new _$Value._(
      anInt: anInt,
      aString: aString,
      anObject: anObject,
      aDefaultInt: aDefaultInt,
      listOfInt: listOfInt?.build());
}
