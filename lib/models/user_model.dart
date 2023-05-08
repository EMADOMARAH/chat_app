class USerModel{
  String? name;
  String? imageURL;
  String? email;
  String? id;
  String? password;


  USerModel(this.name, this.imageURL, this.email, this.id, this.password);
  //refactoring map|json
  USerModel.fromJson({required Map<String , dynamic> data}){
    name = data['name'];
    imageURL = data['imageURL'];
    email = data['email'];
    id = data['id'];
    password = data['password'];
  }

  Map<String, dynamic> toJson(){
    return{
      'name' : name ,
      'imageURL' : imageURL ,
      'email' : email ,
      'id' : id ,
      'password' : password ,

    };

  }








}