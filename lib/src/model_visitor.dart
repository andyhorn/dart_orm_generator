import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:source_gen/source_gen.dart';
import 'package:dart_orm_annotation/dart_orm_annotation.dart' as orm;

class FieldData {
  const FieldData({
    required this.propertyName,
    required this.propertyType,
    this.columnName,
    this.isPrimaryKey = false,
  });

  final String propertyName;
  final String propertyType;
  final String? columnName;
  final bool isPrimaryKey;

  String get parameterKey => '@$name';
  String get name => columnName ?? propertyName;
  bool get isNullable => propertyType.endsWith('?');
  bool get isString => propertyType.startsWith('String');
}

class ModelVisitor extends SimpleElementVisitor {
  final List<FieldData> fields = [];

  List<String> get fieldParameters =>
      fields.map((f) => f.parameterKey).toList();

  FieldData? get primaryKey => fields.any((f) => f.isPrimaryKey)
      ? fields.firstWhere((f) => f.isPrimaryKey)
      : null;

  @override
  void visitFieldElement(FieldElement element) {
    final fieldAnnotation = _getFieldAnnotation(element);

    if (fieldAnnotation == null) {
      return;
    }

    if (primaryKey != null) {
      fields.add(FieldData(
        propertyName: element.name,
        propertyType: element.type.toString(),
        columnName: _getColumnName(fieldAnnotation),
      ));

      return;
    }

    final primaryKeyAnnotation = _getPrimaryKeyAnnotation(element);

    if (primaryKeyAnnotation == null) {
      return;
    }

    fields.add(FieldData(
      propertyName: element.name,
      propertyType: _getPrimaryKeyType(primaryKeyAnnotation),
      columnName: _getColumnName(primaryKeyAnnotation),
      isPrimaryKey: true,
    ));
  }

  DartObject? _getFieldAnnotation(FieldElement element) {
    return TypeChecker.fromRuntime(orm.Field)
        .firstAnnotationOf(element, throwOnUnresolved: false);
  }

  DartObject? _getPrimaryKeyAnnotation(FieldElement element) {
    return TypeChecker.fromRuntime(orm.PrimaryKey)
        .firstAnnotationOf(element, throwOnUnresolved: false);
  }

  String _getPrimaryKeyType(DartObject annotation) {
    final type = annotation.getField('type');
    final index = type?.getField('index')?.toIntValue();

    if (index == null) {
      throw ArgumentError.notNull('PrimaryKeyType');
    }

    final primaryKeyType = orm.PrimaryKeyType.values[index];

    return switch (primaryKeyType) {
      orm.PrimaryKeyType.serial => '$int',
      orm.PrimaryKeyType.uuid => '$String',
    };
  }

  String? _getColumnName(DartObject annotation) {
    return annotation.getField('name')?.toStringValue();
  }
}
