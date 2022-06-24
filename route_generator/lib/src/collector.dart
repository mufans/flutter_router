import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:route_generator/src/constance.dart';
import 'package:jrouter_core/jrouter_core.dart';
import 'package:source_gen/source_gen.dart';

class Collector {
  String rootName = "";
  List<Element> elements = [];
  List<String> importList = [];
  Map<String, String> providerMap = {};
  Map<String, List<Map<String, String>>> groupMap = {};
  List<String> importInterceptorList = [];
  List<Map<String, String>> interceptorList = [];

  void importClazz(String path) {
    importList.add(path);
  }

  /// 手机路由表根节点
  void collectRoot(
      ClassElement element, ConstantReader annotation, BuildStep buildStep) {
    rootName = element.name;
  }

  /// 收集拦截器
  void collectInterceptor(
      ClassElement element, ConstantReader annotation, BuildStep buildStep) {
    if (!searchSupertype(element, Constance.interceptorClass)) return;

    processImport(buildStep);

    final priority = annotation.peek(Constance.priority)?.intValue ?? 0;
    interceptorList.add({"interceptor": element.name, "priority": "$priority"});
  }

  /// 搜索父类
  bool searchSupertype(ClassElement element, String supertypeName) {
    return element.allSupertypes.any((element) => element
        .getDisplayString(withNullability: false)
        .contains(supertypeName));
  }

  /// 收集路由表
  void collectRoute(
      ClassElement element, ConstantReader annotation, BuildStep buildStep) {
    elements.add(element);
    final path = annotation.peek(Constance.path)?.stringValue;
    if (path != null) {
      final routeType = checkType(element);
      if (routeType == null) {
        return;
      }
      providerMap[path] = element.name ?? "";
      processImport(buildStep);
      final group = path.substring(1, path.indexOf('/', 1));
      final List<Map<String, String>> routes = groupMap[group] ?? [];

      routes.add({
        "path": path,
        "name": group,
        "route": element.name ?? "",
        "routeType": routeType.name
      });
      groupMap[group] = routes;
    }
  }

  void processImport(BuildStep buildStep) {
    if (buildStep.inputId.path.contains('lib/')) {
      print(buildStep.inputId.path);
      importClazz(
          "package:${buildStep.inputId.package}/${buildStep.inputId.path.replaceFirst('lib/', '')}");
    } else {
      importClazz("${buildStep.inputId.path}");
    }
  }

  Map<String, String> providers() {
    return providerMap;
  }

  Map<String, List<Map<String, String>>> groups() {
    return groupMap;
  }

  RouteType? checkType(ClassElement e) {
    if (searchSupertype(e, Constance.providerClass)) {
      return RouteType.provider;
    } else {
      return RouteType.nameRoute;
    }
  }

  List<String?> total() {
    return elements.map((e) => e.name).toList();
  }

  List<String> path() {
    return importList;
  }
}
