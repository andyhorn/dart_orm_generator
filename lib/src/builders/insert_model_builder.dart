import 'package:code_builder/code_builder.dart';
import 'package:dart_orm_generator/src/builders/code_builder.dart';
import 'package:dart_orm_generator/src/model_visitor.dart';

class InsertModelBuilder extends CodeBuilder {
  const InsertModelBuilder({
    required this.className,
    required this.visitor,
  });

  final String className;
  final ModelVisitor visitor;

  static String generateClassName(String className) => '${className}InsertData';

  @override
  String build() {
    return emit(
      Class(
        (b) => b
          ..name = generateClassName(className)
          ..constructors.add(
            Constructor(
              (b) => b
                ..constant = true
                ..optionalParameters.addAll(
                  visitor.fields.map(
                    (field) => Parameter(
                      (b) => b
                        ..name = field.propertyName
                        ..named = true
                        ..required = true
                        ..toThis = true,
                    ),
                  ),
                ),
            ),
          )
          ..fields.addAll(
            visitor.fields.map(
              (field) => Field(
                (b) => b
                  ..name = field.propertyName
                  ..type = Reference(field.propertyType)
                  ..modifier = FieldModifier.final$,
              ),
            ),
          ),
      ),
    );
  }
}
