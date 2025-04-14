import 'dart:typed_data';
import 'package:idb_shim/idb_browser.dart';

///
/// A class that provides a file-like interface to store and retrieve data using IndexedDB
/// This allows web applications to store persistent data in the browser
/// This is the core library for Indexed DB functionality
///  
///
class IdbFile {
  // Database schema version - increment when changing structure
  static const int _version = 1;
  // Name of the IndexedDB database
  static const String _dbName = 'files.db';
  // Name of the object store (similar to a table in SQL databases)
  static const String _objectStoreName = 'files';
  // Property name for the file path (used as the primary key)
  static const String _propNameFilePath = 'filePath';
  // Property name for storing the actual file contents
  static const String _propNameFileContents = 'contents';
  
  // Constructor takes a file path which acts as the unique identifier
  IdbFile(this._filePath);
  // The file path used as the key in the database
  String _filePath;
  /// Opens a connection to the IndexedDB database
  /// Creates the object store if it doesn't exist (during first run or version upgrade)
  /// Returns a Database object for further operations
  Future<Database> _openDb() async {
    final idbFactory = getIdbFactory();
    if( idbFactory == null ){
      throw Exception('getIdbFactory() failed');
    }
    return idbFactory.open(
      _dbName,
      version: _version,
      onUpgradeNeeded: (e)
        => e.database.createObjectStore(_objectStoreName, keyPath: _propNameFilePath),
    );
  }
  /// Checks if a file exists in the database
  /// Returns true if the file exists, false otherwise
  Future<bool> exists() async {
    final db = await _openDb();
    // Use read-only transaction for efficiency since we're not modifying data
    final txn = db.transaction(_objectStoreName, idbModeReadOnly);
    final store = txn.objectStore(_objectStoreName);
    final object = await store.getObject(_filePath);
    await txn.completed;
    return object != null;
  }
  
  /// Reads the file contents as binary data
  /// Returns the binary contents as Uint8List
  /// Throws an exception if the file doesn't exist
  Future<Uint8List> readAsBytes() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadOnly);
    final store = txn.objectStore(_objectStoreName);
    final object = await store.getObject(_filePath) as Map?;
    await txn.completed;
    if( object == null ){
      throw Exception('file not found: $_filePath');
    }
    return object['contents'] as Uint8List;
  }
  
  /// Reads the file contents as a string
  /// Returns the contents as a String
  /// Throws an exception if the file doesn't exist
  Future<String> readAsString() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadOnly);
    final store = txn.objectStore(_objectStoreName);
    final object = await store.getObject(_filePath) as Map?;
    await txn.completed;
    if( object == null ){
      throw Exception('file not found: $_filePath');
    }
    return object['contents'] as String;
  }
  
  /// Writes binary data to the file
  /// Creates the file if it doesn't exist, or replaces it if it does
  /// Uses read-write transaction mode since it modifies the database
  Future<void> writeAsBytes(Uint8List contents) async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadWrite);
    final store = txn.objectStore(_objectStoreName);
    await store.put({
      _propNameFilePath: _filePath,  // Fixed: replaced asterisks with underscores
      _propNameFileContents: contents
    }); // if the file exists, it will be replaced
    await txn.completed;
  }
  
  /// Writes string data to the file
  /// Creates the file if it doesn't exist, or replaces it if it does
  /// Uses read-write transaction mode since it modifies the database
  Future<void> writeAsString(String contents) async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadWrite);
    final store = txn.objectStore(_objectStoreName);
    await store.put({
      _propNameFilePath: _filePath,  // Fixed: replaced asterisks with underscores
      _propNameFileContents: contents
    }); // if the file exists, it will be replaced
    await txn.completed;
  }
  
  /// Deletes the file from the database
  /// Uses read-write transaction mode since it modifies the database
  Future<void> delete() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadWrite);
    final store = txn.objectStore(_objectStoreName);
    await store.delete(_filePath);
    await txn.completed;
  }
}