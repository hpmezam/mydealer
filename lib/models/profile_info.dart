class ProfileInfoModel {
  int? id;
  String? fName;
  String? lName;
  String? image;

  ProfileInfoModel({this.id, this.fName, this.lName, this.image});
  ProfileInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    image = json['image'];
  }
}
