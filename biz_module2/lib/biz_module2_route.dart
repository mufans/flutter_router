import 'package:jrouter_core/jrouter_core.dart';

import 'biz_module2_route.g.dart';

@JRouteRoot()
class BizModule2RouteHolder extends IRouteHolder {
  @override
  IInterceptorGroup get interceptor =>
      JRouter$BizModule2RouteHolderInterceptorGroup();

  @override
  IRouteRoot get root => JRoute$BizModule2RouteHolderRoot();
}
