import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cn/bean/wx_fragment_bean_entity.dart';
import 'package:flutter_cn/net/Api.dart';
import 'package:flutter_cn/net/Http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WxFragmentPage extends StatefulWidget {
  final id;

  WxFragmentPage(this.id);

  @override
  _WxFragmentPageState createState() => _WxFragmentPageState();
}

class _WxFragmentPageState extends State<WxFragmentPage> {
  var _curPage = 1;
  var listData = [];
  RefreshController _refreshController = RefreshController(
      initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _wxFragmentData(widget.id, _curPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("刷新完成");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("加载失败，点击重新加载");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("释放刷新");
              } else {
                body = Text("没有更多数据");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            itemBuilder: (c, i) => renderRow(i),
            itemCount: listData.length,
          ),
        )
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    if (mounted)
      setState(() {
        _curPage = 1;
        _wxFragmentData(widget.id, _curPage);
      });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted)
      setState(() {
        _curPage++;
        _wxFragmentData(widget.id, _curPage);
      });
    _refreshController.loadComplete();
  }

  renderRow(int i) {
    // 得到列表item的数据
    var itemData = listData[i];

    var row = new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // 左边是标题，时间，评论数等信息
        Expanded(
          flex: 1,
          child: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                    Widget>[
                  new Text(
                    itemData.author,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff333333),
                    ),
                  ),
                  SizedBox(width: 10),
                  DecoratedBox(
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.blue, width: 1),
                        // 边色与边宽度
                        color: Color(0xFFFFFFFF),
                        // 底色
                        //        shape: BoxShape.circle, // 圆形，使用圆形时不可以使用borderRadius
                        shape: BoxShape.rectangle,
                        // 默认值也是矩形
                        borderRadius: new BorderRadius.circular((5.0)), // 圆角度
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 1.0),
                        child: Text(
                          "${itemData.superChapterName}",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ))
                ]),
                SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: new Text(
                        itemData.title,
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Text(
                      itemData.superChapterName,
                      style: TextStyle(color: Color(0xff666666), fontSize: 14),
                    ),
                    Text(
                      " - ${itemData.chapterName}",
                      style: TextStyle(color: Color(0xff666666), fontSize: 14),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
    //InkWell实现点击出现水波纹的效果
    return new InkWell(
      child: row,
      onTap: () {}
    );
  }

  void _wxFragmentData(id, int curPage) {
    var url = Api.WX_FRAGMENT_URL + id + "/" + curPage.toString() + "/json";
    Http.get(url).then((data) {
      WxFragmentBeanData datas = WxFragmentBeanData.fromJson(data);
      setState(() {
        if (curPage == 1) {
          listData.clear();
          listData.addAll(datas.datas);
        } else {
          listData.addAll(datas.datas);
        }
      });
    });
  }
}
