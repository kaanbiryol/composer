import 'package:flutter/widgets.dart';

abstract class Composable<T> {
  T viewModel;
  Widget build(BuildContext context);
}
