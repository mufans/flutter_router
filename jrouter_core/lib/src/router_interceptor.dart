
import 'router.dart';
import 'router_meta.dart';

/// 烂机器服务
abstract class InterceptorService {
  /// 处理路由节点
  void doProcess(RouteOp op, InterceptorHandler handler);
}

/// 拦截器服务
class JRouterInterceptorService implements InterceptorService {
  @override
  void doProcess(RouteOp op, InterceptorHandler handler) {
    if (Warehouse.interceptors.isEmpty) {
      Warehouse.interceptorMap.forEach((key, value) {
        Warehouse.interceptors.add(value(null));
      });
    }
    InterceptorHandlerImpl(Warehouse.interceptors).doProcess(op, handler);
  }
}

/// 成功回调
typedef OnSuccess = Function(RouteOp op);

/// 失败回调
typedef OnError = Function(RouteException exception);

class RouteException implements Exception {
  int? code;

  String? errorMessage;

  RouteException({this.code, this.errorMessage});

  @override
  String toString() {
    return "RouteException: code=$code , errorMessage=$errorMessage";
  }
}

/// 拦截器回调
class InterceptorCallback extends InterceptorHandler {
  final OnSuccess? success;
  final OnError? error;

  InterceptorCallback({this.success, this.error});

  @override
  void onComplete(RouteOp op) {
    success?.call(op);
  }

  @override
  void onError(RouteException exception) {
    error?.call(exception);
  }

  @override
  void onNext(RouteOp op) {}
}

/// 拦截器链式实现
class InterceptorHandlerImpl extends InterceptorHandler
    implements InterceptorService {
  final List<JInterceptor> interceptors;

  /// 当前拦截器索引
  int pos = 0;

  /// 拦截器是否已处理完成
  bool isFinished = false;

  
  late InterceptorHandler interceptorHandler;

  InterceptorHandlerImpl(this.interceptors);

  @override
  void onComplete(RouteOp op) {
    isFinished = true;
    interceptorHandler.onComplete(op);
  }

  @override
  void onError(RouteException exception) {
    isFinished = true;
    interceptorHandler.onError(exception);
  }

  @override
  void onNext(RouteOp op) {
    pos++;
    if (pos >= interceptors.length) {
      onComplete(op);
      return;
    }
    doProcess(op, interceptorHandler);
  }

  void doProcess(RouteOp op, InterceptorHandler handler) {
    interceptorHandler = handler;
    if (interceptors.isEmpty) {
      onComplete(op);
    } else {
      if (!isFinished) {
        interceptors[pos].process(op, this);
      }
    }
  }
}

abstract class InterceptorHandler {
  void onNext(RouteOp op);

  void onError(RouteException exception);

  void onComplete(RouteOp op);
}

abstract class JInterceptor {
  void process(RouteOp op, InterceptorHandler handler);
}
