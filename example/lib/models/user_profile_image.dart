import 'package:dart_orm_annotation/dart_orm_annotation.dart';

@Entity()
class UserProfileImage {
  const UserProfileImage({required this.id, required this.url});

  @PrimaryKey(type: PrimaryKeyType.serial)
  final int id;

  @Field()
  final String url;
}
