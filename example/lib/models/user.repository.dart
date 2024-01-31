// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DartOrmGenerator
// **************************************************************************

import 'package:dart_orm_annotation/dart_orm_annotation.dart';
import 'package:postgres/postgres.dart';
import 'package:example/models/user.dart';

class UserInsertData {
  const UserInsertData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.salt,
  });

  final String id;

  final String firstName;

  final String lastName;

  final String email;

  final String? phone;

  final String password;

  final String salt;
}

class UserUpdateData {
  UserUpdateData({
    required this.id,
    this.firstName = const Optional.nil(),
    this.lastName = const Optional.nil(),
    this.email = const Optional.nil(),
    this.phone = const Optional.nil(),
    this.password = const Optional.nil(),
    this.salt = const Optional.nil(),
  });

  final Optional<String> id;

  final Optional<String> firstName;

  final Optional<String> lastName;

  final Optional<String> email;

  final Optional<String?> phone;

  final Optional<String> password;

  final Optional<String> salt;
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
    this.email = const Optional.nil(),
    this.phone = const Optional.nil(),
    this.password = const Optional.nil(),
    this.salt = const Optional.nil(),
  });

  final Optional<UserOrderByDirection> id;

  final Optional<UserOrderByDirection> firstName;

  final Optional<UserOrderByDirection> lastName;

  final Optional<UserOrderByDirection> email;

  final Optional<UserOrderByDirection> phone;

  final Optional<UserOrderByDirection> password;

  final Optional<UserOrderByDirection> salt;

  String toQuery() {
    final fields = [];

    if (id.isNotNil) {
      fields.add(
        'id ${id.value}',
      );
    }

    if (firstName.isNotNil) {
      fields.add(
        'first_name ${firstName.value}',
      );
    }

    if (lastName.isNotNil) {
      fields.add(
        'last_name ${lastName.value}',
      );
    }

    if (email.isNotNil) {
      fields.add(
        'email ${email.value}',
      );
    }

    if (phone.isNotNil) {
      fields.add(
        'phone ${phone.value}',
      );
    }

    if (password.isNotNil) {
      fields.add(
        'password ${password.value}',
      );
    }

    if (salt.isNotNil) {
      fields.add(
        'salt ${salt.value}',
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
    this.email = const Optional.nil(),
    this.phone = const Optional.nil(),
    this.password = const Optional.nil(),
    this.salt = const Optional.nil(),
  });

  final Optional<String> id;

  final Optional<String> firstName;

  final Optional<String> lastName;

  final Optional<String> email;

  final Optional<String?> phone;

  final Optional<String> password;

  final Optional<String> salt;

  @override
  String toQuery() {
    final parts = <String>[];

    if (id.isNotNil) {
      parts.add('id = \'${id.value}\'');
    }

    if (firstName.isNotNil) {
      parts.add('first_name = \'${firstName.value}\'');
    }

    if (lastName.isNotNil) {
      parts.add('last_name = \'${lastName.value}\'');
    }

    if (email.isNotNil) {
      parts.add('email = \'${email.value}\'');
    }

    if (phone.isNotNil) {
      if (phone.value == null) {
        parts.add('phone IS NULL');
      } else {
        parts.add('phone = \'${phone.value}\'');
      }
    }

    if (password.isNotNil) {
      parts.add('password = \'${password.value}\'');
    }

    if (salt.isNotNil) {
      parts.add('salt = \'${salt.value}\'');
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
        'INSERT INTO users (id, first_name, last_name, email, phone, password, salt) '
        'VALUES (@id, @first_name, @last_name, @email, @phone, @password, @salt) '
        'RETURNING *;',
      ),
      parameters: {
        'id': insert.id,
        'first_name': insert.firstName,
        'last_name': insert.lastName,
        'email': insert.email,
        'phone': insert.phone ?? 'NULL',
        'password': insert.password,
        'salt': insert.salt,
      },
    );

    if (result.isEmpty) {
      throw Exception('Failed to create User');
    }

    final entity = result.first.toColumnMap();

    return User(
      id: entity['id'] as String,
      firstName: entity['first_name'] as String,
      lastName: entity['last_name'] as String,
      email: entity['email'] as String,
      phone: entity['phone'] as String?,
      password: entity['password'] as String,
      salt: entity['salt'] as String,
    );
  }

  Future<User?> get(String id) async {
    final result = await _connection.execute(
      Sql.named(
        'SELECT * FROM users WHERE id = @id;',
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
      firstName: entity['first_name'] as String,
      lastName: entity['last_name'] as String,
      email: entity['email'] as String,
      phone: entity['phone'] as String?,
      password: entity['password'] as String,
      salt: entity['salt'] as String,
    );
  }

  Future<void> delete(String id) async {
    final result = await _connection.execute(
      Sql.named(
        'DELETE FROM users WHERE id = @id;',
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
      if (update.id.isNotNil) ...[
        'id',
      ],
      if (update.firstName.isNotNil) ...[
        'first_name',
      ],
      if (update.lastName.isNotNil) ...[
        'last_name',
      ],
      if (update.email.isNotNil) ...[
        'email',
      ],
      if (update.phone.isNotNil) ...[
        'phone',
      ],
      if (update.password.isNotNil) ...[
        'password',
      ],
      if (update.salt.isNotNil) ...[
        'salt',
      ],
    ];

    final params = {
      if (update.id.isNotNil) ...{
        '@id': update.id.value,
      },
      if (update.firstName.isNotNil) ...{
        '@first_name': update.firstName.value,
      },
      if (update.lastName.isNotNil) ...{
        '@last_name': update.lastName.value,
      },
      if (update.email.isNotNil) ...{
        '@email': update.email.value,
      },
      if (update.phone.isNotNil) ...{
        '@phone': update.phone.value ?? 'NULL',
      },
      if (update.password.isNotNil) ...{
        '@password': update.password.value,
      },
      if (update.salt.isNotNil) ...{
        '@salt': update.salt.value,
      },
    };

    final result = await _connection.execute(
      Sql.named(
        'UPDATE users SET '
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
      firstName: entity['first_name'] as String,
      lastName: entity['last_name'] as String,
      email: entity['email'] as String,
      phone: entity['phone'] as String?,
      password: entity['password'] as String,
      salt: entity['salt'] as String,
    );
  }

  Future<List<User>> find(
    UserWhereExpression find, {
    int? limit,
    int? take,
    String? orderBy,
  }) async {
    final buffer = StringBuffer(
      'SELECT * FROM users WHERE ${find.toQuery()}',
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
      return const <User>[];
    }

    final entities = result.map((e) => e.toColumnMap()).toList();
    return entities.map((entity) {
      return User(
        id: entity['id'] as String,
        firstName: entity['first_name'] as String,
        lastName: entity['last_name'] as String,
        email: entity['email'] as String,
        phone: entity['phone'] as String?,
        password: entity['password'] as String,
        salt: entity['salt'] as String,
      );
    }).toList();
  }
}
