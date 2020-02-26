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
}

class SectionComposable extends StatelessComposable<SectionModelable> {
  SectionComposable(SectionModelable composableModel) : super(composableModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffE0E0E0),
      height: 40,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text(composableModel.title)],
        ),
      ),
    );
  }
}
