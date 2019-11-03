import 'package:flutter/widgets.dart';

abstract class ComposableValueNotifier extends ValueNotifier<Composable> {
  ComposableValueNotifier(Composable value) : super(value);
}

abstract class Composable<T> extends Widget {
  T viewModel;
  ValueChanged<T> onChanged;
}

abstract class ComposableStatefulWidget<T> extends StatefulWidget
    implements Composable<T> {}

abstract class ComposableState<T extends ComposableStatefulWidget, V>
    extends State<T> {
  V viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;
    widget.onChanged = onChanged;
    super.initState();
  }

  void onChanged(V viewModel) {
    widget.viewModel = viewModel;
    setState(() {});
  }
}
