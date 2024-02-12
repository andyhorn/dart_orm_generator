import 'package:dart_orm_annotation/dart_orm_annotation.dart';

@Entity()
class User {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  @PrimaryKey(type: PrimaryKeyType.uuid)
  final String id;

  @Field()
  final String firstName;

  @Field()
  final String lastName;
}
