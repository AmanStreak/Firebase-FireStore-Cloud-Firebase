class mappi{
  String email;
  String userid;

  mappi(this.email, this.userid);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map["Email"] = this.email;
    map["userid"] = this.userid;
    return map;
  }
}