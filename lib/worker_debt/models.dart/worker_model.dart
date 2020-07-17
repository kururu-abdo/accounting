class Worker{
  int id;
  String name;
  double salary;


  Worker({this.id ,this.name ,this.salary});

Worker.fromJson(Map<String , dynamic> data){
id= data['id'];  
name=data['name'];
salary = data['salary'];


}
Map<String , dynamic> toJson()=>{'name':this.name ,'salary':this.salary};



}