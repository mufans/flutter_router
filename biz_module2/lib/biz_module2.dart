library biz_module2;

import 'package:biz_base/biz_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jrouter_core/jrouter_core.dart';
import 'package:flutter_router_support/flutter_router_support.dart';

@JRoute(path: BaseRoute.secondPage)
class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String data = "empty";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("biz_module2"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data),
            TextButton(
              child: const Text("loadData"),
              onPressed: () {
                loadData();
              },
            ),
            TextButton(
              child: const Text("go to main"),
              onPressed: () {
                context.pushNamed("/");
                // JRouter.navigation("/", context: context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void loadData() async {
    Protocol? protocol = await JRouter.navigation(BaseRoute.protocol);
    String data = protocol?.getName() ?? "not found";
    setState(() {
      this.data = data;
    });
  }
}
