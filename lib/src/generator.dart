import 'package:analyzer/dart/element/element.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:build/build.dart';
import 'package:dart_orm_annotation/dart_orm_annotation.dart' as orm;
import 'package:dart_orm_generator/src/builders/code_builder.dart';
import 'package:dart_orm_generator/src/builders/insert_model_builder.dart';
import 'package:dart_orm_generator/src/builders/order_by_builder.dart';
import 'package:dart_orm_generator/src/builders/repository_builder.dart';
import 'package:dart_orm_generator/src/builders/update_model_builder.dart';
import 'package:dart_orm_generator/src/builders/where/where.dart';
import 'package:dart_orm_generator/src/model_visitor.dart';
import 'package:source_gen/source_gen.dart';

class DartOrmGenerator extends GeneratorForAnnotation<orm.Entity> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    _validateConstructor(element);
    _validatePrimaryKey(element);

    final className = element.name!;
    final classAnnotation = annotation.peek('name')?.stringValue;
    final tableName = _getTableName(className, classAnnotation);

    final visitor = ModelVisitor();
    element.visitChildren(visitor);

    final repository = RepositoryBuilder(
      className: className,
      tableName: tableName,
      visitor: visitor,
    );

    return '''
import 'package:dart_orm_annotation/dart_orm_annotation.dart';
import 'package:postgres/postgres.dart';
import '${buildStep.inputId.uri}';


${_buildWhenFieldsExist(visitor, InsertModelBuilder(
              className: className,
              visitor: visitor,
            ))}

${_buildWhenFieldsExist(visitor, UpdateModelBuilder(
              className: className,
              visitor: visitor,
            ))}

${_buildWhenFieldsExist(visitor, WhereExpressionBaseClassBuilder(
              className: className,
              visitor: visitor,
            ))}

${_buildWhenFieldsExist(visitor, OrderByBuilder(
              className: className,
              visitor: visitor,
            ))}

${_buildWhenFieldsExist(visitor, WhereAndExpressionBuilder(className))}
${_buildWhenFieldsExist(visitor, WhereNotExpressionBuilder(className))}
${_buildWhenFieldsExist(visitor, WhereOrExpressionBuilder(className))}
${_buildWhenFieldsExist(visitor, WhereExpressionDataBuilder(
              className: className,
              visitor: visitor,
            ))}

${repository.build()}
''';
  }

  String _getTableName(String className, String? classAnnotation) {
    late String tableName;
    if (classAnnotation == null) {
      tableName = StringUtils.camelCaseToLowerUnderscore(className);
    } else {
      tableName = classAnnotation;
    }

    if (!tableName.endsWith('s')) {
      tableName += 's';
    }

    return tableName;
  }

  void _validatePrimaryKey(Element element) {
    final fields = element.children.whereType<FieldElement>();
    final key = fields.where(
      (f) => TypeChecker.fromRuntime(orm.PrimaryKey).hasAnnotationOf(f),
    );

    if (key.isEmpty) {
      throw ArgumentError.value(
        element,
        'No valid primary key found for ${element.name}. '
        'Please provide a field with the @PrimaryKey annotation.',
      );
    }

    if (key.length > 1) {
      throw ArgumentError.value(
        element,
        'Multiple primary keys found for ${element.name}. '
        'Please provide only one field with the @PrimaryKey annotation.',
      );
    }
  }

  void _validateConstructor(Element element) {
    final constructors = element.children.whereType<ConstructorElement>();
    final valid = constructors.any((c) => c.parameters.every((p) => p.isNamed));

    if (!valid) {
      throw ArgumentError.value(
        element,
        'No valid constructor found for ${element.name}. '
        'Please provide a constructor with named parameters only.',
      );
    }
  }

  String _buildWhenFieldsExist(ModelVisitor visitor, CodeBuilder builder) {
    if (visitor.fields.isEmpty) {
      return '';
    }

    return builder.build();
  }
}
