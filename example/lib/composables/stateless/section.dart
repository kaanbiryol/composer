import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

abstract class SectionComposable {
  String title;
}

class SectionComposer extends Composer<SectionComponent>
    implements SectionComposable {
  @override
  String title;

  void withTitle(String title) => this.title = title;

  @override
  SectionComponent compose() {
    var viewModel = SectionComponentViewModel(title: title);
    return SectionComponent(componentModel: viewModel);
  }
}

class SectionComponentViewModel {
  String title;

  SectionComponentViewModel({this.title});
}

class SectionComponent<SectionComponentViewModel>
    extends ComposableStatelessWidget {
  SectionComponent({SectionComponentViewModel componentModel, Key key})
      : super(componentModel, key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 30,
      child: Text(composableModel.title),
    );
  }
}
