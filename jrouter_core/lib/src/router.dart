import 'dart:async';
import 'dart:collection';

import 'router_interceptor.dart';
import 'router_meta.dart';

abstract class IRouteHolder {
  IRouteRoot get root;

  IInterceptorGroup get interceptor;
}

abstract class IRouteRoot {
  void loadInto(Map<String, IRouteGroup> groupMap);
}

abstract class IRouteGroup {
  void loadInto(Map<String, RouteMeta> atlas);
}

abstract class IInterceptorGroup {
  void loadInto(Map<int, IRouteFactory<JInterceptor>> interceptorMap);
}

abstract class IProviderGroup {}

abstract class IProvider {}

typedef IRouteFactory<T> = T Function(dynamic);

/// 路由结果
class JRouterResult {}

typedef WidgetRouteBuilder = dynamic Function(dynamic);

class Warehouse {
  static final Map<String, IRouteGroup> groupMap = {};

  static final Map<String, RouteMeta> routes = {};

  static final Map<String, WidgetRouteBuilder> routeMap = {};

  static final Map<RouteMeta, IProvider> providers = {};

  static final Map<int, IRouteFactory<JInterceptor>> interceptorMap =
      SplayTreeMap();

  static final List<JInterceptor> interceptors = [];

  Warehouse._internal();

  static void clear() {
    groupMap.clear();
    routes.clear();
    providers.clear();
    interceptorMap.clear();
    interceptors.clear();
  }
}

class JRouter {
  static void init(List<IRouteHolder> holders) {
    JRouteMapCenter.instance.clear();
    holders.forEach((holder) {
      JRouteMapCenter.instance.register(holder.root);
      JRouteMapCenter.instance.registerInterceptors(holder.interceptor);
    });
  }

  static void register(Map<String, IRouteFactory> routeMap) {
    routeMap.forEach((key, value) {
      JRouteMapCenter.instance.registerRoute(key, value);
    });
  }

  static void setDebuggable(bool debuggable) {
    _JRouter.instance.debuggable = debuggable;
  }

  static FutureOr<dynamic> navigation(String url,
      {dynamic context, Object? arguments, bool replace = false}) {
    return _JRouter.instance.navigation(url,
        context: context, arguments: arguments, replace: replace);
  }

  static void setHook(JRouteNavigationHook hook) {
    _JRouter.instance.hook = hook;
  }
}

typedef JRouteNavigationHook = dynamic Function(RouteOp);

class _JRouter {
  static final instance = _JRouter._internal();
  bool debuggable = false;
  JRouteNavigationHook? hook;

  _JRouter._internal();

  final interceptorService = JRouterInterceptorService();

  FutureOr<dynamic> navigation(String url,
      {dynamic context, Object? arguments, bool replace = false}) {
    final routeOp = RouteOp.fromUrl(url)
      ..context = context
      ..arguments = arguments
      ..replace = replace;

    JRouteMapCenter.instance.completion(routeOp);
    if (routeOp.type == null) {
      return null;
    }
    if (!routeOp.greenChannel) {
      interceptorService.doProcess(
          routeOp,
          InterceptorCallback(
              success: (op) {
                _navigation(op);
              },
              error: (error) {


              }));
    } else {
      return _navigation(routeOp);
    }
  }

  dynamic _navigation(RouteOp op) {
    if (hook != null) {
      return hook!.call(op);
    }
    if (op.type == RouteType.provider) {
      return op.provider;
    } else {
      return op.routerFactory?.call(null);
    }
  }
}

class JRouteMapCenter {
  static final instance = JRouteMapCenter._internal();

  JRouteMapCenter._internal();

  /// 注册路由
  void register(IRouteRoot routeRoot) {
    routeRoot.loadInto(Warehouse.groupMap);
    Warehouse.groupMap.forEach((key, group) {
      group.loadInto(Warehouse.routes);
    });

    final nameRoute = Warehouse.routes.entries
        .where((element) => element.value.type == RouteType.nameRoute)
        .map((e) => MapEntry(e.key, e.value.routerFactory));
    final mapRoute = (MapEntry<String, IRouteFactory?> map) {
      Warehouse.routeMap[map.key] = (context) => map.value!.call(context);
    };
    nameRoute.forEach(mapRoute);
  }

  /// 注册命名路由
  void registerRoute(String url, IRouteFactory routeFactory) {
    final routeOp = RouteMeta(
        type: RouteType.nameRoute,
        path: url,
        group: RouteMeta.getGroup(url),
        routerFactory: routeFactory);
    Warehouse.routes[url] = routeOp;
    Warehouse.routeMap[url] = (context) => routeFactory.call(context);
  }

  /// 注册拦截器
  void registerInterceptors(IInterceptorGroup interceptorGroup) {
    interceptorGroup.loadInto(Warehouse.interceptorMap);
  }

  /// 完成路由匹配
  void completion(RouteOp routeOp) {
    final routeMeta = Warehouse.routes[routeOp.path];
    if (null == routeMeta) {
      final routeGroup = Warehouse.groupMap[routeOp.group];
      if (routeGroup == null) {
      } else {
        routeGroup.loadInto(Warehouse.routes);
        Warehouse.groupMap.remove(routeOp.group);
        completion(routeOp);
      }
    } else {
      routeOp.type = routeMeta.type;
      switch (routeOp.type) {
        case RouteType.provider:
          routeOp.greenChannel = true;
          IProvider? provider = Warehouse.providers[routeMeta];
          if (provider == null) {
            provider = routeMeta.routerFactory?.call(null);
            if (provider != null) {
              Warehouse.providers[routeMeta] = provider;
            }
          }
          routeOp.provider = provider;
          break;
        case RouteType.nameRoute:
          break;
      }
    }
  }

  void clear() {
    Warehouse.clear();
  }
}
