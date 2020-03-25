import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cn/net/Api.dart';
import 'package:flutter_cn/net/Http.dart';
import 'package:flutter_cn/net/HttpUtil.dart';
import 'package:flutter_cn/utils/SpUtils.dart';
import 'package:flutter_cn/bean/test_bean_entity.dart';
import 'dart:convert';

class CollectPage extends StatefulWidget {
  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _collectData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的收藏"),
        centerTitle: true,
      ),
//      body: ,
    );
  }

  void _collectData() {
    String url = Api.COLLECT_URL + "0/json";

    Http.get(url,saveCookie: true).then((data) {
      setState(() {
        TestBeanData datas = TestBeanData.fromJson(data);
        print("0000000" + datas.curPage.toString());
      });

    });
  }
}
