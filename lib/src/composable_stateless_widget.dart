import 'package:flutter/widgets.dart';
import '../compose.dart';

abstract class ComposableStatelessWidget<T> extends StatelessWidget
    implements Composable<T> {
  const ComposableStatelessWidget({ComponentModel notifier, Key key});
}
