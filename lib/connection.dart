import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'server_strings.dart';

class Connection {
  Connection();

  final String _serverAddress = kServerAddress;
  String _token;

  Future postRequest({@required body, @required endpoint}) async {
    print('Server Address : ' + _serverAddress + endpoint);
    print('Connection: ' + body);

//    await sharedPref();
    http.Response response;

    try {
      response = await http.post(_serverAddress + endpoint,
          headers: {kContentType: kApplicationJson, kConnection: kKeepAlive},
          body: body);
      print('Response Code : ${response.statusCode.toString()}' +
          '\n' +
          'Response body : ' +
          jsonDecode(response.body).toString());
      return (response);
    } on SocketException catch (e) {
      http.Response response = http.Response("{}", 101);
      print(e);
      return (response);
    } on FormatException catch (e) {
      http.Response response = http.Response("{}", 204);
      print(e);
      return (response);
    }
  }

  Future putRequest(
      {@required body, @required endpoint, @required context}) async {
    print('Server Address : ' + _serverAddress + endpoint);
    print('Connection: ' + body);

    await sharedPref();
    http.Response response;

    try {
      response = await http.put(_serverAddress + endpoint,
          headers: {
            kContentType: kApplicationJson,
            kAuthorization: _token ?? ''
          },
          body: body);
      print('Response Code : ${response.statusCode.toString()}' +
          '\n' +
          'Response body : ' +
          jsonDecode(response.body).toString());
      return (response);
    } on SocketException catch (e) {
      http.Response response = http.Response("{}", 101);
      print(e);
      return (response);
    } on FormatException catch (e) {
      http.Response response = http.Response("{}", 204);
      print(e);
      return (response);
    }
  }

//  Future<void> sharedPref() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    _token = prefs.getString('token') ?? '';
//    print('token : ' + _token);
}
