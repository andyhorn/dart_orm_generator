import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

abstract class CodeBuilder {
  const CodeBuilder();

  String build();

  String emit(Class class$) {
    final emitter = DartEmitter();
    final formatter = DartFormatter();

    return formatter.format(class$.accept(emitter).toString());
  }
}
