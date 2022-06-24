library biz_base;

import 'package:jrouter_core/jrouter_core.dart';

class BaseRoute {
  static const String protocol = "/biz/protocol";

  static const String firstPage = "/biz/firstPage";
  static const String secondPage = "/biz/secondPage";
}

abstract class Protocol implements IProvider {
  String getName();
}
