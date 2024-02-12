// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DartOrmGenerator
// **************************************************************************

import 'package:dart_orm_annotation/dart_orm_annotation.dart';
import 'package:postgres/postgres.dart';
import 'package:example/user.dart';

class UserInsertData {
  const UserInsertData({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  final String id;

  final String firstName;

  final String lastName;
}

class UserUpdateData {
  UserUpdateData({
    required this.id,
    this.firstName = const Optional.nil(),
    this.lastName = const Optional.nil(),
  });

  final String id;

  final Optional<String> firstName;

  final Optional<String> lastName;
}

sealed class UserWhereExpression {
  const UserWhereExpression();

  String toQuery();
}

enum UserOrderByDirection {
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

class UserOrderBy {
  const UserOrderBy({
    this.id = const Optional.nil(),
    this.firstName = const Optional.nil(),
    this.lastName = const Optional.nil(),
  });

  final Optional<UserOrderByDirection> id;

  final Optional<UserOrderByDirection> firstName;

  final Optional<UserOrderByDirection> lastName;

  String toQuery() {
    final fields = [];

    if (id.isNotNil) {
      fields.add(
        'id ${id.value}',
      );
    }

    if (firstName.isNotNil) {
      fields.add(
        'firstName ${firstName.value}',
      );
    }

    if (lastName.isNotNil) {
      fields.add(
        'lastName ${lastName.value}',
      );
    }

    return fields.join(', ');
  }
}

class UserWhereAND extends UserWhereExpression {
  const UserWhereAND(this.and);

  final List<UserWhereExpression> and;

  @override
  String toQuery() {
    return '(${and.map((a) => a.toQuery()).join(' AND ')})';
  }
}

class UserWhereNOT extends UserWhereExpression {
  const UserWhereNOT(this.not);

  final UserWhereExpression not;

  @override
  String toQuery() {
    return 'NOT ${not.toQuery()}';
  }
}

class UserWhereOR extends UserWhereExpression {
  const UserWhereOR(this.or);

  final List<UserWhereExpression> or;

  @override
  String toQuery() {
    return '(${or.map((o) => o.toQuery()).join(' OR ')})';
  }
}

class UserWhereData extends UserWhereExpression {
  const UserWhereData({
    this.id = const Optional.nil(),
    this.firstName = const Optional.nil(),
    this.lastName = const Optional.nil(),
  });

  final Optional<String> id;

  final Optional<String> firstName;

  final Optional<String> lastName;

  @override
  String toQuery() {
    final parts = <String>[];

    if (id.isNotNil) {
      parts.add('id = \'${id.value}\'');
    }

    if (firstName.isNotNil) {
      parts.add('firstName = \'${firstName.value}\'');
    }

    if (lastName.isNotNil) {
      parts.add('lastName = \'${lastName.value}\'');
    }

    return '(${parts.join(' AND ')})';
  }
}

class UserRepository {
  const UserRepository(this._connection);

  final Connection _connection;

  Future<User> insert(UserInsertData insert) async {
    final result = await _connection.execute(
      Sql.named(
        'INSERT INTO user (id, firstName, lastName) '
        'VALUES (@id, @firstName, @lastName) '
        'RETURNING *;',
      ),
      parameters: {
        'id': insert.id,
        'firstName': insert.firstName,
        'lastName': insert.lastName,
      },
    );

    if (result.isEmpty) {
      throw Exception('Failed to create User');
    }

    final entity = result.first.toColumnMap();

    return User(
      id: entity['id'] as String,
      firstName: entity['firstName'] as String,
      lastName: entity['lastName'] as String,
    );
  }

  Future<User?> get(String id) async {
    final result = await _connection.execute(
      Sql.named(
        'SELECT * FROM user WHERE id = @id;',
      ),
      parameters: {
        'id': id,
      },
    );

    if (result.isEmpty) {
      return null;
    }

    final entity = result.first.toColumnMap();

    return User(
      id: entity['id'] as String,
      firstName: entity['firstName'] as String,
      lastName: entity['lastName'] as String,
    );
  }

  Future<void> delete(String id) async {
    final result = await _connection.execute(
      Sql.named(
        'DELETE FROM user WHERE id = @id;',
      ),
      parameters: {
        'id': id,
      },
    );

    if (result.isEmpty) {
      throw Exception('Failed to delete User');
    }
  }

  Future<User?> update(UserUpdateData update) async {
    final updates = [
      update.id,
      if (update.firstName.isNotNil) ...[
        'firstName',
      ],
      if (update.lastName.isNotNil) ...[
        'lastName',
      ],
    ];

    final params = {
      '@id': update.id,
      if (update.firstName.isNotNil) ...{
        '@firstName': update.firstName.value,
      },
      if (update.lastName.isNotNil) ...{
        '@lastName': update.lastName.value,
      },
    };

    final result = await _connection.execute(
      Sql.named(
        'UPDATE user SET '
        '${updates.map((u) => '$u = @$u').join(', ')} '
        'WHERE id = @id '
        'RETURNING *;',
      ),
      parameters: params,
    );

    if (result.isEmpty) {
      throw Exception('Failed to update User');
    }

    final entity = result.first.toColumnMap();

    return User(
      id: entity['id'] as String,
      firstName: entity['firstName'] as String,
      lastName: entity['lastName'] as String,
    );
  }

  Future<List<User>> find(
    UserWhereExpression find, {
    int? limit,
    int? take,
    UserOrderBy? orderBy,
  }) async {
    final buffer = StringBuffer(
      'SELECT * FROM user WHERE ${find.toQuery()}',
    );

    if (orderBy != null) {
      buffer.write(' ORDER BY ${orderBy.toQuery()}');
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
      return const <User>[];
    }

    final entities = result.map((e) => e.toColumnMap()).toList();
    return entities.map((entity) {
      return User(
        id: entity['id'] as String,
        firstName: entity['firstName'] as String,
        lastName: entity['lastName'] as String,
      );
    }).toList();
  }
}
