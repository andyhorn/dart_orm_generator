import 'package:code_builder/code_builder.dart';
import 'package:dart_orm_generator/src/builders/code_builder.dart';
import 'package:dart_orm_generator/src/builders/where/where.dart';
import 'package:dart_orm_generator/src/model_visitor.dart';

class WhereExpressionDataBuilder extends CodeBuilder {
  const WhereExpressionDataBuilder({
    required this.className,
    required this.visitor,
  });

  final String className;
  final ModelVisitor visitor;

  static String generateClassName(String className) => '${className}WhereData';

  @override
  String build() {
    return emit(Class((b) {
      b.name = generateClassName(className);
      b.extend = Reference(
        WhereExpressionBaseClassBuilder.generateClassName(className),
      );
      b.fields.addAll([
        for (final field in visitor.fields) ...[
          Field(
            (b) => b
              ..name = field.propertyName
              ..type = Reference('Optional<${field.propertyType}>')
              ..modifier = FieldModifier.final$,
          ),
        ],
      ]);

      b.constructors.add(
        Constructor((c) {
          c.constant = true;
          c.optionalParameters.addAll([
            for (final field in visitor.fields) ...[
              Parameter((p) {
                p
                  ..name = field.propertyName
                  ..named = true
                  ..toThis = true
                  ..defaultTo = Code('const Optional.nil()');
              }),
            ],
          ]);
        }),
      );

      b.methods.add(
        Method((m) {
          m.name = 'toQuery';
          m.returns = Reference('String');
          m.annotations.add(CodeExpression(Code('override')));
          m.body = Code('''
final parts = <String>[];

${visitor.fields.map((field) => '''
if (${field.propertyName}.isNotNil) {
  ${field.isNullable ? '''
  if (${field.propertyName}.value == null) {
    parts.add('${field.name} IS NULL');
  } else {
    parts.add('${field.name} = ${_wrapField(field)}');
  }
''' : '''
  parts.add('${field.name} = ${_wrapField(field)}');
'''}
}
''').join('\n\n')}

return '(\${parts.join(' AND ')})';
''');
        }),
      );
    }));
  }

  String _wrapField(FieldData field) {
    if (field.isString) {
      return '\\\'\${${field.propertyName}.value}\\\'';
    }

    return '\${${field.propertyName}.value}';
  }
}
