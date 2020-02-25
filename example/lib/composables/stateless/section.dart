import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

abstract class SectionModelable implements StatelessComposableModel {
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
}

class SectionComposableModel implements SectionModelable {
  String title;

  SectionComposableModel({this.title});

  @override
  Key key;

  @override
  List<Validator> validators;
}

class SectionComposable extends StatelessComposable<SectionModelable> {
  SectionComposable(SectionModelable composableModel) : super(composableModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[Text(composableModel.title)],
      ),
    );
  }
}
