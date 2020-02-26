import 'package:flutter/widgets.dart';

mixin WidgetStateListener<T extends StatefulWidget> on State<T> {
  void widgetDidAppear(BuildContext context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widgetDidAppear(context));
  }
}
