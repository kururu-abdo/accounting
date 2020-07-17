
import 'package:accounting/worker_debt/DBHelperWorker.dart';
import 'package:accounting/worker_debt/models.dart/worker_model.dart';
import 'package:accounting/worker_debt/worker_dept_model.dart';
import 'package:flutter/material.dart';

class WorkersList extends StatefulWidget {
 

  @override
  _WorkersListState createState() => _WorkersListState();
}

class _WorkersListState extends State<WorkersList> {
  var db = DBHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db.getWorkerDeposits();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: FutureBuilder<List<WorkerDoptModel>>(
         future: db.getWorkerDeposits(),
        
         builder: (BuildContext context, AsyncSnapshot<List<WorkerDoptModel>> snapshot) {
           if (snapshot.hasData) {


             return ListView.builder(
               itemCount: snapshot.data.length,
               itemBuilder: (BuildContext context, int index) {
                 var model = snapshot.data[index];
               return     Text(model.name??'mm');
              },
             );
             
           }


           return CircularProgressIndicator();
         },
       ),
    );
  }
}