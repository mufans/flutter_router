
import 'router.dart';

/// 路由元数据，包含路由的基础参数
class RouteMeta {
  /// 路由类型
  RouteType? type;

  /// 路径
  final String path;

  /// 路由分组
  final String group;

  ///  路由工厂
  IRouteFactory? routerFactory;

  RouteMeta(
      {required this.type,
      required this.path,
      required this.group,
      required this.routerFactory});

  /// url解析截取第一部分作为group
  static String getGroup(String url) {
    return url.length == 1 ? url : url.substring(1, url.indexOf('/', 1));
  }
}

/// 路由类型
enum RouteType {
  /// 命名路由
  nameRoute,

  /// 接口
  provider
}

/**
 * 路由参数，作为存储路由的处理结果和参数的容器
 */
class RouteOp extends RouteMeta {
  /// 接口
  IProvider? provider;

  /// 是否略过拦截器
  bool greenChannel = false;

  /// 上下文
  Object? context;

  /// 路由新页面是否替换当前页面
  bool replace = false;

  /// 路由参数
  Object? arguments;

  RouteOp(
      {RouteType? type = null,
      required String path,
      required String group,
      IRouteFactory? factory = null})
      : super(type: type, path: path, group: group, routerFactory: factory);

  factory RouteOp.fromUrl(String url) {
    String path = url;
    return RouteOp(path: path, group: RouteMeta.getGroup(url));
  }
}
