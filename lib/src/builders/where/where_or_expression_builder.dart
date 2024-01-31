import 'package:code_builder/code_builder.dart';
import 'package:dart_orm_generator/src/builders/code_builder.dart';
import 'package:dart_orm_generator/src/builders/where/where.dart';

class WhereOrExpressionBuilder extends CodeBuilder {
  const WhereOrExpressionBuilder(this.className);

  final String className;

  static String generateClassName(String className) => '${className}WhereOR';
  @override
  String build() {
    return emit(Class(
      (b) => b
        ..name = generateClassName(className)
        ..extend = Reference(
          WhereExpressionBaseClassBuilder.generateClassName(className),
        )
        ..fields.add(Field(
          (f) => f
            ..name = 'or'
            ..type = Reference(
              'List<${WhereExpressionBaseClassBuilder.generateClassName(className)}>',
            )
            ..modifier = FieldModifier.final$,
        ))
        ..constructors.add(Constructor(
          (c) => c
            ..constant = true
            ..requiredParameters.add(Parameter(
              (p) => p
                ..toThis = true
                ..name = 'or',
            )),
        ))
        ..methods.add(
          Method((m) => m
            ..name = 'toQuery'
            ..returns = Reference('String')
            ..annotations.add(CodeExpression(Code('override')))
            ..body = Code('''
return '(\${or.map((o) => o.toQuery()).join(' OR ')})';
''')),
        ),
    ));
  }
}
