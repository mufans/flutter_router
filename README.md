# flutter_router

参考**Arouter** 和 **annotation_route**实现的flutter路由库，支持多模块通信。



### 功能

- 支持flutter原生页面路由
- 支持多模块通信
- 支持自定义路由拦截器





### 架构

包含三个模块

- **jrouter_core**                         路由核心库
- **router_generator**               路由apt库,用于生成一些模板代码
- **flutter_router_support**     扩展路由支持flutter







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

/// 协议路由
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
	/// 注册各个模块的路由
	JRouter.init(
      [MainRouteHolder(), BizModule1RouteHolder(), BizModule2RouteHolder()]);

	/// 添加flutter路由扩展
  JRouter.setHook(flutterRouterHook);

```



4. 注册页面路由表

```dart
	/// 注册本地路由
  JRouter.register({"/": (_) => MyHomePage(title: 'Flutter Demo Home Page')});

	MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
 
 /// flutter页面跳转
 JRouter.navigation("/biz/secondPage", context: context);
```







