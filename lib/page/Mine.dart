import 'package:flutter/material.dart';
import 'package:flutter_cn/net/LoginEvent.dart';
import 'package:flutter_cn/net/OsApplication.dart';
import 'package:flutter_cn/page/CollectPage.dart';
import 'package:flutter_cn/utils/SpUtils.dart';
import 'package:flutter_cn/utils/ToastUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Mine extends StatefulWidget {
  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  var userName;
  String userAvatar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();
    OsApplication.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        if (event != null && event.userName != null) {
          userName = event.userName;
          userAvatar = 'http://www.wanandroid.com/resources/image/pc/logo.png';
        } else {
          userName = null;
          userAvatar = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            width: ScreenUtil.screenWidth,
            height: 200,
            color: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                userAvatar == null
                    ? Image.asset("images/ic_icon.png", width: 80, height: 80)
                    : Container(
                        width: 80,
                        height: 80,
                        child: Image.network(userAvatar)),
                SizedBox(height: 5),
                GestureDetector(
                  child: Text(
                    userName == null ? '"去登陆"' : userName,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/Login');
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                InkWell(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "我的收藏",
                            style: TextStyle(
                                color: Color(0xff000000), fontSize: 16),
                          ),
                        ),
                        Image.asset("images/ic_arrow_right.png",
                            width: 15, height: 15),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/CollectPage");
                    }),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "我的积分",
                        style:
                            TextStyle(color: Color(0xff000000), fontSize: 16),
                      ),
                    ),
                    Image.asset("images/ic_arrow_right.png",
                        width: 15, height: 15),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _getUserInfo() async {
    SpUtils.getUserInfo().then((userInfoBean) {
      if (userInfoBean != null && userInfoBean.username != null) {
        setState(() {
          userName = userInfoBean.username;
          userAvatar = 'http://www.wanandroid.com/resources/image/pc/logo.png';
        });
      }
    });
  }
}
