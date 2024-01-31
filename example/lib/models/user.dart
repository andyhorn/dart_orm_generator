import 'package:dart_orm_annotation/dart_orm_annotation.dart';

@Entity()
class User {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.salt,
  });

  @PrimaryKey(type: PrimaryKeyType.uuid)
  final String id;

  @Field(
    name: 'first_name',
  )
  final String firstName;

  @Field(
    name: 'last_name',
  )
  final String lastName;

  @Field()
  final String email;

  @Field()
  final String? phone;

  @Field()
  final String password;

  @Field()
  final String salt;
}
