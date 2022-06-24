import 'package:biz_base/biz_base.dart';
import 'package:jrouter_core/jrouter_core.dart';

@JRouteInterceptor(priority: 100)
class AppInterceptor implements JInterceptor {
  @override
  void process(RouteOp op, InterceptorHandler handler) {
    print('jrouter=======${op.path}');
    // handler.onNext(op);
    if (op.path == BaseRoute.secondPage) {
      JRouter.navigation(BaseRoute.firstPage,context: op.context);
    }else {
      handler.onNext(op);
    }
  }
}
