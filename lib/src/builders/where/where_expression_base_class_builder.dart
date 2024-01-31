import 'package:code_builder/code_builder.dart';
import 'package:dart_orm_generator/src/builders/code_builder.dart';
import 'package:dart_orm_generator/src/model_visitor.dart';

class WhereExpressionBaseClassBuilder extends CodeBuilder {
  const WhereExpressionBaseClassBuilder({
    required this.className,
    required this.visitor,
  });

  final String className;
  final ModelVisitor visitor;

  static String generateClassName(String className) =>
      '${className}WhereExpression';

  @override
  String build() {
    return emit(Class(
      (b) => b
        ..name = generateClassName(className)
        ..sealed = true
        ..constructors.add(Constructor((b) => b..constant = true))
        ..methods.add(
          Method(
            (m) => m
              ..name = 'toQuery'
              ..returns = Reference('String'),
          ),
        ),
    ));
  }
}
