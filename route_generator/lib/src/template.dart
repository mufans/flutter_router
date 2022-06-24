const tpl = """
import 'package:jrouter_core/jrouter_core.dart';
{{#refs}}
import '{{path}}';
{{/refs}}

class JRouter\${{name}}InterceptorGroup implements IInterceptorGroup {
  @override
  void loadInto(Map<int, IRouteFactory<JInterceptor>> interceptorMap){
    {{#interceptors}}
     interceptorMap[{{priority}}] = (p)=> {{interceptor}}(); 
    {{/interceptors}}
  }
}

class JRoute\${{name}}Root implements IRouteRoot{
  @override
  void loadInto(Map<String, IRouteGroup> groupMap) {
    {{#groups}}
    groupMap['{{name}}'] = _JRouter\${{name}}Group();
    {{/groups}}
  }
}

{{#groups}}
class _JRouter\${{name}}Group implements IRouteGroup{
  @override
  void loadInto(Map<String, RouteMeta> atlas) {
    {{#routes}}
    atlas['{{path}}'] = RouteMeta(type: RouteType.{{routeType}}, path: '{{path}}', group: '{{name}}', routerFactory: (p)=>{{route}}());
    {{/routes}}
  }
}
{{/groups}}



""";

