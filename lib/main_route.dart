import 'package:jrouter_core/jrouter_core.dart';

import 'main_route.g.dart';

@JRouteRoot()
class MainRouteHolder extends IRouteHolder {
  @override
  IInterceptorGroup get interceptor => JRouter$MainRouteHolderInterceptorGroup();

  @override
  IRouteRoot get root => JRoute$MainRouteHolderRoot();
}
