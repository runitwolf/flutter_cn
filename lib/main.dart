import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_cn/page/CollectPage.dart';
import 'package:flutter_cn/page/Login.dart';
import 'package:flutter_cn/page/Mine.dart';
import 'package:flutter_cn/page/NewsListPage.dart';
import 'package:flutter_cn/page/Register.dart';
import 'package:flutter_cn/page/TreePage.dart';
import 'package:flutter_cn/page/WxPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//首页
void main() {
  runApp(new MyApp());
  //判断如果是Android版本的话 设置Android状态栏透明沉浸式
  if (Platform.isAndroid) {
    //沉浸式状态栏
    //写在组件渲染之后，是为了在渲染后进行设置赋值，覆盖状态栏，写在渲染之前对MaterialApp组件会覆盖这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          "/Login": (context) => Login(),
          "/Register": (context) => Register(),
          "/CollectPage": (context) => CollectPage(),
        },
        title: "我只是显示而已",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Color(0xff1594FA)),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Main();
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  var tabTitles = ['文章', '体系', '公众号', '我的'];
  int _tabIndex = 0;
  final TextStyle tabTextStyleNormal= new TextStyle(color: const Color(0xff2c2c2c));
  final TextStyle tabTextStyleSelect = new TextStyle(color: const Color(0xff1594FA));
  var _body;
  // 底部菜单栏图标数组
  var tabImages;


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    initData();

    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          tabTitles[_tabIndex],
//          style: TextStyle(
//            color: Colors.white,
//          ),
//        ),
//        centerTitle: true,
//      ),

      body: _body,
      bottomNavigationBar: new CupertinoTabBar(
        items: getBottomNavigationBarItem(),
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }



  TextStyle getTabTextStyle(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabTextStyleSelect;
    } else {
      return tabTextStyleNormal;
    }
  }

  void initData() {
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('images/ic_nav_news_normal.png'),
          getTabImage('images/ic_nav_news_actived.png')
        ],
        [
          getTabImage('images/ic_nav_tweet_normal.png'),
          getTabImage('images/ic_nav_tweet_actived.png')
        ],
        [
          getTabImage('images/ic_nav_discover_normal.png'),
          getTabImage('images/ic_nav_discover_actived.png')
        ],
        [
          getTabImage('images/ic_nav_my_normal.png'),
          getTabImage('images/ic_nav_my_pressed.png')
        ]
      ];
    }

    _body = new IndexedStack(
      children: <Widget>[
        new NewsListPage(),
        new TreePage(),
        new WxPage(),
        new Mine()
      ],
      index: _tabIndex,
    );
  }

  // 生成image组件
  Image getTabImage(path) {
    return new Image.asset(path, width: 20.0, height: 20.0);
  }

  List<BottomNavigationBarItem> getBottomNavigationBarItem() {
    List<BottomNavigationBarItem> list = new List();
    for (int i = 0; i < 4; i++) {
      list.add(new BottomNavigationBarItem(
          icon: getTabIcon(i),
          title: getTabTitle(i)));
    }
    return list;
  }

  // 获取图标
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }



  Text getTabTitle(int curIndex) {
    return Text(
      tabTitles[curIndex],
      style: getTabTextStyle(curIndex),
    );
  }
}
