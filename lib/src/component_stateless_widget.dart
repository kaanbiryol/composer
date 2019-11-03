import 'package:flutter/widgets.dart';
import 'composable.dart';

abstract class ComposableStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var components = prepareCompose(context);
    assert(components != null, "prepareCompose must not return null");
    return ListView.builder(
        itemCount: components.length,
        itemBuilder: (context, index) {
          Composable component = components[index];
          return component;
        });
  }

  List<Composable> prepareCompose(BuildContext context) {
    return null;
  }

  void notifyComposable<C, T>(Composable<T> composable, T viewModel) {
    composable.onChanged(viewModel);
  }
}
