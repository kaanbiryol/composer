import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

abstract class SectionModelable implements ComposableModel {
  String title;
}

class SectionComposer extends Composer<SectionComposable>
    implements SectionModelable {
  @override
  String title;

  void withTitle(String title) => this.title = title;

  @override
  SectionComposable compose() {
    var composableModel = SectionComposableModel(title: title);
    return SectionComposable(composableModel);
  }

  @override
  ThemeData themeData;
}

class SectionComposableModel implements SectionModelable {
  String title;

  SectionComposableModel({this.title});

  @override
  ThemeData themeData;

  @override
  Key key;
}

class SectionComposable extends StatelessComposable<SectionModelable> {
  SectionComposable(SectionModelable composableModel) : super(composableModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 30,
      child: Text(composableModel.title),
    );
  }
}
