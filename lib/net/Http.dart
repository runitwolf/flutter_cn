import 'package:flutter_cn/net/OsApplication.dart';
import 'package:flutter_cn/utils/SpUtils.dart';
import 'package:flutter_cn/utils/ToastUtils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_cn/net/Api.dart';
import 'package:http/http.dart';

class Http {
  static Future<dynamic> get(String url,
      {Map<String, String> params, bool saveCookie = false}) async {
//    String _url = Api.BASE_URL + url;
    if (params == null) {
      params = new Map();
    }
    String _url = Api.BASE_URL + url;
    if (params != null && params.isNotEmpty) {
      StringBuffer sb = new StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=$value" + "&");
      });
      String paramStr = sb.toString();
      print('参数是$params');
      paramStr = paramStr.substring(0, paramStr.length - 1);
      _url += paramStr;
    }
    print('url是$_url');
    Map<String, String> header = await getHeader(saveCookie);
    http.Response res = await http.get(_url, headers: header);
    if (res.statusCode == 200) {
      String body = res.body;
      var jsonStr = json.decode(body);
      var errCode = jsonStr['errorCode'];
      if (errCode == 0) {
        dynamic data = jsonStr['data'];
        return data;
      } else {
        ToastUtils.showToast(jsonStr['errorMsg']);
      }
    } else {
      ToastUtils.showToast("网络有问题");
    }
  }

  static Future<Map> post(String url,
      {Map<String, String> params,
      Map<String, String> header,
      bool saveCookie = false}) async {
//      if(params == null) {
//        params = new Map();
//      }
//
//      if(header == null) {
//        header = new Map();
//      }

    String _url = Api.BASE_URL + url;
    print('url是$_url');
//    if (OsApplication.cookie != null) {
//      params['Cookie'] = OsApplication.cookie;
//      print("Cookie" + OsApplication.cookie);
//    }

    http.Response res = await http.post(_url, body: params);
    return _dealWithRes(res, saveCookie: saveCookie);
  }

  static Map<String, dynamic> _dealWithRes(Response res, {bool saveCookie}) {
    if (res.statusCode == 200) {
      var cookie = res.headers['set-cookie'];
      if (saveCookie) {
        SpUtils.saveCookie(cookie);
        OsApplication.cookie = cookie;
      }
      String body = res.body;
      var jsonStr = json.decode(body);
      int errCode = jsonStr['errorCode'];
      if (errCode == 0) {
        var data = jsonStr['data'];
        return data;
      } else {
        ToastUtils.showToast(jsonStr['errorMsg']);
      }
    } else {
      ToastUtils.showToast('网络有问题');
    }
  }

   static Future<Map<String, String>> getHeader(bool saveCookie) async{
    if (saveCookie) {
      Map<String, String> _headerMap = Map();
      if (OsApplication.cookie != null) {
        _headerMap["Cookie"] = OsApplication.cookie;
        print("_headerMap1=====" + _headerMap.toString());
      } else {
        _headerMap["Cookie"] =  await SpUtils.getCookie();
      }
      return _headerMap;
    }
  }
}
