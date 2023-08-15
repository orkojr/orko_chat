import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String name;
  final String sex;
  final String password;
  final String phone;
  final String email;
  final String imgUrl;
  final DateTime date;

 

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  UserModel(this.name, this.sex, this.password, this.phone, this.email, this.imgUrl, this.date);

  /// Connect the generated [_$UserModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
