import 'package:code_builder/code_builder.dart';
import 'package:dart_orm_generator/src/builders/code_builder.dart';
import 'package:dart_orm_generator/src/model_visitor.dart';

class OrderByBuilder extends CodeBuilder {
  const OrderByBuilder({
    required this.className,
    required this.visitor,
  });

  final String className;
  final ModelVisitor visitor;

  static String generateClassName(String className) => '${className}OrderBy';
  static String generateEnumName(String className) =>
      '${className}OrderByDirection';

  @override
  String build() {
    final code = emit(
      Class((b) => b
        ..name = generateClassName(className)
        ..fields.addAll([
          for (final field in visitor.fields) ...[
            Field(
              (b) => b
                ..name = field.propertyName
                ..type = Reference('Optional<${generateEnumName(className)}>')
                ..modifier = FieldModifier.final$,
            ),
          ],
        ])
        ..constructors.add(
          Constructor(
            (c) => c
              ..constant = true
              ..optionalParameters.addAll([
                for (final field in visitor.fields) ...[
                  Parameter(
                    (p) => p
                      ..name = field.propertyName
                      ..named = true
                      ..toThis = true
                      ..defaultTo = Code('const Optional.nil()'),
                  ),
                ],
              ]),
          ),
        )
        ..methods.add(
          Method(
            (m) => m
              ..name = 'toQuery'
              ..returns = Reference('String')
              ..body = Code('''
final fields = [];

${visitor.fields.map((field) => '''
if (${field.propertyName}.isNotNil) {
  fields.add('${field.name} \${${field.propertyName}.value}',);
}
''').join('\n\n')}

return fields.join(', ');
'''),
          ),
        )),
    );

    return '''
enum ${generateEnumName(className)} {
  asc,
  desc;

  @override
  String toString() {
    return switch (this) {
      asc => 'ASC',
      desc => 'DESC',
    };
  }
}

$code
''';
  }
}
