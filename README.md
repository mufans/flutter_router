# flutter_router

参考**Arouter** 和 **annotation_route**实现的flutter路由库，聚合多模块路由表并支持多模块通信。



### 功能

- 支持flutter原生页面路由传参
- 支持多模块路由通信
- 支持自定义路由拦截器
- 支持简单的依赖注入





### 架构

包含三个模块

- **jrouter_core**                         路由核心库
- **router_generator**               路由apt库,解析dart注解生成模板代码
- **flutter_router_support**     扩展路由支持flutter。

#### 说明

三个模块依赖关系 

- runtime:
flutter_router_support->jrouter_core   
- dev:
router_generator->jrouter_core

**为什么需要flutter_router_support?**

由于dart注解解析使用了反射，并且flutter不支持反射，所以jrouter_core没有依赖flutter sdk. 为了支持flutter路由跳转,单独封装了flutter路由的转换逻辑，因此在初始化时需要配置路由扩展.







### 使用方式

1. 首先在所有需要路由的package中添加依赖

```yaml
dependencies:
  jrouter_core:
    path: ../jrouter_core

dev_dependencies:
  route_generator:
    path: ../route_generator
  build_runner: ^2.1.11
```



2. 在路由相关的类中添加对应的注解

```dart
/// 页面路由
@JRoute(path: BaseRoute.secondPage)
class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

/// 协议路由 Protocol实现了IProvider接口（参考Arouter设计，用于区分协议路由和页面路由)
@JRoute(path: BaseRoute.protocol)
class BizModule1Protocol extends Protocol {
  @override
  String getName() {
    return "biz_module1";
  }
}

/// 拦截器
@JRouteInterceptor(priority: 100)
class AppInterceptor implements JInterceptor {
  @override
  void process(RouteOp op, InterceptorHandler handler) {
    print('jrouter=======${op.path}');
    handler.onNext(op);
  }
}

```



由于dart apt 只作用于单个package，所以需要为每个package生成一个独立的路由容器来收集该package 内部的路由信息，提供给外部统一调用。

```dart
/// main 模块的路由容器
@JRouteRoot()
class MainRouteHolder extends IRouteHolder {

  @override
  IInterceptorGroup get interceptor => JRouter$MainRouteHolderInterceptorGroup();

  @override
  IRouteRoot get root => JRoute$MainRouteHolderRoot();
}

```



然后需要在每个package中执行以下指令（ **gen.sh**)

```
flutter packages pub run build_runner clean &&  flutter packages pub run build_runner build --delete-conflicting-outputs
```



执行完毕后，build_runner 会为我们自动生成.g.dart文件

```dart
class JRouter$BizModule2RouteHolderInterceptorGroup
    implements IInterceptorGroup {
  @override
  void loadInto(Map<int, IRouteFactory<JInterceptor>> interceptorMap) {}
}

class JRoute$BizModule2RouteHolderRoot implements IRouteRoot {
  @override
  void loadInto(Map<String, IRouteGroup> groupMap) {
    groupMap['biz'] = _JRouter$bizGroup();
  }
}

class _JRouter$bizGroup implements IRouteGroup {
  @override
  void loadInto(Map<String, RouteMeta> atlas) {
    atlas['/biz/secondPage'] = RouteMeta(
        type: RouteType.nameRoute,
        path: '/biz/secondPage',
        group: 'biz',
        routerFactory: (p) => SecondPage());
  }
}

```

然后需要把IInterceptorGroup 和 IRouteRoot 实现类添加到对应的 IRouteHolder中



3. 路由初始化

```dart
  /// 注册各个模块的路由表
  JRouter.init([MainRouteHolder(), BizModule1RouteHolder(), BizModule2RouteHolder()]);

  /// 添加flutter路由扩展
  JRouter.setHook(flutterRouterHook);

```



4. 注册页面路由表

```dart
   /// 初始化时可动态注册本地路由
  JRouter.register({"/": (_) => MyHomePage(title: 'Flutter Demo Home Page')});

  /// 注册命名路由
  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: buildRouteMap(), /// 添加路由表
      initialRoute: "/",
    );
```



至此所有准备工作都完成了。



5. 路由使用方式

```dart
 /// 获取协议接口
 Protocol? protocol = await JRouter.navigation(BaseRoute.protocol);
 
 /// flutter页面跳转,支持传参
 JRouter.navigation("/biz/secondPage", context: context);
```







### 参考项目

-------------

- [Arouter](https://github.com/alibaba/ARouter)  阿里路由
- [annotation_route](https://github.com/XianyuTech/annotation_route) flutter路由
