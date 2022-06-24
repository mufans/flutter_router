import 'package:jrouter_core/jrouter_core.dart';

import 'biz_module1_route.g.dart';

@JRouteRoot()
class BizModule1RouteHolder extends IRouteHolder{
  @override
  IInterceptorGroup get interceptor => JRouter$BizModule1RouteHolderInterceptorGroup();

  @override
  IRouteRoot get root => JRoute$BizModule1RouteHolderRoot();

}