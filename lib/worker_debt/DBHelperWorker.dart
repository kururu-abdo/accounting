import 'dart:async';

import 'dart:io' as io;
import 'package:accounting/worker_debt/models.dart/deposits_model.dart';
import 'package:accounting/worker_debt/models.dart/worker_model.dart';
import 'package:accounting/worker_debt/take_model.dart';
import 'package:accounting/worker_debt/worker_dept_model.dart';

import 'workers_dept_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String SALARY = 'salary';
  static const String TAKEFROM = 'takefrom';
  static const String REMAIN = 'remain';
  static const String TABLE = 'worker';

  static const String ID1 = 'idtake';
  static const String QUANTITY = 'quantity';
  static const String DATE = 'date';
  static const String FOREIGNKEY = 'foreignkey';
  static const String TABLE1 = 'depts';

  static const String DB_NAME = 'workersDoptModel1.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 3, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $TABLE (
            $ID INTEGER PRIMARY KEY AUTOINCREMENT,
             $NAME TEXT,
             $SALARY REAL DEFAULT 0
            
             )
             ''');
    await db.execute('''
        CREATE TABLE $TABLE1 (
            $ID1 INTEGER PRIMARY KEY AUTOINCREMENT,

            $QUANTITY REAL DEFAULT 0,
            $DATE text,
            $ID integer ,
            FOREIGN KEY ($ID) REFERENCES $TABLE($ID)
            )
            '''
    );
//    await db.execute('''
//        ALTER TABLE $TABLE1 add constrain FOREIGN KEY ($FOREIGNKEY) REFERENCES $TABLE($ID)
//            '''
//    );
  }
//  FOREIGN KEY ($FOREIGNKEY) REFERENCES $TABLE($ID)
  Future<WorkersDoptModel> save(WorkersDoptModel workersDoptModel) async {
    var dbClient = await db;
    workersDoptModel.id =
        await dbClient.insert(TABLE, workersDoptModel.toMap());
    return workersDoptModel;
  }



  Future<Worker> saveWorker(Worker worker) async {
    var dbClient = await db;
   
     worker.id=   await dbClient.insert(TABLE, worker.toJson());
print(worker.id);
     print('we are save  ${worker.name}');
await getWorkers();
    return worker;
  }

  Future<List<Worker>> getWorkers() async {
    var dbClient = await db;
     List<Worker> workers=[];
    List<Map> map =   await dbClient.query(DBHelper.TABLE  ,columns:[ID ,NAME ,SALARY]);

   
print(map.length);
    //workers.forEach((element) {print(element.name);});
    if(map.length>0){
       for (var i = 0; i < map.length; i++) {
       print('///////////////////////////////////////////////////////////////');
       print(map[i]);
workers.add(Worker.fromJson(map[i]));
      //return [];
     }
//return workers;
    }
     return workers;
  }



  Future<TakeModel> saveDetails(TakeModel takeModel) async {
    var dbClient = await db;
    takeModel.idtake = await dbClient.insert(TABLE1, takeModel.toMap());
    return takeModel;
  }



  Future<Deposits> workerDeposit(Deposits depts) async {
    var dbClient = await db;
      await dbClient.insert(TABLE1, depts.toJson());
    return depts;
  }





  Future<List<WorkersDoptModel>> getWorkersDoptModels() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query(TABLE, columns: [ID, NAME, SALARY, TAKEFROM,REMAIN]);
  //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");




    List<WorkersDoptModel> workersDoptModels = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        workersDoptModels.add(WorkersDoptModel.fromMap(maps[i]));
      }
    }
    return workersDoptModels;
  }


  Future<List<WorkerDoptModel>> getWorkerDeposits() async {
    var dbClient = await db;
     List<WorkerDoptModel> workersDoptModels = [];
 List<Map> results = await dbClient.rawQuery("SELECT worker.id AS id   , worker.name  As name, worker.salary as salary ,ifnull(sum(depts.quantity) ,0.0) as totaldeposits ,(worker.salary - ifnull(sum(depts.quantity) ,0.0))  as remain from worker left   join depts using($ID)  group by ($ID)  ");




  
    if (results.length > 0) {
      for (int i = 0; i < results.length; i++) {
        
       
        workersDoptModels.add(WorkerDoptModel.fromMap(results[i]));
      }
     
     
    }
 
      
    return workersDoptModels;

  }


Future<WorkerDoptModel> getWorkerDeposit(int id) async {
    var dbClient = await db;
     WorkerDoptModel workersDoptModels;
var results = await dbClient.rawQuery("SELECT worker.id AS id   , worker.name  As name, worker.salary as salary ,ifnull(sum(depts.quantity) ,0.0) as totaldeposits ,(worker.salary - ifnull(sum(depts.quantity) ,0.0))  as remain from worker left   join depts using($ID)  where worker.id = $id  ");




  
    if (results.length > 0) {
      for (int i = 0; i < results.length; i++) {
        
       
        workersDoptModels=WorkerDoptModel.fromMap(results[i]);
      }
     
     
    }
 
      
    return workersDoptModels;

  }




  Future<List<TakeModel>> getWorkerDetails() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE1, columns: [ID1,QUANTITY, DATE, FOREIGNKEY ]);
    List<TakeModel> takeModels = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        takeModels.add(TakeModel.fromMap(maps[i]));
      }
    }
    return takeModels;
  }
  Future<List<Deposits>> getWorkerDeptsDetails(int workerId) async {
    var dbClient = await db;
    // List<Map> maps = await dbClient
    //     .query(TABLE1, columns: [ID1,QUANTITY, DATE, FOREIGNKEY ]);
 List<Map> results = await dbClient.rawQuery("select $ID  as id  , $ID1 as idtake , $QUANTITY as quantity , $DATE as date from depts where $ID =$workerId");
   

    List<Deposits> worker=[];
    for (var i = 0; i < results.length; i++) {
       
   worker.add(Deposits.fromJson(results[i]));
    }
  
    return worker;
  }




  //  List<Map> results = await dbClient.rawQuery("SELECT woker.id as id   , worker.name  as name, worker.salary as salary ,sum(depts.quantity) as totaldeposits ,(worker.salary-sum(depts.quantity)) as remain from worker join depts using($ID)");

  Future<List> allWorkers() async {
    var dbClient = await db;
    return await dbClient.query(TABLE);
  }

  Future<List> allDetails() async {
    var dbClient = await db;
    return await dbClient.query(TABLE1);
  }

  Future<int> delete(int  id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> deleteDetail(int id) async {
    var dbClient = await db;
   //return  await dbClient.rawQuery('delete from $TABLE1 where $ID=$id');
    print('deleting  $id');
    return await dbClient.delete(TABLE1, where: '$ID1 = ?', whereArgs: [id]);
  }

  Future<int> update(Worker workersDoptModel) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, workersDoptModel.toJson(),
        where: '$ID = ?', whereArgs: [workersDoptModel.id]);
  }
  Future<int> sumTake() async {
    var dbClient = await db;
    List<Map> result =
    await dbClient.rawQuery("SELECT SUM($QUANTITY) as total FROM $TABLE1");
    return result[0]['total'];
  }

  Future<int> foreignColumn() async {
    var dbClient = await db;
    List<Map> result =
    await dbClient.rawQuery("SELECT $TABLE.column as x"
        " $TABLE.column from $TABLE"
        " join table2 when "
        "($TABLE.foreign_column==$TABLE.$FOREIGNKEY)");
    return result[0]['x'];
  }
  Future<int> updateDetails(Deposits takeModel) async {
    var dbClient = await db;


print(takeModel.operationId);
   // return await dbClient.rawUpdate('update depts set quantity=${takeModel.amount}  where idtake=${takeModel.operationId}');

var row ={
  QUANTITY:takeModel.amount ,
  DATE:  takeModel.date
};
    return await dbClient.update(TABLE1, row, where: '$ID1 = ?', whereArgs: [takeModel.operationId]);
  }

    

  Future<bool> canWithdraw(int id) async{
 var dbClient = await db;
 bool result;
 /*

[
  {
    salary:2333
  }
]
 */
  var  result1= await dbClient.rawQuery('select salary from worker where id=$id');
   var  result2= await dbClient.rawQuery('select worker.salary as salary , (worker.salary - ifnull(sum(depts.quantity) ,0.0))  as remain from worker  left  join depts  where depts.id=$id');

print(result1[0]['salary']<=result2[0]['remain']);

return result1[0]['salary']>=(result2[0]['remain']??0.0);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
