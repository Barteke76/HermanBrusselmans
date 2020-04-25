import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:herman_brusselmans/services/boek.dart';

// database table and column names
final String tableBoeks = 'boeks';
final String columnId = '_id';
final String columnTitel = 'titel';
final String columnInhoud = 'inhoud';
final String columnJaar = 'jaar';
final String columnBezit = 'bezit';
final String columnEBoek = 'Eboek';
final String columnBoek = 'boek';
final String columnFoto = 'foto';
final String columnUrl = 'url';
final String columnBiografie = 'biografie';

// singleton class to manage the database
class DatabaseHelper {
  static final _databaseName = "boeken_Database.db";
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), _databaseName),
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableBoeks (
                $columnId INTEGER PRIMARY KEY,
                $columnTitel TEXT NOT NULL,
                $columnInhoud TEXT NOT NULL,
                $columnJaar TEXT NOT NULL,
                $columnBezit INTEGER NOT NULL,
                $columnEBoek INTEGER NOT NULL,
                $columnBoek INTEGER NOT NULL,
                $columnFoto TEXT NOT NULL,
                $columnUrl TEXT NOT NULL,
                $columnBiografie TEXT NOT NULL 
              )
              ''');
  }

  //database helpers
  Future<Boek> getBoek(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(
      tableBoeks,
      columns: [
        columnId,
        columnTitel,
        columnInhoud,
        columnJaar,
        columnBezit,
        columnEBoek,
        columnBoek,
        columnFoto,
        columnUrl,
        columnBiografie,
      ],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return Boek.fromDb(maps.first);
    }
    return null;
  }

  //alle boeken opvragen in de database
  Future<List<Boek>> queryAllBoeks() async {
    Database db = await database;
    var res = await db.query(tableBoeks);
    List<Boek> list = res.map((b) => Boek.fromDb(b)).toList();
    return list;
  }

  //een boek toevoegen aan database
  Future<int> insertBoek(Boek boek) async {
    Database db = await database;
    int id = await db.insert(tableBoeks, boek.toMapForDb());
    return id;
  }

  //verandere van eboek en bezit, true or false
  Future<void> updateEboek(int id) async {
    final db = await database;
    Boek newBoek = await getBoek(id);
    if (newBoek.eBoek == true) {
      newBoek.eBoek == false;
      if (newBoek.boek == false) {
        newBoek.bezit = false;
      }
    } else {
      newBoek.eBoek = true;
      newBoek.bezit = true;
    }
    await db.update(tableBoeks, newBoek.toMapForDb(),
        where: "$columnId = ?", whereArgs: [newBoek.id]);
  }

  //verandere van boek en bezit, true or false
  Future<void> updateBoek(int id) async {
    final db = await database;
    Boek newBoek = await getBoek(id);
    if (newBoek.boek == true) {
      newBoek.boek == false;
      if (newBoek.eBoek == false) {
        newBoek.bezit = false;
      }
    } else {
      newBoek.boek = true;
      newBoek.bezit = true;
    }
    await db.update(tableBoeks, newBoek.toMapForDb(),
        where: "$columnId = ?", whereArgs: [newBoek.id]);
  }
}
