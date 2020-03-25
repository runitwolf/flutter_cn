import 'package:flutter/material.dart';
import 'package:flutter_cn/net/Api.dart';
import 'package:flutter_cn/net/Http.dart';
import 'package:flutter_cn/net/LoginEvent.dart';
import 'package:flutter_cn/net/OsApplication.dart';
import 'package:flutter_cn/utils/SpUtils.dart';
import 'package:flutter_cn/utils/ToastUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    //手机号的控制器
    TextEditingController phoneController = TextEditingController();

    //密码的控制器
    TextEditingController passController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          title: Text("登录"),
          centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset("images/shanghai.jpg"),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        icon: Icon(Icons.phone),
                        labelText: '请输入你的用户名',
                      ),
                      autofocus: false,
                    ),
                    TextField(
                        controller: passController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          icon: Icon(Icons.lock),
                          labelText: '请输入密码)',
                        ),
                        obscureText: true),
                    SizedBox(height: 20),
                    GestureDetector(
                      child: Container(
                      alignment: Alignment.centerRight,
                        child: Text(
                          "没有账号？点我去注册", style: TextStyle(
                            color: Colors.blue
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/Register");
                      },
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      onPressed: () {
                        _postLogin(phoneController.text,passController.text);
                      },
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(100,0,100,0),
                        child: Text(
                          '登录',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _postLogin(String userName,String userPassword) {
    if (userName.isNotEmpty && userPassword.isNotEmpty) {
      Map<String, String> params = new Map();
      params['username'] = userName;
      params['password'] = userPassword;
      Http.post(Api.USER_LOGIN, params: params, saveCookie: true)
          .then((result) {
        SpUtils.map2UserInfo(result).then((userInfoBean) {
          if (userInfoBean != null) {
            OsApplication.eventBus.fire(new LoginEvent(userInfoBean.username));
            SpUtils.saveUserInfo(userInfoBean);
            Navigator.pop(context);
          }
        });
      });
    } else {
      ToastUtils.showToast('请输入用户名和密码');
    }
  }
}
