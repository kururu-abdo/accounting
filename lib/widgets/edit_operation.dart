import 'package:accounting/worker_debt/DBHelperWorker.dart';
import 'package:accounting/worker_debt/models.dart/deposits_model.dart';
import 'package:flutter/material.dart';

class Editperation extends StatefulWidget {
  int operationId;
  int uid;
  Editperation({ this.operationId ,this.uid});

  @override
  _EditperationState createState() => _EditperationState();
}

class _EditperationState extends State<Editperation> {
    TextEditingController controller_name = TextEditingController();
  TextEditingController controller_mony_takeen = TextEditingController();
  TextEditingController controller2 = TextEditingController();
final formKey = new GlobalKey<FormState>();

  DBHelper dbHelper;
  String date;
@override
void initState() { 
  super.initState();
  dbHelper= new DBHelper();
  getCurrentDate();
}

 getCurrentDate() {
    var date1 = new DateTime.now().toString();

    var dateParse = DateTime.parse(date1);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}"; 
date=formattedDate;
 }
 validate()  {
   print('start validating');
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      
      print(double.parse(controller_mony_takeen.text) );
var model = Deposits( operationId:widget.operationId ,id:widget.uid ,amount:double.parse(controller_mony_takeen.text)  ,date:this.date);
        dbHelper.updateDetails(model);
        clearName();

   
  }
  
  }
clearName() {
    controller_name.text = '';
    controller_mony_takeen.text = '';
  }

AlertDialog ShowWidget(){
  AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
         'تعديل عملية سحب' ,
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
                  controller: controller_mony_takeen,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Color(0xFF0A3154),
                          width: 2,
                        ),
                      ),
                      labelText: 'ادخل المبلغ'),
                  validator: (val) => val.length == 0 ? 'المبلغ فارغ' : null,
                  onSaved: (val) {
                 //   quantity = double.parse(val);
                 //   date=currentdate;
                   // foreignkey = widget.workersDoptModel.id;
                    //remain = widget.workersDoptModel.salary;
                  },
                ),
//                - sumTake
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
                'تعديلة',
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
                       
                        clearName();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'الغاء التعديل'  'الغاء',
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
  @override
  Widget build(BuildContext context) {
    return  ShowWidget();
   
  }
}