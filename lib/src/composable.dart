import 'package:flutter/widgets.dart';

class ComposableValueNotifier<T> extends ValueNotifier {
  ComposableValueNotifier(value) : super(value);
}

abstract class Composable<T> extends Widget {
  ComposableValueNotifier<T> viewModel;
}

abstract class ComposableStatelessWidget<T> extends StatelessWidget
    implements Composable<T> {}

abstract class ComposableStatefulWidget<T> extends StatefulWidget
    implements Composable<T> {}

abstract class ComposableState<T extends ComposableStatefulWidget, V>
    extends State<T> {
  V viewModel;

  @override
  void initState() {
    widget.viewModel.addListener(viewModelNotifier);
    super.initState();
  }

  void viewModelNotifier() {
    setState(() {});
  }
}
