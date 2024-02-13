import 'package:code_builder/code_builder.dart';
import 'package:dart_orm_generator/src/builders/code_builder.dart';
import 'package:dart_orm_generator/src/builders/insert_model_builder.dart';
import 'package:dart_orm_generator/src/builders/order_by_builder.dart';
import 'package:dart_orm_generator/src/builders/update_model_builder.dart';
import 'package:dart_orm_generator/src/builders/where/where.dart';
import 'package:dart_orm_generator/src/model_visitor.dart';

class RepositoryBuilder extends CodeBuilder {
  const RepositoryBuilder({
    required this.className,
    required this.tableName,
    required this.visitor,
  });

  final String className;
  final String tableName;
  final ModelVisitor visitor;

  static const _connectionType = 'Connection';
  static const _defaultEntityName = 'entity';

  static String generateClassName(String className) => '${className}Repository';

  @override
  String build() {
    final class$ = Class((builder) {
      builder.name = generateClassName(className);

      builder.constructors.add(
        Constructor(
          (builder) => builder
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = '_connection'
                ..toThis = true,
            ))
            ..constant = true,
        ),
      );

      builder.fields.add(
        Field(
          (builder) => builder
            ..name = '_connection'
            ..type = Reference('final $_connectionType'),
        ),
      );

      builder.methods.add(
        Method(
          (builder) {
            builder
              ..name = 'insert'
              ..modifier = MethodModifier.async;

            if (visitor.fields.isNotEmpty) {
              builder.requiredParameters.add(Parameter(
                (b) => b
                  ..name = 'insert'
                  ..type = Reference(
                    InsertModelBuilder.generateClassName(className),
                  ),
              ));
            }

            builder.returns = Reference('Future<$className>');

            if (visitor.fields.isNotEmpty) {
              builder.body = Code(
                _buildInsertBody(_defaultEntityName),
              );
            } else {
              builder.body = Code('return $className();');
            }
          },
        ),
      );

      final primaryKey = visitor.primaryKey;
      if (primaryKey != null) {
        final primaryKeyType = primaryKey.propertyType;

        builder.methods.add(
          Method(
            (b) => b
              ..name = 'get'
              ..returns = Reference(
                'Future<$className?>',
              )
              ..modifier = MethodModifier.async
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = primaryKey.propertyName
                    ..type = Reference(primaryKeyType),
                ),
              )
              ..body = Code(
                _buildGetBody(primaryKey.propertyName, _defaultEntityName),
              ),
          ),
        );

        builder.methods.add(
          Method(
            (b) => b
              ..name = 'delete'
              ..returns = Reference('Future<void>')
              ..modifier = MethodModifier.async
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = primaryKey.propertyName
                    ..type = Reference(primaryKeyType),
                ),
              )
              ..body = Code(
                _buildDeleteBody(primaryKey.propertyName),
              ),
          ),
        );

        builder.methods.add(
          Method(
            (b) => b
              ..name = 'update'
              ..returns = Reference('Future<$className?>')
              ..modifier = MethodModifier.async
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = 'update'
                    ..type = Reference(
                      UpdateModelBuilder.generateClassName(className),
                    ),
                ),
              )
              ..body = Code(
                _buildUpdateBody(primaryKey.propertyName, _defaultEntityName),
              ),
          ),
        );

        builder.methods.add(
          Method(
            (b) {
              b.name = 'find';
              b.requiredParameters.add(
                Parameter((b) {
                  b.name = 'find';
                  b.type = Reference(
                    WhereExpressionBaseClassBuilder.generateClassName(
                      className,
                    ),
                  );
                }),
              );
              b.optionalParameters.add(Parameter((b) {
                b.name = 'limit';
                b.named = true;
                b.type = Reference('int?');
              }));
              b.optionalParameters.add(Parameter((b) {
                b.name = 'take';
                b.named = true;
                b.type = Reference('int?');
              }));
              b.optionalParameters.add(Parameter((b) {
                b.name = 'orderBy';
                b.named = true;
                b.type = Reference(
                  '${OrderByBuilder.generateClassName(className)}?',
                );
              }));
              b.modifier = MethodModifier.async;
              b.returns = Reference('Future<List<$className>>');
              b.body = Code(_buildFindBody(_defaultEntityName));
            },
          ),
        );
      }
    });

    return emit(class$);
  }

  String _buildCtorParameters(String entityName) {
    return visitor.fields.map((f) {
      final propertyName = f.propertyName;
      final entityProperty = f.name;
      final type = f.propertyType;

      return '$propertyName: $entityName[\'$entityProperty\'] as $type,';
    }).join('\n');
  }

  String _buildInsertParameters() {
    // get all fields that are not primary keys, unless the primary key is NOT
    // auto-generated by the database
    final fields = visitor.fields.where(
      (f) => (f.isPrimaryKey && !f.isAutoGenerated) || !f.isPrimaryKey,
    );

    final buffer = StringBuffer();

    for (final field in fields) {
      if (field.isNullable) {
        buffer.writeln(
          '\'${field.name}\': insert.${field.propertyName} ?? \'NULL\',',
        );
      } else {
        buffer.writeln(
          '\'${field.name}\': insert.${field.propertyName},',
        );
      }
    }

    return buffer.toString();
  }

  String _buildUpdateBody(String primaryKey, String entityName) {
    final updateBuffer = StringBuffer();
    final paramBuffer = StringBuffer();

    updateBuffer.writeln('''
update.$primaryKey,
''');

    paramBuffer.writeln('''
'@$primaryKey': update.$primaryKey,
''');

    for (final field in visitor.fields.where((f) => !f.isPrimaryKey)) {
      updateBuffer.writeln('''
if (update.${field.propertyName}.isNotNil) ...[
  '${field.name}',
],
''');

      paramBuffer.writeln('''
if (update.${field.propertyName}.isNotNil) ...{
  '${field.parameterKey}': ${field.isNullable ? 'update.${field.propertyName}.value ?? \'NULL\'' : 'update.${field.propertyName}.value'},
},
''');
    }

    return '''
final updates = [
  $updateBuffer
];

final params = {
  $paramBuffer
};

final result = await _connection.execute(
  Sql.named(
    'UPDATE $tableName SET '
    '\${updates.map((u) => '\$u = @\$u').join(', ')} '
    'WHERE $primaryKey = @$primaryKey '
    'RETURNING *;',
  ),
  parameters: params,
);

if (result.isEmpty) {
  throw Exception('Failed to update $className');
}

final $entityName = result.first.toColumnMap();

return $className(
  ${_buildCtorParameters(entityName)}
);
''';
  }

  String _buildDeleteBody(String primaryKey) {
    return '''
final result = await _connection.execute(
  Sql.named(
    'DELETE FROM $tableName WHERE $primaryKey = @$primaryKey;',
  ),
  parameters: {
    '$primaryKey': $primaryKey,
  },
);

if (result.isEmpty) {
  throw Exception('Failed to delete $className');
}
''';
  }

  String _buildGetBody(String primaryKey, String entityName) {
    return '''
final result = await _connection.execute(
  Sql.named(
    'SELECT * FROM $tableName WHERE $primaryKey = @$primaryKey;',
  ),
  parameters: {
    '$primaryKey': $primaryKey,
  },
);

if (result.isEmpty) {
  return null;
}

final $entityName = result.first.toColumnMap();

return $className(
  ${_buildCtorParameters(entityName)}
);
''';
  }

  String _buildInsertBody(String entityName) {
    final fields = visitor.fields.where((f) => !f.isPrimaryKey);
    return '''
final result = await _connection.execute(
  Sql.named(
    'INSERT INTO $tableName (${fields.map((f) => f.name).join(', ')}) '
    'VALUES (${fields.map((f) => f.parameterKey).join(', ')}) '
    'RETURNING *;',
  ),
  parameters: {
    ${_buildInsertParameters()}
  },
);

if (result.isEmpty) {
  throw Exception('Failed to create $className');
}

final $entityName = result.first.toColumnMap();

return $className(
  ${_buildCtorParameters(entityName)}
);
      ''';
  }

  String _buildFindBody(String entityName) {
    return '''
final buffer = StringBuffer('SELECT * FROM $tableName WHERE \${find.toQuery()}',);

if (orderBy != null) {
  buffer.write(' ORDER BY \${orderBy.toQuery()}');
}

if (limit != null) {
  buffer.write(' LIMIT \$limit');
}

if (take != null) {
  buffer.write(' OFFSET \$take');
}

buffer.write(';');

final sql = buffer.toString();
final result = await _connection.execute(Sql(sql));

if (result.isEmpty) {
  return const <$className>[];
}

final entities = result.map((e) => e.toColumnMap()).toList();
return entities.map(($entityName) {
  return $className(
    ${_buildCtorParameters(entityName)}
  );
}).toList();
''';
  }
}
