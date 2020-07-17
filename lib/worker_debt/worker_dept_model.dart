import 'dart:convert';

class WorkerDoptModel {
  //attributes = fields in table
  int id;
  String name;
  double salary;
  double takefrom;
  double  remain;
  List<Operations> operations;
  WorkerDoptModel(
      this.id,
      this.name,
      this.salary,
      this.takefrom,
      this.remain ,
      this.operations);
  WorkerDoptModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    salary =    map['salary'];
    takefrom = map['totaldeposits'];
    remain = map['remain'];
    

     if (map['operations'] != null) {
      operations = new List<Operations>();
      map['operations'].forEach((v) {
        operations.add(new Operations.fromJson(v));
      });
    }


    print(takefrom.runtimeType);
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'salary': salary,
      'totaldeposits': takefrom,
      'remain': remain,
      "operations":operations?? null
    };
    return map;
  }
}
class Operations {
  String date;
  String amount;

  Operations({this.date, this.amount});

  Operations.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['amount'] = this.amount;
    return data;
  }
}