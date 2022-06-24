import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/generator.dart';

Builder routerBuilder(BuilderOptions options) =>
    SharedPartBuilder([JRouteGenerator()], "router");

Builder interceptorBuilder(BuilderOptions options) =>
    SharedPartBuilder([InterceptorGenerator()], "interceptor");

Builder routerRootBuilder(BuilderOptions options) =>
    LibraryBuilder(JRouteRootGenerator(), generatedExtension: '.g.dart');
