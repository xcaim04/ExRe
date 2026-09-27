import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/resource_model.dart';

/// Acceso a SQLite: apertura, esquema y CRUD de recursos.
///
/// Es la única capa que conoce SQL. No usa estado de la app ni red.
class ResourceLocalDataSource {
  ResourceLocalDataSource({this.databaseName = 'exre.db'});

  final String databaseName;

  Database? _db;

  /// Abre la base de datos (idempotente) y crea el esquema.
  Future<Database> get database async {
    final existing = _db;
    if (existing != null) return existing;

    final path = p.join(await getDatabasesPath(), databaseName);
    final db = await openDatabase(
      path,
      version: 1,
      onConfigure: (d) => d.execute('PRAGMA foreign_keys = ON'),
      onCreate: (d, _) async => _createSchema(d),
    );
    _db = db;
    return db;
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE ${ResourceModel.table} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        author TEXT NOT NULL,
        duration_minutes INTEGER NOT NULL,
        level TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        cover_color TEXT,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  /// Número de filas actuales. `0` dispara el sembrado inicial.
  Future<int> count() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM ${ResourceModel.table}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Inserta varios recursos en una transacción.
  Future<void> insertAll(List<ResourceModel> resources) async {
    final db = await database;
    final batch = db.batch();
    for (final r in resources) {
      batch.insert(ResourceModel.table, r.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<ResourceModel>> getAll() async {
    final db = await database;
    final rows = await db.query(
      ResourceModel.table,
      orderBy: 'title COLLATE NOCASE ASC',
    );
    return rows.map(ResourceModel.fromMap).toList();
  }

  Future<List<ResourceModel>> getFavorites() async {
    final db = await database;
    final rows = await db.query(
      ResourceModel.table,
      where: 'is_favorite = 1',
      orderBy: 'title COLLATE NOCASE ASC',
    );
    return rows.map(ResourceModel.fromMap).toList();
  }

  /// Búsqueda por texto libre sobre título, autor y descripción.
  Future<List<ResourceModel>> search(String query) async {
    final db = await database;
    final pattern = '%${_escapeLike(query)}%';
    final rows = await db.query(
      ResourceModel.table,
      where:
          "title LIKE ? ESCAPE '\\' OR author LIKE ? ESCAPE '\\' "
          "OR description LIKE ? ESCAPE '\\'",
      whereArgs: [pattern, pattern, pattern],
      orderBy: 'title COLLATE NOCASE ASC',
    );
    return rows.map(ResourceModel.fromMap).toList();
  }

  Future<List<ResourceModel>> filterByCategory(String? category) async {
    final db = await database;
    final rows = await db.query(
      ResourceModel.table,
      where: category == null ? null : 'category = ?',
      whereArgs: category == null ? null : [category],
      orderBy: 'title COLLATE NOCASE ASC',
    );
    return rows.map(ResourceModel.fromMap).toList();
  }

  /// Lee el valor actual de una columna booleana (`0`/`1`).
  Future<int> _readFlag(String id, String column) async {
    final db = await database;
    final rows = await db.query(
      ResourceModel.table,
      columns: [column],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return 0;
    return (rows.first[column] as int?) ?? 0;
  }

  Future<int> _toggleFlag(String id, String column) async {
    final current = await _readFlag(id, column);
    final next = current == 1 ? 0 : 1;
    final db = await database;
    await db.update(
      ResourceModel.table,
      {column: next},
      where: 'id = ?',
      whereArgs: [id],
    );
    return next;
  }

  /// Alterna `is_favorite` y devuelve el nuevo valor (0/1).
  Future<int> toggleFavorite(String id) => _toggleFlag(id, 'is_favorite');

  /// Alterna `is_completed` y devuelve el nuevo valor (0/1).
  Future<int> toggleCompleted(String id) => _toggleFlag(id, 'is_completed');

  /// Cierra la conexión. Usado en pruebas y al descartar la app.
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  /// Escapa los comodines de LIKE para que el usuario pueda buscar `%` o `_`.
  String _escapeLike(String input) =>
      input.replaceAll('%', r'\%').replaceAll('_', r'\_');
}
