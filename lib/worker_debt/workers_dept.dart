import 'package:accounting/pages/worker_list.dart';
import 'package:accounting/worker_debt/worker_dept_model.dart';
import 'package:accounting/worker_debt/workers_dopt_details.dart';

import 'DBHelperWorker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models.dart/worker_model.dart';
import 'workers_dept_model.dart';
import 'dart:async';

class WorkersDept extends StatefulWidget {
  @override
  _WorkersDeptState createState() => _WorkersDeptState();
}

class _WorkersDeptState extends State<WorkersDept> {
  //
//  Future<List<WorkersDoptModel>> workersDoptModels;
  List<WorkerDoptModel> workDepostModel;
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_salary = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  int curUserId;
  String name;
  double salary;
  int takefrom;
  int remain;


  final formKey = new GlobalKey<FormState>();
  DBHelper dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList()  async{
    List<WorkerDoptModel> list = await dbHelper.getWorkerDeposits();
    setState(() {
    //  workersDoptModels = dbHelper.getWorkersDoptModels();

      workDepostModel= list;
    });
  }

  clearName() {
    controller_name.text = '';
    controller_salary.text = '';
  }

  validate()  async{
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Worker e = Worker(
          id: curUserId,
        name:   controller_name.text,
        salary:  double.parse(controller_salary.text),
          
        );
       await dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Worker e = Worker(
          
        
        name:   controller_name.text,
        salary:  double.parse(controller_salary.text),
        );
        await dbHelper.saveWorker(e);
      }
      clearName();
    await   refreshList();
      Navigator.of(context).pop();
    }
  }

  void form() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        isUpdating ? 'تعديل راتب العامل' : 'اضافة عامل جديد',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller_name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Color(0xFF0A3154),
                            width: 2,
                          )),
                      labelText: 'العامل'),
                  validator: (val) => val.length == 0 ? 'اذخل اسم العامل' : null,
                  onSaved: (val) => name = val,
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: controller_salary,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Color(0xFF0A3154),
                              width: 2,
                            )),
                        labelText: 'ادخل راتب العامل'),
                    validator: (val) =>
                        val.length == 0 ? 'راتب العامل فارغ' : null,
                    onSaved: (val) {
                      
                    }),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Color(0xFF0A3154),
                      onPressed: validate,
                      child: Text(
                        isUpdating ? 'تعديل' : 'اضافة',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          isUpdating = false;
                        });
                        clearName();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        isUpdating ? 'الغاء التعديل' : 'الغاء',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void delete(int id) { 
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "هل تريد حذف العامل",
        style: TextStyle(
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller_name,
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          )),
                      labelText: 'العامل'),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller_salary,
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          )),
                      labelText: 'الراتب'),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Worker workersDoptModel = Worker(
                   
                        name:  name,
                        salary:  salary,
                         
                        );
                        dbHelper.delete(id);
                        Navigator.of(context).pop();
                        clearName();
                        refreshList();
                      },
                      child: Text(
                        "حذف",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Color(0xFF0A3154),
                      onPressed: () {
                        clearName();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'الغاء الحذف',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  list() {
    return Expanded(
      child: FutureBuilder<List<WorkerDoptModel>>(
        future: dbHelper.getWorkerDeposits(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
              
WorkerDoptModel model = snapshot.data[index];

// WorkerDoptModel.fromMap(snapshot.data[index]);

                  return ListTile(
                    title: GestureDetector(
                      onTap: (){
                        
                        
              Navigator.push(context, new MaterialPageRoute(builder: (context)=>WorkersDoptDetails(model))).then((value) {

refreshList();

              }); },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.only(top: 15, left: 8, right: 8,bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              textDirection: TextDirection.rtl,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.green,
                                    onPressed: () {setState(() {
                                      isUpdating = true;
                                      curUserId = model.id;
                                    });
                                    controller_name.text = model.name;
                                    controller_salary.text = model.salary.toString();
                                    form();}),
                                Expanded(
                                  child: Text(
                                    model.name?? ',,',
                                    style: TextStyle(fontSize: 18,color: Colors.white),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.redAccent,
                                    onPressed: () {
                                      setState(() {
                                        isUpdating = true;
                                        curUserId = model.id;
                                      });
                                      controller_name.text = model.name.toString();
                                      controller_salary.text = model.salary.toString();
                                      delete(model.id);
                                    }),
                              ],
                            ),
                            SizedBox(height: 5,),
                            SizedBox(
                              width: 200,
                              height: 3,
                              child: Container(
                               decoration: BoxDecoration(
                                   color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              textDirection: TextDirection.rtl,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "الراتب\n" + model.salary.toString(),
                                    style: TextStyle(fontSize: 18,color: Colors.white),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                                 Expanded(
                                   child: Text(
                                    "المتبقي له\n"+model.remain.toString()
                                       //TODO
                                       ,
                                    style: TextStyle(fontSize: 18,color: Colors.white),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                ),
                                 ),
                                Expanded(
                                  child: Text(
                                    //TODO
                                     "المسحوب\n" +model.takefrom.toString(),
                                    style: TextStyle(fontSize: 18,color: Colors.white),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }

          else if (null == snapshot.data || snapshot.data.length == 0||salary==null || !snapshot.hasData) {
            return Center(child: Text("اضغط على زر الاضافة لاضافة عمال جدد",style: TextStyle(
              color: Colors.purple.shade900,
              fontSize: 30,
            ),textDirection: TextDirection.rtl,textAlign: TextAlign.center,));
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepPurple.shade900,
        title: new Text('ديون العمال'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: IconButton(
              onPressed: () {
                form();
              },
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: new Container(
        child:
        // WorkersList()
        
        
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[list()],
        ),
      ),
    );
  }
}
