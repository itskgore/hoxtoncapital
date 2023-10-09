class EditUserAccountParams {
  String? profilePic;
  String? firstName;
  String? lastName;
  String? country;

  EditUserAccountParams(
      {this.profilePic, this.firstName, this.lastName, this.country});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profilePic'] = profilePic;
    data['firstName'] = firstName;
    data['middleName'] = "";
    data['lastName'] = lastName;
    data['country'] = country;
    return data;
  }
}
