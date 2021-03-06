import 'package:composer/composer.dart';
import 'package:flutter/material.dart';

abstract class KeyValueModelable extends StatelessComposableModel {
  String keyValue;
  String value;
}

class KeyValueComposer extends Composer<KeyValueComposable>
    implements KeyValueModelable {
  void withKeyValue(String key) {
    this.keyValue = key;
  }

  void withValue(String value) {
    this.value = value;
  }

  @override
  KeyValueComposable compose() {
    var composableModel =
        KeyValueComposableModel(keyValue: keyValue, value: value);
    //TODO: find a better way
    composableModel.key = key;
    var keyValueComponent = KeyValueComposable(composableModel);
    return keyValueComponent;
  }

  @override
  String keyValue;

  @override
  String value;
}

class KeyValueComposableModel implements KeyValueModelable {
  String keyValue;
  String value;
  KeyValueComposableModel({this.keyValue, this.value});

  @override
  Key key;
}

class KeyValueComposable extends StatelessComposable<KeyValueModelable> {
  KeyValueComposable(KeyValueModelable composableModel)
      : super(composableModel);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(composableModel.keyValue),
          Text(composableModel.value),
        ]);
  }
}
