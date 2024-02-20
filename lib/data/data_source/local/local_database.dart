import 'package:sqflite/sqflite.dart';

class LocalDataBase {
  static LocalDataBase? _instance;

  LocalDataBase._();

  static LocalDataBase get instance {
    _instance ??= LocalDataBase._();
    return _instance!;
  }

  Database? _database;
  Future<Database> init() async {
    _database = await openDatabase(
      'gemi_database.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE conversations ('
          'id TEXT PRIMARY KEY,'
          'user_id TEXT,'
          'name TEXT,'
          'last_message_date TEXT,'
          'created_at TEXT,'
          'updated_at TEXT'
          ')',
        );

        await db.execute(
          'CREATE TABLE prompts ('
          'id TEXT PRIMARY KEY,'
          'conversation_id TEXT,'
          'parent_id TEXT,'
          'role TEXT,'
          'images TEXT,'
          'text TEXT,'
          'is_good_response INTEGER,'
          'created_at TEXT,'
          'updated_at TEXT,'
          'version INTEGER'
          ')',
        );

        await db.execute(
          'CREATE TRIGGER update_last_message_date '
          'AFTER INSERT ON prompts '
          'BEGIN '
          'UPDATE conversations '
          'SET last_message_date = NEW.created_at '
          'WHERE conversations.id = NEW.conversation_id; '
          'END',
        );
      },
    );
    return _database!;
  }

  Database get database {
    if (_database == null) {
      throw Exception('Database not initialized');
    }
    return _database!;
  }
}
