import 'package:flutter/widgets.dart';

import '../compose.dart';

abstract class ComposableStatefulWidget<T> extends StatefulWidget
    implements Composable<T> {
  const ComposableStatefulWidget({Key key}) : super(key: key);
}

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
