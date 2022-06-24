/// 路由
class JRoute {
  /// 路径
  final String path;

  const JRoute({required this.path});
}

/// 路由表根节点
class JRouteRoot {
  const JRouteRoot();
}

/// 路由拦截器
class JRouteInterceptor {
  /// 拦截器优先级
  final int priority;

  const JRouteInterceptor({required this.priority});
}
