// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);
  final String url;

  Future getData({required Map<String, String> body}) async {
    var rawData;
    try {
      http.Response response = await http.get(Uri.parse(url), headers: body);
      rawData = response.body;
      var data = jsonDecode(response.body);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future getwithHeader({required Map<String, String> header}) async {
    var rawData;
    try {
      http.Response response = await http.get(Uri.parse(url), headers: header);
      rawData = response.body;
      var data = jsonDecode(response.body);

      return data;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future getCarData({required Map<String, String> body}) async {
    var rawData;
    try {
      http.Response response = await http.get(Uri.parse(url), headers: body);
      rawData = response.body;
      var data = jsonDecode(response.body);
      return data;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future getProfileData({required Map<String, String> body}) async {
    var rawData;
    try {
      http.Response response = await http.get(Uri.parse(url), headers: body);
      rawData = response.body;
      var data = jsonDecode(response.body);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future getProfileDatas({required Map<String, String> body}) async {
    var rawData;
    try {
      http.Response response = await http.get(Uri.parse(url), headers: body);
      rawData = response.body;
      var data = jsonDecode(response.body);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future updateProfileData({required Map<String, String> head, body}) async {
    var rawData;
    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: head, body: body);
      rawData = response.body;
      var data = jsonDecode(response.body);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future putData({required Map<String, String> head, body}) async {
    var rawData;
    try {
      http.Response response =
          await http.put(Uri.parse(url), headers: head, body: body);
      rawData = response.body;
      var data = jsonDecode(response.body);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future putBodyData({required Map<String, String> head}) async {
    var rawData;
    try {
      http.Response response = await http.put(Uri.parse(url), headers: head);
      rawData = response.body;
      var data = jsonDecode(response.body);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future putBodyWithData(
      {required Map<String, String> head, var bodyData}) async {
    http.Response response =
        await http.put(Uri.parse(url), headers: head, body: bodyData);
    var data = jsonDecode(response.body);
    var formattedData = data;
    formattedData["status"] = true;
    return formattedData;
  }

  Future postData({required Map<String, String> body}) async {
    var rawData;
    try {
      http.Response response = await http.post(Uri.parse(url), body: body);
      rawData = response.body;
      var data = jsonDecode(response.body);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future postHeaderData({required Map<String, String> headers}) async {
    var rawData;
    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: headers);
      rawData = response.body;
      var data = jsonDecode(response.body);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future postHeaderBodyData(headers, body) async {
    var rawData;
    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      rawData = response.body;
      print('---');
      print(rawData);
      print('---');
      var data = jsonDecode(response.body);
      return data;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future counterDeleteData({required Map<String, String> headers, body}) async {
    var rawData;
    try {
      http.Response response =
          await http.delete(Uri.parse(url), headers: headers, body: body);
      rawData = response.body;
      var data = jsonDecode(response.body);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future counterGetData({required Map<String, String> headers, body}) async {
    var rawData;
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      rawData = response.body;
      var data = jsonDecode(response.body);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future uploadFileData(String filePath, String fileName, String extension,
      Map<String, String> headers) async {
    var rawData;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.files.add(http.MultipartFile.fromString('name', fileName));
      request.files.add(http.MultipartFile.fromString('extension', extension));
      request.headers.addAll(headers);
      var res = await request.send();
      final respStr = await res.stream.bytesToString();
      rawData = respStr;
      var data = jsonDecode(respStr);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future uploadCareer(
      String filePath,
      String fullName,
      String email,
      String mobile,
      String address,
      String message,
      String requirement,
      Map<String, String> headers) async {
    var rawData;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('cv', filePath));
      request.files.add(http.MultipartFile.fromString('name', fullName));
      request.files.add(http.MultipartFile.fromString('email', email));
      request.files.add(http.MultipartFile.fromString('mobile', mobile));
      request.files.add(http.MultipartFile.fromString('address', address));
      request.files.add(http.MultipartFile.fromString('message', message));
      request.files
          .add(http.MultipartFile.fromString('applied_for', requirement));
      request.headers.addAll(headers);
      var res = await request.send();
      final respStr = await res.stream.bytesToString();
      rawData = respStr;
      var data = jsonDecode(respStr);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future uploadDesign(String filePath, String fullName, String email,
      String mobile, String message, Map<String, String> headers) async {
    var rawData;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.files.add(http.MultipartFile.fromString('name', fullName));
      request.files.add(http.MultipartFile.fromString('email', email));
      request.files.add(http.MultipartFile.fromString('mobile', mobile));
      request.files.add(http.MultipartFile.fromString('message', message));
      request.headers.addAll(headers);
      var res = await request.send();
      final respStr = await res.stream.bytesToString();
      rawData = respStr;
      var data = jsonDecode(respStr);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }

  Future updateAlbums(String tokenString, String titleString,
      String descriptionString, String status, var customFieldArray) async {
    var rawData;
    try {
      Map<String, String> headerParameters = {
        'Authorization': 'Bearer $tokenString',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request = http.Request('PUT', Uri.parse(url));
      request.bodyFields.addAll(customFieldArray);
      request.headers.addAll(headerParameters);
      var res = await request.send();
      final respStr = await res.stream.bytesToString();

      rawData = respStr;
      var data = jsonDecode(respStr);
      var formattedData = data;
      formattedData["status"] = true;
      return formattedData;
    } on SocketException {
      var errorData = socketExceptionError(url);
      return errorData;
    } on HttpException {
      var errorData = httpExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    } on FormatException {
      var errorData = formatExceptionError(rawData: rawData, apiLInk: url);
      return errorData;
    }
  }
}

socketExceptionError(String apiLInk) async {
  var data = {
    "status": false,
    "success": 0,
    "errorAssets": 'assets/no_network.json',
    "msg": "No Network Connection"
  };

  return data;
}

httpExceptionError({var rawData, required String apiLInk}) async {
  var data = {
    "status": false,
    "success": 0,
    "msg": "No Server Response",
    "errorAssets": 'assets/error.json',
  };

  return data;
}

Future<Map> formatExceptionError({var rawData, required String apiLInk}) async {
  var data = {
    "status": false,
    "success": 0,
    "errorAssets": 'assets/error.json',
    "msg": "Server Error,\nPlease try later"
  };
  return data;
}
