// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['name'] as String,
      json['sex'] as String,
      json['password'] as String,
      json['phone'] as String,
      json['email'] as String,
      json['imgUrl'] as String,
      DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'sex': instance.sex,
      'password': instance.password,
      'phone': instance.phone,
      'email': instance.email,
      'imgUrl': instance.imgUrl,
      'date': instance.date.toIso8601String(),
    };
