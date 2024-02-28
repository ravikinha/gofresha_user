import 'dart:io';

import 'package:app/models/businessLayer/global.dart' as global;

class CurrentUser {
  int? id;
  String? user_phone;
  String? name;
  String? firstname;
  String? lastname;
  String? image;
  String? email;
  int? otp;
  String? facebook_id;
  DateTime? email_verified_at;
  String? password;
  String? device_id;
  int? wallet_credits;
  int? rewards;
  bool? phone_verified;
  String? referral_code;
  String? remember_token;
  DateTime? created_at;
  DateTime? updated_at;
  String? token;

  String? user_name;
  String? user_email;
  String? user_password;
  File? user_image;
  String? fb_id;
  int? cart_count;
  String? apple_id;
  CurrentUser();

  CurrentUser.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      user_phone = json['user_phone'] != null ? json['user_phone'] : null;
      name = json['name'] != null ? json['name'] : null;
      lastname = json['lastname'] != null ? json['lastname'] : null;
      firstname = json['firstname'] != null ? json['firstname'] : null;
      image = json['image'] != null && json['image'].toString() != 'N/A' ? json['image'] : '';
      otp = json['otp'] != null ? int.parse('${json['otp']}') : null;
      facebook_id = json['facebook_id'] != null ? json['facebook_id'] : null;
      email = json['email'] != null ? json['email'] : null;
      password = json['password'] != null ? json['password'] : null;
      email_verified_at = json['email_verified_at'] != null ? DateTime.parse(json['email_verified_at'].toString()).toLocal() : null;
      device_id = json['device_id'] != null ? json['device_id'] : null;
      wallet_credits = json['wallet_credits'] != null ? int.parse('${json['wallet_credits']}') : null;
      rewards = json['rewards'] != null ? int.parse('${json['rewards']}') : null;
      phone_verified = json['phone_verified'] != null && int.parse('${json['phone_verified']}') == 1 ? true : false;
      referral_code = json['referral_code'] != null ? json['referral_code'] : null;
      remember_token = json['remember_token'] != null ? json['remember_token'] : null;
      created_at = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
      updated_at = json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()).toLocal() : null;
      token = json['token'] != null ? json['token'] : null;
      cart_count = json['cart_count'] != null ? int.parse('${json['cart_count']}') : null;
      apple_id = json['apple_id'] != null ? json['apple_id'] : null;
    } catch (e) {
      print("Exception - userModel.dart - User.fromJson():" + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_phone': user_phone != null && user_phone!.isNotEmpty ? user_phone : null,
        'user_name': user_name != null && user_name!.isNotEmpty ? user_name : null,
        'name': name != null && name!.isNotEmpty ? name : null,
        'firstname': firstname != null && firstname!.isNotEmpty ? firstname : null,
        'lastname': lastname != null && lastname!.isNotEmpty ? lastname : null,
        'user_image': user_image != null ? user_image : null,
        'image': image != null ? image : null,
        'user_email': user_email != null && user_email!.isNotEmpty ? user_email : null,
        'email_verified_at': email_verified_at != null ? email_verified_at!.toIso8601String() : null,
        'fb_id': fb_id != null && fb_id!.isNotEmpty ? fb_id : null,
        'password': user_password != null && user_password!.isNotEmpty ? user_password : null,
        'created_at': created_at != null ? created_at!.toIso8601String() : null,
        'updated_at': updated_at != null ? updated_at!.toIso8601String() : null,
        'otp': otp != null ? otp : null,
        'device_id': device_id != null && device_id!.isNotEmpty ? global.appDeviceId : null,
        'wallet_credits': wallet_credits != null ? wallet_credits : null,
        'rewards': rewards != null ? rewards : null,
        'phone_verified': phone_verified != null && phone_verified == true ? 1 : 0,
        'referral_code': referral_code != null && referral_code!.isNotEmpty ? referral_code : null,
        'remember_token': remember_token != null && remember_token!.isNotEmpty ? remember_token : null,
        'token': token != null && token!.isNotEmpty ? token : null,
        'cart_count': cart_count != null ? cart_count : null,
        'apple_id': apple_id != null ? apple_id : null
      };
}
