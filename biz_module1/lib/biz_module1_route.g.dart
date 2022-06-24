// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JRouteRootGenerator
// **************************************************************************

import 'package:jrouter_core/jrouter_core.dart';

import 'package:biz_module1/biz_module1.dart';

import 'package:biz_module1/biz_module1.dart';

class JRouter$BizModule1RouteHolderInterceptorGroup
    implements IInterceptorGroup {
  @override
  void loadInto(Map<int, IRouteFactory<JInterceptor>> interceptorMap) {}
}

class JRoute$BizModule1RouteHolderRoot implements IRouteRoot {
  @override
  void loadInto(Map<String, IRouteGroup> groupMap) {
    groupMap['biz'] = _JRouter$bizGroup();
  }
}

class _JRouter$bizGroup implements IRouteGroup {
  @override
  void loadInto(Map<String, RouteMeta> atlas) {
    atlas['/biz/firstPage'] = RouteMeta(
        type: RouteType.nameRoute,
        path: '/biz/firstPage',
        group: 'biz',
        routerFactory: (p) => FirstPage());

    atlas['/biz/protocol'] = RouteMeta(
        type: RouteType.provider,
        path: '/biz/protocol',
        group: 'biz',
        routerFactory: (p) => BizModule1Protocol());
  }
}
