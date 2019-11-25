import 'package:flutter/widgets.dart';
import '../compose.dart';

abstract class ComposableStatefulWidget<T> extends StatefulWidget
    implements Composable<T> {
  final ComponentModel<T> _componentModel;

  ComposableStatefulWidget(T componentModel, {Key key})
      : this._componentModel = ComponentModel(componentModel),
        super(key: key);

  @override
  T get componentModel => _componentModel.value;
  @override
  set componentModel(T componentModel) =>
      _componentModel.value = componentModel;
}

abstract class ComposableState<T extends ComposableStatefulWidget>
    extends State<T> {
  @override
  void initState() {
    widget._componentModel.addListener(componentModelNotifier);
    super.initState();
  }

  void componentModelNotifier() {
    setState(() {});
  }

  @override
  void dispose() {
    widget._componentModel.removeListener(componentModelNotifier);
    super.dispose();
  }
}
