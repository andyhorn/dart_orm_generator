import 'package:code_builder/code_builder.dart';
import 'package:dart_orm_generator/src/builders/code_builder.dart';
import 'package:dart_orm_generator/src/model_visitor.dart';

class UpdateModelBuilder extends CodeBuilder {
  const UpdateModelBuilder({
    required this.className,
    required this.visitor,
  });

  final String className;
  final ModelVisitor visitor;

  static String generateClassName(String className) => '${className}UpdateData';

  @override
  String build() {
    return emit(
      Class((builder) {
        builder.name = '${className}UpdateData';

        builder.fields.addAll([
          for (final field in visitor.fields) ...[
            Field((b) {
              b
                ..name = field.propertyName
                ..type = Reference('Optional<${field.propertyType}>')
                ..modifier = FieldModifier.final$;
            }),
          ],
        ]);

        builder.constructors.add(
          Constructor((c) {
            c.optionalParameters.addAll([
              for (final field in visitor.fields) ...[
                Parameter((p) {
                  p
                    ..name = field.propertyName
                    ..named = true
                    ..toThis = true
                    ..required = field.isPrimaryKey
                    ..defaultTo = field.isPrimaryKey
                        ? null
                        : Code('const Optional.nil()');
                }),
              ],
            ]);
          }),
        );
      }),
    );
  }
}
