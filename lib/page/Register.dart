import 'package:flutter/material.dart';
import 'package:flutter_cn/net/Api.dart';
import 'package:flutter_cn/net/Http.dart';
import 'package:flutter_cn/net/LoginEvent.dart';
import 'package:flutter_cn/net/OsApplication.dart';
import 'package:flutter_cn/utils/SpUtils.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    //手机号的控制器
    TextEditingController phoneController = TextEditingController();

    //密码的控制器
    TextEditingController passController = TextEditingController();
    TextEditingController againPassController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '注册',
        ),
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
                    TextField(
                        controller: againPassController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          icon: Icon(Icons.lock),
                          labelText: '请再次输入密码)',
                        ),
                        obscureText: true),
                    SizedBox(height: 20),
                    RaisedButton(
                      onPressed: () {
                        _postRegister(
                            phoneController.text, passController.text,againPassController.text);
                      },
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                        child: Text(
                          '注册',
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

  void _postRegister(String phone, String pwd, String againPwd) {
    if (phone.isNotEmpty && pwd.isNotEmpty&& againPwd.isNotEmpty) {
      Map<String,String> params= new Map();
      params['username'] = phone;
      params['password'] = pwd;
      params['repassword'] = againPwd;
      Http.post(Api.USER_REGISTER,params: params,saveCookie: true).then((data){
        print("data==="+data.toString());
        SpUtils.map2UserInfo(data).then((userInfoBean) {
          if (userInfoBean != null) {
            OsApplication.eventBus.fire(new LoginEvent(userInfoBean.username));
            SpUtils.saveUserInfo(userInfoBean);
            Navigator.pop(context);
          }
        });
      });

    }
  }
}
