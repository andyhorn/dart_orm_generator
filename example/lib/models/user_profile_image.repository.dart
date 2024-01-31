// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DartOrmGenerator
// **************************************************************************

import 'package:dart_orm_annotation/dart_orm_annotation.dart';
import 'package:postgres/postgres.dart';
import 'package:example/models/user_profile_image.dart';

class UserProfileImageInsertData {
  const UserProfileImageInsertData({
    required this.id,
    required this.url,
  });

  final int id;

  final String url;
}

class UserProfileImageUpdateData {
  UserProfileImageUpdateData({
    required this.id,
    this.url = const Optional.nil(),
  });

  final Optional<int> id;

  final Optional<String> url;
}

sealed class UserProfileImageWhereExpression {
  const UserProfileImageWhereExpression();

  String toQuery();
}

enum UserProfileImageOrderByDirection {
  asc,
  desc;

  @override
  String toString() {
    return switch (this) {
      asc => 'ASC',
      desc => 'DESC',
    };
  }
}

class UserProfileImageOrderBy {
  const UserProfileImageOrderBy({
    this.id = const Optional.nil(),
    this.url = const Optional.nil(),
  });

  final Optional<UserProfileImageOrderByDirection> id;

  final Optional<UserProfileImageOrderByDirection> url;

  String toQuery() {
    final fields = [];

    if (id.isNotNil) {
      fields.add(
        'id ${id.value}',
      );
    }

    if (url.isNotNil) {
      fields.add(
        'url ${url.value}',
      );
    }

    return fields.join(', ');
  }
}

class UserProfileImageWhereAND extends UserProfileImageWhereExpression {
  const UserProfileImageWhereAND(this.and);

  final List<UserProfileImageWhereExpression> and;

  @override
  String toQuery() {
    return '(${and.map((a) => a.toQuery()).join(' AND ')})';
  }
}

class UserProfileImageWhereNOT extends UserProfileImageWhereExpression {
  const UserProfileImageWhereNOT(this.not);

  final UserProfileImageWhereExpression not;

  @override
  String toQuery() {
    return 'NOT ${not.toQuery()}';
  }
}

class UserProfileImageWhereOR extends UserProfileImageWhereExpression {
  const UserProfileImageWhereOR(this.or);

  final List<UserProfileImageWhereExpression> or;

  @override
  String toQuery() {
    return '(${or.map((o) => o.toQuery()).join(' OR ')})';
  }
}

class UserProfileImageWhereData extends UserProfileImageWhereExpression {
  const UserProfileImageWhereData({
    this.id = const Optional.nil(),
    this.url = const Optional.nil(),
  });

  final Optional<int> id;

  final Optional<String> url;

  @override
  String toQuery() {
    final parts = <String>[];

    if (id.isNotNil) {
      parts.add('id = ${id.value}');
    }

    if (url.isNotNil) {
      parts.add('url = \'${url.value}\'');
    }

    return '(${parts.join(' AND ')})';
  }
}

class UserProfileImageRepository {
  const UserProfileImageRepository(this._connection);

  final Connection _connection;

  Future<UserProfileImage> insert(UserProfileImageInsertData insert) async {
    final result = await _connection.execute(
      Sql.named(
        'INSERT INTO user_profile_images (id, url) '
        'VALUES (@id, @url) '
        'RETURNING *;',
      ),
      parameters: {
        'id': insert.id,
        'url': insert.url,
      },
    );

    if (result.isEmpty) {
      throw Exception('Failed to create UserProfileImage');
    }

    final entity = result.first.toColumnMap();

    return UserProfileImage(
      id: entity['id'] as int,
      url: entity['url'] as String,
    );
  }

  Future<UserProfileImage?> get(int id) async {
    final result = await _connection.execute(
      Sql.named(
        'SELECT * FROM user_profile_images WHERE id = @id;',
      ),
      parameters: {
        'id': id,
      },
    );

    if (result.isEmpty) {
      return null;
    }

    final entity = result.first.toColumnMap();

    return UserProfileImage(
      id: entity['id'] as int,
      url: entity['url'] as String,
    );
  }

  Future<void> delete(int id) async {
    final result = await _connection.execute(
      Sql.named(
        'DELETE FROM user_profile_images WHERE id = @id;',
      ),
      parameters: {
        'id': id,
      },
    );

    if (result.isEmpty) {
      throw Exception('Failed to delete UserProfileImage');
    }
  }

  Future<UserProfileImage?> update(UserProfileImageUpdateData update) async {
    final updates = [
      if (update.id.isNotNil) ...[
        'id',
      ],
      if (update.url.isNotNil) ...[
        'url',
      ],
    ];

    final params = {
      if (update.id.isNotNil) ...{
        '@id': update.id.value,
      },
      if (update.url.isNotNil) ...{
        '@url': update.url.value,
      },
    };

    final result = await _connection.execute(
      Sql.named(
        'UPDATE user_profile_images SET '
        '${updates.map((u) => '$u = @$u').join(', ')} '
        'WHERE id = @id '
        'RETURNING *;',
      ),
      parameters: params,
    );

    if (result.isEmpty) {
      throw Exception('Failed to update UserProfileImage');
    }

    final entity = result.first.toColumnMap();

    return UserProfileImage(
      id: entity['id'] as int,
      url: entity['url'] as String,
    );
  }

  Future<List<UserProfileImage>> find(
    UserProfileImageWhereExpression find, {
    int? limit,
    int? take,
    String? orderBy,
  }) async {
    final buffer = StringBuffer(
      'SELECT * FROM user_profile_images WHERE ${find.toQuery()}',
    );

    if (orderBy != null) {
      buffer.write(' ORDER BY $orderBy');
    }

    if (limit != null) {
      buffer.write(' LIMIT $limit');
    }

    if (take != null) {
      buffer.write(' OFFSET $take');
    }

    buffer.write(';');

    final sql = buffer.toString();
    final result = await _connection.execute(Sql(sql));

    if (result.isEmpty) {
      return const <UserProfileImage>[];
    }

    final entities = result.map((e) => e.toColumnMap()).toList();
    return entities.map((entity) {
      return UserProfileImage(
        id: entity['id'] as int,
        url: entity['url'] as String,
      );
    }).toList();
  }
}
