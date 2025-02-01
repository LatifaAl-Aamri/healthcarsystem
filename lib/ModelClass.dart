// class Patient{
//   String uname, password,email,phone;
//
//   Patient(this.uname,this.password,this.email,this.phone);
//   Map<String,dynamic>toJson()=>{
//     'UserName':uname,
//     'Password':password,
//     'Email':email,
//     'MobileNumber':phone,
//   }; }

class Patient {
  String uname, password, email, phone;

  Patient(this.uname, this.password, this.email, this.phone);

  Map<String, dynamic> toJson() => {
    'UserName': uname,
    'Password': password,
    'Email': email,
    'MobileNumber': phone,
  };
}
