import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextComponent implements Composable {
  @override
  Widget build(BuildContext context) {
    return Text("KAAN");
  }

  @override
  get viewModel => null;

  @override
  void set viewModel(_viewModel) {
    // TODO: implement viewModel
  }
}

