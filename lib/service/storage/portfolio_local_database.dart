import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xrp_monitor/ui/screen/setting/models/portfolio_model.dart';

class PortfolioLocalDatabase {
  PortfolioLocalDatabase._();

  static final PortfolioLocalDatabase instance = PortfolioLocalDatabase._();

  Database? _database;

  Future<void> init() async {
    if (_database != null) return;

    final databasePath = await getDatabasesPath();
    _database = await openDatabase(
      join(databasePath, 'xrp_monitor.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE portfolio_cache (
            id INTEGER PRIMARY KEY,
            portfolio_json TEXT NOT NULL,
            pending_request_json TEXT,
            updated_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Database get _db {
    final database = _database;
    if (database == null) {
      throw StateError('PortfolioLocalDatabase has not been initialized.');
    }
    return database;
  }

  Future<Portfolio?> getPortfolio() async {
    final rows = await _db.query(
      'portfolio_cache',
      columns: ['portfolio_json'],
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return null;

    return Portfolio.fromJson(
      jsonDecode(rows.first['portfolio_json']! as String)
          as Map<String, dynamic>,
    );
  }

  Future<PortfolioRequest?> getPendingRequest() async {
    final rows = await _db.query(
      'portfolio_cache',
      columns: ['pending_request_json'],
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty || rows.first['pending_request_json'] == null) return null;

    return PortfolioRequest.fromJson(
      jsonDecode(rows.first['pending_request_json']! as String)
          as Map<String, dynamic>,
    );
  }

  Future<DateTime?> getUpdatedAt() async {
    final rows = await _db.query(
      'portfolio_cache',
      columns: ['updated_at'],
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return DateTime.tryParse(rows.first['updated_at']! as String);
  }

  Future<void> saveSyncedPortfolio(Portfolio portfolio) async {
    await _db.insert('portfolio_cache', {
      'id': 1,
      'portfolio_json': jsonEncode(portfolio.toJson()),
      'pending_request_json': null,
      'updated_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> savePendingPortfolio({
    required Portfolio portfolio,
    required PortfolioRequest request,
  }) async {
    await _db.insert('portfolio_cache', {
      'id': 1,
      'portfolio_json': jsonEncode(portfolio.toJson()),
      'pending_request_json': jsonEncode(request.toJson()),
      'updated_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clear() async {
    await _db.delete('portfolio_cache');
  }
}
