// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JRouteRootGenerator
// **************************************************************************

import 'package:jrouter_core/jrouter_core.dart';

import 'package:flutter_router/interceptor.dart';

class JRouter$MainRouteHolderInterceptorGroup implements IInterceptorGroup {
  @override
  void loadInto(Map<int, IRouteFactory<JInterceptor>> interceptorMap) {
    interceptorMap[100] = (p) => AppInterceptor();
  }
}

class JRoute$MainRouteHolderRoot implements IRouteRoot {
  @override
  void loadInto(Map<String, IRouteGroup> groupMap) {}
}
