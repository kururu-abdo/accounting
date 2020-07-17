class Deposits{

int operationId;  
  
  int id;


  double amount;
String  date;

  Deposits( {this.operationId ,this.id ,this.amount ,this.date});

Deposits.fromJson(Map<String , dynamic> data){
id=data['id'];
amount = data['quantity'];
date = data['date'];
operationId =data['idtake'];

}
Map<String , dynamic> toJson()=>{'id':this.id ,'quantity':this.amount ,"date":this.date  };



}