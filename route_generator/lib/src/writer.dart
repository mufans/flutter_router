import 'package:route_generator/src/collector.dart';
import 'package:simple_mustache/simple_mustache.dart';

import 'template.dart';

class Writer {
  Collector collector;

  Writer(this.collector);

  String write() {
    /// 生成路由
    final List<Map<String, String>> refs = <Map<String, String>>[];
    final addRef = (String? path) {
      refs.add(<String, String>{'path': path ?? ""});
    };
    collector.path().forEach(addRef);

    /// 生成provider
    final List<Map<String, String>> providers = <Map<String, String>>[];
    final addProvider = (String path, String name) {
      providers.add(<String, String>{'url': path, 'provider': name});
    };
    collector.providers().forEach(addProvider);

    /// 生成路由分组
    final List<Map<String, dynamic>> groups = [];
    final addGroups = (String group, List<Map<String, String>> route) {
      groups.add(<String, dynamic>{'name': group, 'routes': route});
    };
    collector.groups().forEach(addGroups);

    return Mustache(map: <String, dynamic>{
      /// import
      'refs': refs,

      /// root名称
      'name': collector.rootName,

      /// 协议接口
      'providers': providers,

      /// 路由分组
      'groups': groups,

      /// 拦截器
      'interceptors': collector.interceptorList
    }).convert(tpl);
  }
}
