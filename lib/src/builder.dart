import 'package:build/build.dart';
import 'package:dart_orm_generator/dart_orm_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder dartOrmBuilder(BuilderOptions options) => LibraryBuilder(
      DartOrmGenerator(),
      generatedExtension: '.repository.dart',
    );
