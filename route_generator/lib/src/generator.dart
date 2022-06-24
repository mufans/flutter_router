import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:route_generator/src/collector.dart';
import 'package:route_generator/src/writer.dart';
import 'package:jrouter_core/jrouter_core.dart';
import 'package:source_gen/source_gen.dart';

class JRouteRootGenerator extends GeneratorForAnnotation<JRouteRoot> {
  static Collector collector = Collector();

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.displayName;
      throw InvalidGenerationSourceError(
        'Generator cannot target `$name`.',
        todo: 'Remove the [JRouter] annotation from `$name`.',
      );
    }
    collector.collectRoot(element, annotation, buildStep);
    return Writer(collector).write();
  }
}

class JRouteGenerator extends GeneratorForAnnotation<JRoute> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.displayName;
      throw InvalidGenerationSourceError(
        'Generator cannot target `$name`.',
        todo: 'Remove the [JRouter] annotation from `$name`.',
      );
    }
    JRouteRootGenerator.collector.collectRoute(element, annotation, buildStep);
    return null;
  }
}

class InterceptorGenerator extends GeneratorForAnnotation<JRouteInterceptor> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.displayName;
      throw InvalidGenerationSourceError(
        'Generator cannot target `$name`.',
        todo: 'Remove the [JRouter] annotation from `$name`.',
      );
    }
    JRouteRootGenerator.collector
        .collectInterceptor(element, annotation, buildStep);
    return null;
  }
}
