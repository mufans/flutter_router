library biz_module1;

import 'package:biz_base/biz_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jrouter_core/jrouter_core.dart';

@JRoute(path: BaseRoute.firstPage)
class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("biz_module1"),
      ),
      body: Center(
        child: Text("FirstPage"),
      ),
    );
  }
}

@JRoute(path: BaseRoute.protocol)
class BizModule1Protocol extends Protocol {
  @override
  String getName() {
    return "biz_module1";
  }
}
