library flutter_router_support;

import 'package:flutter/widgets.dart';
import 'package:jrouter_core/jrouter_core.dart';

/// 兼容flutter跳转
dynamic flutterRouterHook(RouteOp op) {
  if (op.type == RouteType.provider) {
    return op.provider;
  } else {
    if (op.replace) {
      return Navigator.pushReplacementNamed(op.context as BuildContext, op.path,
          arguments: op.arguments);
    } else {
      return Navigator.pushNamed(op.context as BuildContext, op.path,
          arguments: op.arguments);
    }
  }
}

/// 将路由表转成命名路由map
Map<String, WidgetBuilder> buildRouteMap() {
  return Warehouse.routeMap
      .map((key, builder) => MapEntry(key, (context) => builder(context)));
}

/// 页面路由扩展方法
extension JRouterNavigation on BuildContext {
  pushNamed(String path, {Object? argument}) {
    JRouter.navigation(path, context: this, arguments: argument);
  }

  pushReplacementNamed(String path, {Object? argument}) {
    JRouter.navigation(path, context: this, arguments: argument, replace: true);
  }
}
