// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JRouteRootGenerator
// **************************************************************************

import 'package:jrouter_core/jrouter_core.dart';

import 'package:biz_module2/biz_module2.dart';

class JRouter$BizModule2RouteHolderInterceptorGroup
    implements IInterceptorGroup {
  @override
  void loadInto(Map<int, IRouteFactory<JInterceptor>> interceptorMap) {}
}

class JRoute$BizModule2RouteHolderRoot implements IRouteRoot {
  @override
  void loadInto(Map<String, IRouteGroup> groupMap) {
    groupMap['biz'] = _JRouter$bizGroup();
  }
}

class _JRouter$bizGroup implements IRouteGroup {
  @override
  void loadInto(Map<String, RouteMeta> atlas) {
    atlas['/biz/secondPage'] = RouteMeta(
        type: RouteType.nameRoute,
        path: '/biz/secondPage',
        group: 'biz',
        routerFactory: (p) => SecondPage());
  }
}
