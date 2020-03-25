import 'package:flutter/material.dart';
import 'package:flutter_cn/bean/TitleBean.dart';
import 'package:flutter_cn/bean/wx_bean_entity.dart';
import 'package:flutter_cn/net/Api.dart';
import 'package:flutter_cn/net/Http.dart';
import 'package:flutter_cn/page/WxFragmentPage.dart';
import 'package:flutter_cn/page/WxFragmentPage.dart';

class WxPage extends StatefulWidget {
  @override
  _WxPageState createState() => _WxPageState();
}

class _WxPageState extends State<WxPage> with SingleTickerProviderStateMixin {
  final List<TitleBean> tabs = <TitleBean>[];
  TabController _tabController;
  var wxData = [];

  @override
  void initState() {
    super.initState();
    _wxData();
  }

  void _wxData() {
    Http.get(Api.WX_URL).then((data) {
      setState(() {
        wxData.addAll(data);
        for (int i = 0; i < wxData.length; i++) {
          WxBeanData data1 = WxBeanData.fromJson(wxData[i]);
          tabs.add(new TitleBean(id:data1.id,text:data1.name));
        }
      });
      _tabController =
      new TabController(vsync: this, length: tabs.length); //需要控制的Tab页数量

    });
  }

  //当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,//默认显示第几个
      length: tabs.length,//有几个tab页面
      child: Scaffold(
          appBar: AppBar(
              title:Row(
                children: <Widget>[
                  Expanded(
                    child:  TabBar(
                      labelColor:Color(0xffffffff),
                      unselectedLabelColor:Color(0xff000000),
                      isScrollable: true,
                      //将tab放在appbar中
                      tabs: tabs.map((tab){
                        return Text(tab.text);
                      }).toList(),
                    ),
                  )
                ],
              )
          ),
          body: TabBarView(
            children: tabs.map((tab){
            return WxFragmentPage("${tab.id}");
            }).toList(),
          )
      ),
    );
  }
}
